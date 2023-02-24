import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:on_the_road/UI/Profile.dart';

import 'Services/MapServices.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

late double longitude;
late double latitude;

class MapScreen extends StatefulWidget {
  final double longitude;
  final double latitude;
  final String token;

  const MapScreen({
    super.key,
    required this.token,
    required this.longitude,
    required this.latitude,
  });
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  MapServices services = MapServices();
  var markersOnMap = HashSet<Marker>();
  late BitmapDescriptor bitmap;
  late BitmapDescriptor currentBitmap;
  late Position position;
  late double speed = 0.0;
  double pastLong = 0.0;
  double pastLat = 0.0;
  late double _apiSpeed = 0.0;
  late StreamSubscription<Position> positionStream;

  void customizeBitmap() async {
    bitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/stopSign.png');
    currentBitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/currentLocation.png');
  }

  Future<void> getLiveLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        markersOnMap = services.bitmapLiveLocation(markersOnMap, position, currentBitmap);
        _apiSpeed = position.speed*3.6;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18,
              tilt: 80,
              bearing: 50,
            ),
          ),
        );
      });
    });
  }

  void update(double long, double lat) {
    setState(() {
      longitude = long;
      latitude = lat;
    });
  }

  @override
  void initState() {
    super.initState();
    customizeBitmap();
    getLiveLocation();
    update(widget.longitude, widget.latitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffEE6262),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 0.1), // changes position of shadow
                        ),
                      ]),
                  height: 80,
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    child: Center(
                      child: Text(
                        "Current Speed: ${_apiSpeed.toStringAsFixed(2)},\n Manual Speed: ${speed.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'tajawal',
                            color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    // target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                    tilt: 80,
                    bearing: 50,
                    target: LatLng(latitude, longitude),
                    zoom: 20,
                  ),
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                    MapServices services = MapServices();

                    var response = await services.getSigns(widget.token);
                    var data = json.decode(response.body);

                    setState(() {
                      for (int i = 0; i < data.length; i++) {
                        markersOnMap.add(
                          Marker(
                            markerId: MarkerId('$i'),
                            position: LatLng(
                                data[i]['location']['coordinates'][1],
                                data[i]['location']['coordinates'][0]),
                            icon: bitmap,
                          ),
                        );
                      }
                    });
                  },
                  markers: markersOnMap,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Color(0xffEEEEEE), spreadRadius: 1),
              ],
            ),
            height: 70,
            margin: const EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Container(
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          MapServices services = MapServices();
                          await services.getCurrentLocation();
                          var x = services.long;
                          var y = services.lat;
                          Future.delayed(const Duration(seconds: 7), () async {
                            await services.getCurrentLocation();
                            var x_2 = services.long;
                            var y_2 = services.lat;
                            setState(() {
                              speed =
                                  Geolocator.distanceBetween(y, x, y_2, x_2);
                              speed /= 7;
                              speed *= 3.6;
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.navigation_outlined,
                          size: 35,
                          color: Colors.lightBlue,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.analytics_outlined,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings_applications_outlined,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Profile(token: widget.token,);
                        }));
                      },
                        icon: CircleAvatar(
                        radius: 18,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                            child: Image.asset('images/admin.png')),
                      ),)

                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
