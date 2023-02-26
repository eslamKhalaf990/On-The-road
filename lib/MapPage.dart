import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:on_the_road/UI/Settings.dart';
import 'package:tilt/tilt.dart';
import 'package:on_the_road/UI/Profile.dart';

import 'Services/MapServices.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'cam_model.dart';

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
  Set<Marker> markersOnMap = {};
  late BitmapDescriptor bitmap;
  late BitmapDescriptor currentBitmap;
  late Position position;
  late double speed = 0.0;
  double pastLong = 0.0;
  double pastLat = 0.0;
  late Color _activeColor = Colors.grey;
  late double _apiSpeed = 0.0;
  late StreamSubscription<Position> positionStream;
  OverlayEntry? camEntry;
  Offset camOffset = const Offset(15, 20);

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
      distanceFilter: 0,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      double zoomLevel = await controller.getZoomLevel();
      setState(() {
        markersOnMap =
            services.bitmapLiveLocation(markersOnMap, position, currentBitmap);
        _apiSpeed = position.speed * 3.6;

        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: zoomLevel,
              tilt: 90,
              bearing: 10,
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
    // getLiveLocation();
    update(widget.longitude, widget.latitude);

    if (camMood) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showFloatingCam();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    hideFloatingCam();
    positionStream.cancel();
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
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 0.1), // changes position of shadow
                        ),
                      ]),
                  height: 75,
                  margin: const EdgeInsets.only(
                      left: 2, right: 2, top: 5, bottom: 3),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(35)),
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
              margin: const EdgeInsets.only(left: 2, right: 2, bottom: 0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                child: GoogleMap(
                  onTap: (LatLng l) {
                    setState(() {
                      markersOnMap.add(
                        Marker(
                          markerId: MarkerId(
                              'markerToAdd ${l.longitude}, ${l.latitude}'),
                          position: LatLng(
                            l.latitude,
                            l.longitude,
                          ),
                          icon: currentBitmap,
                        ),
                      );
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    // target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                    tilt: 90,
                    // bearing: 0,
                    target: LatLng(latitude, longitude),
                    zoom: 25,
                  ),
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                    await updateSignsOnMap();
                  },
                  markers: markersOnMap,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    // color: Color(0xffEEEEEE),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 0.1), // changes position of shadow
                  ),
                ]),
            height: 70,
            margin: const EdgeInsets.only(left: 2, right: 2, top: 3, bottom: 3),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Container(
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _activeColor = Colors.green;
                          getLiveLocation();
                          // MapServices services = MapServices();
                          // await services.getCurrentLocation();
                          // var x = services.long;
                          // var y = services.lat;
                          // Future.delayed(const Duration(seconds: 7), () async {
                          //   await services.getCurrentLocation();
                          //   var x_2 = services.long;
                          //   var y_2 = services.lat;
                          //   setState(() {
                          //     speed =
                          //         Geolocator.distanceBetween(y, x, y_2, x_2);
                          //     speed /= 7;
                          //     speed *= 3.6;
                          //   });
                          // });
                        },
                        icon: Icon(
                          Icons.navigation_outlined,
                          size: 35,
                          color: _activeColor,
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
                      IconButton(
                        onPressed: () {
                          if (_activeColor == Colors.green) {
                            positionStream.cancel();
                          }
                          setState(() {
                            _activeColor = Colors.grey;
                          });
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Profile(
                              token: widget.token,
                            );
                          }));
                        },
                        icon: CircleAvatar(
                          radius: 18,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                              child: Image.asset('images/admin.png')),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> updateSignsOnMap() async {
    MapServices services = MapServices();

    var response = await services.getSigns(widget.token);
    var data = json.decode(response.body);

    setState(() {
      for (int i = 0; i < data.length; i++) {
        markersOnMap.add(
          Marker(
            markerId: MarkerId('$i'),
            position: LatLng(data[i]['location']['coordinates'][1],
                data[i]['location']['coordinates'][0]),
            icon: bitmap,
          ),
        );
      }
    });
  }

  void showFloatingCam() {
    camEntry = OverlayEntry(
        builder: (context) => Positioned(
            right: camOffset.dx,
            bottom: camOffset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                camOffset -= details.delta;
                camEntry!.markNeedsBuild();
              },
              child: floatingItem(),
            )));
    final overlay = Overlay.of(context)!;
    overlay.insert(camEntry!);
  }

  hideFloatingCam() {
    camEntry?.remove();
    camEntry = null;
  }

  Widget floatingItem() {
    return const Camera();
  }
}
