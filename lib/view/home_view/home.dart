import 'dart:async';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:on_the_road/Services/position_stream.dart';
import 'package:on_the_road/constants/constants_on_map.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:on_the_road/model/settings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/view/home_view/search_autocomplete.dart';
import 'package:on_the_road/view/statistics_view/statistics.dart';
import 'package:provider/provider.dart';
import '../../Services/map_services.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../settings/settings.dart';
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

class _HomeState extends State<Home> {
  final MapServices services = MapServices();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Consumer<PositionStream>(
      builder: (BuildContext context, stream, child) {
        return Scaffold(
          body: Column(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Container(
                      decoration: DesignConstants.roundedBorder,
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
                                color: DesignConstants.dark,
                                elevation: 20,
                                child: SizedBox(
                                  height: 98,
                                  width: 120,
                                  child: Center(
                                    child: Text(
                                      "${stream.navigation.currentSpeed.toStringAsFixed(2)} km/h\n"
                                      "${stream.navigation.distanceTraveled.toStringAsFixed(2)} km",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: DesignConstants.fontFamily,
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
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: DesignConstants.fontFamily,
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
                                  icon: constants.userLocation,
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
                            // initialCameraPosition: const CameraPosition(
                            //   zoom: 15.0,
                            //   target: LatLng(45.82917150748776, 14.63705454546316),
                            // ),
                            onMapCreated: (controller) async {
                              _controller.complete(controller);
                            },
                            polylines: {
                              Polyline(
                                polylineId: const PolylineId("route"),
                                points: stream.coordinates,
                                color: Colors.pink.shade600,
                                width: 5,
                              )
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
                                      icon: constants.userLocation,
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
                      Container(
                        margin: const EdgeInsets.all(8),
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return const SearchAutocomplete();
                                }));
                          },
                          backgroundColor: Colors.grey[800],
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
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
                                      context,
                                      services,
                                      Provider.of<User>(context, listen: false)
                                          .token,
                                      constants,
                                      Provider.of<SettingsModel>(context,
                                              listen: false)
                                          .locationAccuracy,
                                    );
                                    stream.addMarkers(
                                      constants,
                                      Provider.of<User>(context, listen: false)
                                          .token,
                                    );
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
                                  // print("drawing route");
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return const SettingsView();
                                      }));
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  size: 30,
                                  // color: Colors.wh,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(seconds: 1),
                                          pageBuilder: (_, __, ___) {
                                            return Profile();
                                          }));
                                },
                                icon: Hero(
                                  tag: "profile",
                                  child: CircleAvatar(
                                    radius: 30,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      child: Image.asset('images/admin.png'),
                                    ),
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
