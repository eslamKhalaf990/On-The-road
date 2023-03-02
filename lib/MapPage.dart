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
import 'package:flutter_tts/flutter_tts.dart';

import 'checks.dart';

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
  late BitmapDescriptor stopSignbitmap;
  late BitmapDescriptor currentBitmap;
  late BitmapDescriptor trafficLightBitmap;
  late Position currentPosition;
  late double speed = 0.0;
  double pastLong = 0.0;
  double pastLat = 0.0;
  late Color _activeColor = Colors.grey;
  late double _apiSpeed = 0.0;
  late String warning = "";
  late Color warningColor = Colors.grey;
  late StreamSubscription<Position> positionStream;
  late var signsOnMap;
  late List<DateTime> lastNotified;
  OverlayEntry? camEntry;
  Offset camOffset = const Offset(15, 20);

  void customizeBitmap() async {
    stopSignbitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/stopSign.png');
    currentBitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/currentLocation.png');
    trafficLightBitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/TrafficLight.png');
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

      // var response = await services.getSigns(widget.token);
      // var data = json.decode(response.body);

      setState(() {
        markersOnMap =
            services.bitmapLiveLocation(markersOnMap, position, currentBitmap);
        _apiSpeed = position.speed * 3.6;
        if (_apiSpeed < 2) {
          _apiSpeed = 0.0;
        }
        currentPosition = position;
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

  void checkForNotifications() {
    double currentLat = 0.0;
    double currentLong = 0.0;

    Timer? checkNotificationsTimer; //to be changed
    checkNotificationsTimer =
        Timer.periodic(const Duration(seconds: 5), (Timer t) {
      try {
        currentLat = currentPosition.latitude;
        currentLong = currentPosition.longitude;
      } catch (e) {}
      for (int i = 0; i < signsOnMap.length; i++) {
        double distance = Geolocator.distanceBetween(
            currentLat,
            currentLong,
            signsOnMap[i]['location']['coordinates'][1],
            signsOnMap[i]['location']['coordinates'][0]);
        if (distance < 100 &&
            (DateTime.now().difference(lastNotified[i]).inMinutes > 1)) {
          notify(i);
        }
      }
    });
  }

  void notify(int index) {
    String text =
        "There Is A ${signsOnMap[index]['name']}\n In Less Than 100 meters";
    setState(() {
      warningColor = Colors.red;
      warning = text;
    });
    speak(text);
    clearWarning();
    lastNotified[index] = DateTime.now();
  }

  void clearWarning() async {
    await Future.delayed(Duration(seconds: 7));
    setState(() {
      warningColor = Colors.grey;
      warning = "";
    });
  }

  final FlutterTts flutterTts = FlutterTts();
  speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.5);
    await flutterTts.speak(text);
  }

  Future<void> checkForNewSigns() async {
    await requestSigns();
    updateSignsOnMap();
    Timer? requestSignsTimer; //to be changed
    requestSignsTimer =
        Timer.periodic(const Duration(minutes: 5), (Timer t) async {
      await requestSigns();
      updateSignsOnMap();
    });
  }

  Future<void> requestSigns() async {
    var response = await services.getSigns(widget.token);
    signsOnMap = json.decode(response.body);
    lastNotified = List.filled(signsOnMap.length, DateTime(2000));
  }

  void update(double long, double lat) {
    setState(() {
      longitude = long;
      latitude = lat;
    });
  }

  void showPopUp() =>
      showDialog(context: context, builder: (context) => checksDialog());
  @override
  void initState() {
    checkForNewSigns();
    super.initState();
    customizeBitmap();
    checkForNotifications();

    // getLiveLocation();
    update(widget.longitude, widget.latitude);
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
                      boxShadow: [
                        BoxShadow(
                          color: warningColor,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 0.1), // changes position of shadow
                        ),
                      ]),
                  height: 100,
                  margin: const EdgeInsets.only(
                      left: 2, right: 2, top: 5, bottom: 3),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(35)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: Material(
                            color: Colors.grey[50],
                            elevation: 20,
                            child: SizedBox(
                              height: 98,
                              width: 98,
                              child: Center(
                                child: Text(
                                  _apiSpeed.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'tajawal',
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            warning,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'tajawal',
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
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
                          if (_activeColor != Colors.green) {
                            showPopUp();
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              showFloatingCam();
                            });
                            _activeColor = Colors.green;
                            getLiveLocation();
                          }
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
                          hideFloatingCam();
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
    setState(() {
      BitmapDescriptor bitmapIcon = stopSignbitmap;
      for (int i = 0; i < signsOnMap.length; i++) {
        if (signsOnMap[i]['name'] == 'Traffic Light') {
          bitmapIcon = trafficLightBitmap;
        } else if (signsOnMap[i]['name'] == 'Stop Sign') {
          bitmapIcon = stopSignbitmap;
        }
        markersOnMap.add(
          Marker(
            markerId: MarkerId('$i'),
            position: LatLng(signsOnMap[i]['location']['coordinates'][1] * 1.0,
                signsOnMap[i]['location']['coordinates'][0] * 1.0),
            icon: bitmapIcon,
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
    return Camera(updateSignsOnMap);
  }
}
