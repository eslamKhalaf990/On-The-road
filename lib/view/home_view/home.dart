import 'dart:async';
import 'package:on_the_road/Services/position_stream.dart';
import 'package:on_the_road/constants/constants_on_map.dart';
import 'package:on_the_road/model/settings.dart';
import 'package:on_the_road/view/home_view/widgets/questionBox.dart';
import 'package:on_the_road/view/settings/settings.dart';
import 'package:on_the_road/view/statistics_view/statistics.dart';
import 'package:provider/provider.dart';
import '../../Services/map_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../user_view/Profile.dart';
import 'package:on_the_road/detection_model/RunModelByCameraDemo.dart';

final Constants constants = Constants();

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final MapServices services = MapServices();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late AnimationController _animationController;
  late Animation<double> _lineAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 10), // 10 seconds duration
      vsync: this,
    );

    _lineAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showMessageBox() {
    setState(() {
      _isVisible = true;
    });

    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PositionStream>(
      builder: (BuildContext context, stream, child) {
        return Scaffold(
          body: Column(
            children: [
              SafeArea(
                child: Stack(children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black12,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                // color: stream.navigation.warningColor,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 0.1),
                              ),
                            ]),
                        height: 100,
                        margin: const EdgeInsets.only(
                            left: 2, right: 2, top: 5, bottom: 3),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(35)),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                child: Material(
                                  // color: Colors.grey[50],
                                  color: Colors.black12,
                                  elevation: 20,
                                  child: SizedBox(
                                    height: 98,
                                    width: 120,
                                    child: Center(
                                      child: Text(
                                        "${stream.navigation.currentSpeed.toStringAsFixed(2)} km/h\n"
                                        "${stream.navigation.avgSpeed.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'tajawal',
                                          // color: Colors.black54,
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
                                  stream.navigation.warning,
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
                  questionBoxWidget(
                      isVisible: _isVisible, lineAnimation: _lineAnimation)
                ]),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: Stack(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(left: 2, right: 2, bottom: 0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                          child: GoogleMap(
                            onTap: (LatLng l) {
                              stream.markersOnMap.add(
                                Marker(
                                  markerId: MarkerId(
                                      'markerToAdd ${l.longitude}, ${l.latitude}'),
                                  position: LatLng(
                                    l.latitude,
                                    l.longitude,
                                  ),
                                  icon: constants.currentBitmap,
                                ),
                              );
                            },
                            mapType:
                                Provider.of<SettingsModel>(context).mapTheme,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  Provider.of<User>(context).location.latitude,
                                  Provider.of<User>(context)
                                      .location
                                      .longitude),
                              // tilt: 90,
                              zoom: 14,
                            ),
                            onMapCreated: (controller) async {
                              _controller.complete(controller);
                            },
                            markers: {
                              ...Set<Marker>.from(
                                stream.markersOnMap.map((marker) => marker),
                              ),
                              stream.isStreaming
                                  ? Marker(
                                      markerId:
                                          const MarkerId('currentLocation'),
                                      position: LatLng(
                                          stream.navigation.position.latitude,
                                          stream.navigation.position.longitude),
                                      icon: constants.currentBitmap,
                                    )
                                  : Marker(
                                      markerId:
                                          const MarkerId('currentLocation'),
                                      position: LatLng(
                                          Provider.of<User>(context)
                                              .location
                                              .latitude,
                                          Provider.of<User>(context)
                                              .location
                                              .longitude),
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                              10),
                                    ),
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16.0,
                        left: 2.0,
                        right: 2.0,
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black54,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                spreadRadius: 4,
                                blurRadius: 2,
                                offset: Offset(
                                    0, 0.1), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (!stream.isStreaming) {
                                    constants.activeColor = Colors.green;
                                    stream.streamPosition(
                                        _controller,
                                        services,
                                        Provider.of<User>(context,
                                                listen: false)
                                            .token,
                                        constants,
                                        Provider.of<SettingsModel>(context,
                                                listen: false)
                                            .locationAccuracy);
                                    stream.addMarkers(
                                        constants,
                                        Provider.of<User>(context,
                                                listen: false)
                                            .token);
                                  }
                                },
                                icon: Icon(
                                  Icons.home,
                                  size: 30,
                                  color: constants.activeColor,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                onPressed: () {
                                  if (stream.isStreaming) {
                                    stream.positionStream.cancel();
                                    stream.isStreaming = false;
                                    constants.activeColor = Colors.white;
                                  }
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return RunModelByCameraDemo();
                                  }));
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  // color: Colors.grey,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Statistics();
                                  }));
                                },
                                icon: const Icon(
                                  Icons.analytics_outlined,
                                  size: 30,
                                  // color: Colors.grey,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const SettingsView();
                                  }));
                                },
                                icon: const Icon(
                                  Icons.settings_applications_outlined,
                                  size: 30,
                                  // color: Colors.wh,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                onPressed: () {
                                  _showMessageBox();
                                },
                                // onPressed: _showMessageBox,
                                icon: const Icon(
                                  Icons.message,
                                  size: 30,
                                  // color: Colors.wh,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                onPressed: () {
                                  if (constants.activeColor == Colors.green) {}
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Profile();
                                  }));
                                },
                                icon: CircleAvatar(
                                  radius: 30,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
