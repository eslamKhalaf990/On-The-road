import 'dart:async';
import 'package:on_the_road/view/home_view/notifications_list.dart';
import 'package:on_the_road/view/home_view/signs_list.dart';
import 'package:on_the_road/view_model/navigation_on_road_v_m.dart';
import 'package:on_the_road/constants/constants_on_map.dart';
import 'package:on_the_road/model/settings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/view/home_view/search_autocomplete.dart';
import 'package:on_the_road/view/home_view/widgets/bottom_bar.dart';
import 'package:on_the_road/view/home_view/widgets/warning.dart';
import 'package:provider/provider.dart';
import '../../services/map_services.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../../test.dart';
import 'widgets/add_fav_location.dart';

final Constants constants = Constants();

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MapServices services = MapServices();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  void listenToNotification() async {
    await Test.initFirebase(context);
  }

  void startGyro() {
    Provider.of<SettingsModel>(context, listen: false).getGyroState();
    Provider.of<SettingsModel>(context, listen: false).getNotifyDistance();
    Future.delayed(const Duration(seconds: 5), () {
      if (Provider.of<SettingsModel>(context, listen: false).isGyroscopeOn) {
        Provider.of<SettingsModel>(context, listen: false).gyro.start();
      }
    });
  }

  @override
  void initState() {
    listenToNotification();
    startGyro();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationOnRoad>(
      builder: (BuildContext context, stream, child) {
        return Scaffold(
          body: Column(
            children: [
              const Warning(),
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
                            onTap: (LatLng latLng) {
                              stream.addMarker(
                                Marker(
                                  markerId: const MarkerId('favorite place'),
                                  position: LatLng(
                                    latLng.latitude,
                                    latLng.longitude,
                                  ),
                                  icon: constants.userLocation,
                                ),
                              );
                              addFavLocation(context, latLng);
                            },
                            zoomControlsEnabled: false,
                            minMaxZoomPreference:
                                const MinMaxZoomPreference(10, 20),
                            mapType:
                                Provider.of<SettingsModel>(context).mapTheme,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                Provider.of<User>(context).location.latitude,
                                Provider.of<User>(context).location.longitude,
                              ),
                              tilt: 90,
                              zoom: 18,
                            ),
                            onMapCreated: (controller) async {
                              _controller.complete(controller);
                            },
                            polylines: {
                              Polyline(
                                polylineId: const PolylineId("route"),
                                points: stream.navigation.coordinates,
                                color: Colors.pink.shade700,
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
                                            .longitude,
                                      ),
                                      icon: constants.userLocation,
                                    ),
                            },
                          ),
                        ),
                      ),
                      Column(
                        children: [
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
                          Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 8),
                            alignment: Alignment.topRight,
                            child: FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                viewEventsList(context);
                              },
                              backgroundColor: Colors.grey[800],
                              child: const Icon(
                                Icons.notification_add_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 8),
                            alignment: Alignment.topRight,
                            child: FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                SignList signList = SignList();
                                signList.viewAddSignList(context);
                              },
                              backgroundColor: Colors.grey[800],
                              child: const Icon(
                                Icons.signpost_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
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
                          child: BottomBar(
                              controller: _controller, services: services),
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
