import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/constants/text-speech.dart';
import 'package:on_the_road/ai_models/speech_text/speak_to.dart';
import 'package:on_the_road/model/settings.dart';
import 'package:on_the_road/view/home_view/widgets/dialog_box.dart';
import 'package:provider/provider.dart';
import '../constants/constants_on_map.dart';
import '../model/navigation.dart';
import '../view/home_view/home.dart';
import '../services/map_services.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class NavigationOnRoad extends ChangeNotifier {
  Navigation navigation = Navigation();
  List<ChartData> chartData = <ChartData>[];
  late StreamSubscription positionStream;
  bool isStreaming = false;
  late Timer distanceTime;
  bool analyze = false;
  Set<Marker> markersOnMap = {};
  var signsOnRoad;
  int time = 0;
  int i = 0;
  DateTime lastAsked = DateTime.now().subtract(const Duration(seconds: 10));
  Future<void> navigateOnRoad(
      Completer<GoogleMapController> _controller,
      BuildContext ctx,
      MapServices services,
      String token,
      Constants constants,
      locationAccuracy) async {
    int cnt = 0;
    double sum = 0.0;
    final GoogleMapController mapController = await _controller.future;

    LocationSettings locationSettings = LocationSettings(
      accuracy: locationAccuracy,
      distanceFilter: 0,
    );

    startTimer();
    getSignsAroundUser(services, token);
    sendAvgStat(services, token);
    checkIfSpeedExceeded(services, token);
    getSpeedLimit(services, token);
    if (ctx.mounted) {
      getNearestSign(ctx, _controller, services, token);
    }
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      if ((position.speed * 3.6) < 2) {
        navigation.currentSpeed = 0.0;
      } else {
        navigation.currentSpeed = position.speed * 3.6;
      }
      if (navigation.currentSpeed > navigation.maxSpeed) {
        navigation.maxSpeed = navigation.currentSpeed;
      }

      navigation.position = position;
      isStreaming = true;

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                navigation.position.latitude, navigation.position.longitude),
            zoom: await mapController.getZoomLevel(),
            tilt: 90,
          ),
        ),
      );

      sum += navigation.currentSpeed;
      cnt++;

      navigation.avgSpeed = sum / cnt;

      if (navigation.currentSpeed == 0) {
        if (distanceTime.isActive) {
          distanceTime.cancel();
        }
      } else {
        if (!distanceTime.isActive) {
          startTimer();
        }
        navigation.distanceTraveled =
            (navigation.avgSpeed * 0.277778 * time) / 1000;
      }

      if (analyze) {
        i++;
        if (chartData.length > 19) {
          chartData.removeAt(0);
        }
        chartData.add(
          ChartData("t$i", navigation.currentSpeed),
        );
      }
      notifyListeners();
    });
  }

  void sendAvgStat(MapServices services, String token) {
    Timer.periodic(const Duration(seconds: 600), (timer) async {
      //600
      services.sendDailyStat(
          token,
          navigation.speedBumpDangerous,
          navigation.speedExceeded,
          navigation.speedBump,
          time,
          navigation.maxSpeed.toInt(),
          navigation.maxSpeed.toInt(),
          navigation.distanceTraveled.toInt());
    });
  }

  void checkIfSpeedExceeded(MapServices services, String token) {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (navigation.currentSpeed > navigation.speedLimit) {
        double diff = navigation.currentSpeed - navigation.speedLimit;
        TextSpeech.speak("You are exceeding the speed limit please slow down");
        //tts
        if (diff < 10) {
          services.sendAction(
              token,
              "low risk speed",
              navigation.position.latitude,
              navigation.position.longitude,
              navigation.currentSpeed);
        } else if (diff < 20) {
          services.sendAction(
              token,
              "mid risk speed",
              navigation.position.latitude,
              navigation.position.longitude,
              navigation.currentSpeed);
        } else {
          services.sendAction(
              token,
              "high risk speed",
              navigation.position.latitude,
              navigation.position.longitude,
              navigation.currentSpeed);
        }
        navigation.speedExceeded++;
      }
    });
  }

  void getSpeedLimit(MapServices services, String token) {
    Timer.periodic(const Duration(seconds: 300), (timer) async {
      // take care the return will be Future
      // navigation.speedLimit= mapServices.getSpeedLimit();
    });
  }

  void addMarkers(Constants constants, String token) async {
    if (markersOnMap.isNotEmpty) {
      markersOnMap.clear();
    }
    for (int i = 0; i < signsOnRoad.length; i++) {
      signsOnRoad[i]['notified'] = false;
      markersOnMap.add(
        Marker(
          markerId: MarkerId('$i'),
          position: LatLng(
              signsOnRoad[i]['startLocation']['coordinates'][1] * 1.0,
              signsOnRoad[i]['startLocation']['coordinates'][0] * 1.0),
          icon: signsOnRoad[i]['sign']['name'] == "Traffic Light"
              ? constants.trafficLights
              : signsOnRoad[i]['sign']['name'] == "Speed Bump"
                  ? constants.bump
                  : signsOnRoad[i]['sign']['name'] == "Radar"
                      ? constants.radar
                      : signsOnRoad[i]['sign']['name'] == "Speed 60"
                          ? constants.mph60
                          : signsOnRoad[i]['sign']['name'] == "Speed 100"
                              ? constants.mph100
                              : signsOnRoad[i]['sign']['name'] == "Speed 30"
                                  ? constants.mph30
                                  : signsOnRoad[i]['sign']['name'] == "Speed 80"
                                      ? constants.mph80
                                      : signsOnRoad[i]['sign']['name'] ==
                                              "Speed 90"
                                          ? constants.mph90
                                          : signsOnRoad[i]['sign']['name'] ==
                                                  "Speed 40"
                                              ? constants.mph40
                                              : signsOnRoad[i]['sign']
                                                          ['name'] ==
                                                      "Speed 50"
                                                  ? constants.mph50
                                                  : signsOnRoad[i]['sign']
                                                              ['name'] ==
                                                          "Speed 70"
                                                      ? constants.mph70
                                                      : constants.trafficLights,
        ),
      );
    }
    notifyListeners();
  }

  void getPloyLine(LatLng source, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult route = await polylinePoints.getRouteBetweenCoordinates(
      constants.googleApiKey,
      PointLatLng(
        source.latitude,
        source.longitude,
      ),
      PointLatLng(
        destination.latitude,
        destination.longitude,
      ),
    );
    if (navigation.coordinates.isNotEmpty) {
      navigation.coordinates.removeRange(0, navigation.coordinates.length);
    }
    for (var point in route.points) {
      navigation.coordinates.add(LatLng(point.latitude, point.longitude));
    }
    notifyListeners();
  }

  void getNearestSign(
      BuildContext ctx,
      Completer<GoogleMapController> _controller,
      MapServices services,
      String token) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      for (int i = 0; i < signsOnRoad.length; i++) {
        double distance = Geolocator.distanceBetween(
          navigation.position.latitude,
          navigation.position.longitude,
          signsOnRoad[i]['startLocation']['coordinates'][1],
          signsOnRoad[i]['startLocation']['coordinates'][0],
        );

        if (distance < 5) {
          if (signsOnRoad[i]['sign']['name'] == "Speed Bump") {
            navigation.speedBump++;
            if (navigation.currentSpeed > 15) {
              navigation.speedBumpDangerous++;
              if (navigation.currentSpeed < 20) {
                services.sendAction(
                    token,
                    "speed pumb low risk",
                    navigation.position.latitude,
                    navigation.position.longitude,
                    navigation.currentSpeed);
              } else if (navigation.currentSpeed < 25) {
                services.sendAction(
                    token,
                    "speed pumb mid risk",
                    navigation.position.latitude,
                    navigation.position.longitude,
                    navigation.currentSpeed);
              } else {
                services.sendAction(
                    token,
                    "speed pumb high risk",
                    navigation.position.latitude,
                    navigation.position.longitude,
                    navigation.currentSpeed);
              }
            }
          }
          if (DateTime.now().difference(lastAsked).inSeconds > 15) {
            lastAsked = DateTime.now();
            TextSpeech.speak(
                "Did you find a ${signsOnRoad[i]['sign']['name']}");
            showAutoDismissDialog(
                ctx, "${signsOnRoad[i]['sign']['name']}", signsOnRoad[i]['id']);
            toggleListening(ctx, _controller, services);
          }
        } else if (distance <
                Provider.of<SettingsModel>(ctx, listen: false).notifyDistance &&
            !signsOnRoad[i]["oneWay"] &&
            !signsOnRoad[i]['notified']) {
          signsOnRoad[i]['notified'] = true;
          print("distance: $distance");
          navigation.warning =
              "There Is A ${signsOnRoad[i]['sign']['name']}\n In ${distance.toStringAsFixed(1)} meters";
          TextSpeech.speak(navigation.warning);

          navigation.warningColor = Colors.red;
          break;
        } else if (signsOnRoad[i]["oneWay"]) {
          double oldSign_user = Geolocator.distanceBetween(
            navigation.position.latitude,
            navigation.position.longitude,
            signsOnRoad[i]['endLocation']['coordinates'][1],
            signsOnRoad[i]['endLocation']['coordinates'][0],
          );
          double Sign_oldUser = distance;
          if (navigation.lastLocations.length != 0) {
            Sign_oldUser = Geolocator.distanceBetween(
              navigation.lastLocations.first.latitude,
              navigation.lastLocations.first.longitude,
              signsOnRoad[i]['startLocation']['coordinates'][1],
              signsOnRoad[i]['startLocation']['coordinates'][0],
            );
          }

          if (oldSign_user < 20 && distance < Sign_oldUser) {
            navigation.warning =
                "There Is A ${signsOnRoad[i]['sign']['name']}\n In ${distance.toStringAsFixed(1)} meters";
            TextSpeech.speak(navigation.warning);

            navigation.warningColor = Colors.red;
          }
        } else {
          navigation.warning = "";
          navigation.warningColor = Colors.blue;
        }
      }
    });
  }

  getSignsAroundUser(MapServices services, String token) async {
    await services.getCurrentLocation();
    signsOnRoad = json.decode(
        (await services.getSigns(token, services.lat, services.long)).body);
    addMarkers(constants, token);
    Timer.periodic(const Duration(seconds: 50), (timer) async {
      signsOnRoad = json.decode((await services.getSigns(token,
              navigation.position.latitude, navigation.position.longitude))
          .body);

      addMarkers(constants, token);
      print("Getting Signs on road");
    });
  }

  void startTimer() {
    Timer(const Duration(seconds: 0), () {
      print('Timer started!');

      distanceTime = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        time++;
        print('Seconds passed: $time');
        if (time > 4) {
          if (navigation.lastLocations.length > 5) {
            navigation.lastLocations.removeAt(0);
          }

          navigation.lastLocations.add(
            LatLng(navigation.position.latitude, navigation.position.longitude),
          );
        }
      });
    });
  }

  void analyzeAvg() {
    analyze = true;
  }

  void addMarker(Marker marker) {
    markersOnMap.add(marker);
    notifyListeners();
  }

  void removeMarker(Marker marker) {
    markersOnMap.remove(marker);
    notifyListeners();
  }
}
