import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/speech_text/speak_to.dart';
import 'package:on_the_road/view_model/navigation_on_road_v_m.dart';
import 'package:provider/provider.dart';
import 'package:on_the_road/services/map_services.dart';
import 'package:on_the_road/detection_model/RunModelByCameraDemo.dart';
import 'package:on_the_road/model/settings.dart';
import 'package:on_the_road/model/user.dart';
import 'package:on_the_road/view/settings/settings.dart';
import 'package:on_the_road/view/statistics_view/statistics.dart';
import 'package:on_the_road/view/user_view/Profile.dart';
import 'package:on_the_road/view/home_view/home.dart';

void startNavigation(BuildContext context,
    Completer<GoogleMapController> _controller, MapServices services) {
  constants.activeColor = Colors.green;
  Provider.of<NavigationOnRoad>(context, listen: false).navigateOnRoad(
    _controller,
    context,
    services,
    Provider.of<User>(context, listen: false).token,
    constants,
    Provider.of<SettingsModel>(context, listen: false).locationAccuracy,
  );
  Provider.of<NavigationOnRoad>(context, listen: false).addMarkers(
    constants,
    Provider.of<User>(context, listen: false).token,
  );
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required Completer<GoogleMapController> controller,
    required this.services,
  }) : _controller = controller;

  final Completer<GoogleMapController> _controller;
  final MapServices services;

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationOnRoad>(
      builder: (BuildContext context, stream, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                if (!stream.isStreaming) {
                  startNavigation(context, _controller, services);
                }
              },
              icon: Icon(
                Icons.home,
                size: 30,
                color: constants.activeColor,
              ),
            ),
            IconButton(
              onPressed: () {
                if (stream.isStreaming) {
                  stream.positionStream.cancel();
                  stream.isStreaming = false;
                  constants.activeColor = Colors.white;
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RunModelByCameraDemo();
                }));
              },
              icon: const Icon(
                Icons.camera_alt,
                size: 30,
                // color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                toggleListening(context, _controller, services);
              },
              icon: const Icon(
                Icons.mic_none_outlined,
                size: 30,
                // color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Statistics();
                }));
              },
              icon: const Icon(
                Icons.analytics_outlined,
                size: 30,
                // color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                // print("drawing route");
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingsView();
                }));
              },
              icon: const Icon(
                Icons.settings,
                size: 30,
                // color: Colors.wh,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
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
            ),
          ],
        );
      },
    );
  }
}
