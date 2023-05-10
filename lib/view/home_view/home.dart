import 'dart:async';
import 'dart:convert';
import 'package:on_the_road/Services/position_stream.dart';
import 'package:on_the_road/constants/constants_on_map.dart';
import 'package:on_the_road/view/statistics_view/statistics.dart';
import 'package:on_the_road/view/user_view/Profile.dart';
import '../../Services/map_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../../model/Navigation.dart';
import '../../model/location.dart';
import '../../model/user.dart';

StreamController<Navigation> streamController = StreamController.broadcast();

class MapScreen extends StatefulWidget {
  Location currentLocation = Location();
  final User user;
  final Stream stream;
  MapScreen({
    super.key,
    required this.stream,
    required this.user,
    required this.currentLocation,
  });
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Constants constants = Constants();
  PositionStream positionStream = PositionStream();
  MapServices services = MapServices();
  Set<Marker> markersOnMap = {};
  late Navigation navigation = Navigation();
  Duration duration = const Duration();
  Timer? timer;

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  Future<void> getLiveLocation() async {
    final GoogleMapController controller = await _controller.future;

    positionStream.streamPosition(_controller, controller, services, widget.user.token);

    widget.stream.listen((event) {
      setState(() {
        navigation = event;
        markersOnMap = services.bitmapLiveLocation(
            markersOnMap, navigation.position, constants.currentBitmap);
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                  navigation.position.latitude, navigation.position.longitude),
              zoom: navigation.zoomLevel,
              tilt: 90,
              bearing: 10,
            ),
          ),
        );
        if (navigation.currentSpeed < 2) {
          timer?.cancel();
        } else {
          startTimer();
        }
        print(navigation.warning);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    constants.customizeBitmap();
  }

  @override
  void dispose() {
    super.dispose();
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
                          color: navigation.warningColor,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 0.1),
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
                              width: 120,
                              child: Center(
                                child: Text(
                                  "${navigation.currentSpeed.toStringAsFixed(2)} km/h\n${navigation.avgSpeed.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 20,
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
                            navigation.warning,
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
                          markerId: MarkerId('markerToAdd ${l.longitude}, ${l.latitude}'),
                          position: LatLng(
                            l.latitude,
                            l.longitude,
                          ),
                          icon: constants.currentBitmap,
                        ),
                      );
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    // target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                    tilt: 90,
                    // bearing: 0,
                    target: LatLng(
                        widget.currentLocation.latitude, widget.currentLocation.longitude),
                    zoom: 20,
                  ),
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                    var response = await services.getSigns(widget.user.token);
                    var data = json.decode(response.body);

                    setState(() {
                      markersOnMap = services.setMarkers(
                          markersOnMap, data, constants);
                    });
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
                          constants.activeColor = Colors.green;
                          getLiveLocation();
                        },
                        icon: Icon(
                          Icons.navigation_outlined,
                          size: 35,
                          color: constants.activeColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return Statistics(
                                );
                              }));
                        },
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
                          if (constants.activeColor == Colors.green) {
                            // positionStream.cancel();
                          }
                          setState(() {
                            constants.activeColor = Colors.grey;
                          });
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Profile(
                              user: widget.user,
                            );
                          }));
                        },
                        icon: CircleAvatar(
                          radius: 18,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                            child: Image.asset('images/admin.png'),
                          ),
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
}
