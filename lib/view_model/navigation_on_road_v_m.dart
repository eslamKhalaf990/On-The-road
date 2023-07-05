import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/constants/text-speech.dart';
import 'package:on_the_road/speech_text/speak_to.dart';
import 'package:on_the_road/view/home_view/widgets/dialog_box.dart';
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

  Future<void> navigateOnRoad(
      Completer<GoogleMapController> _controller, BuildContext ctx, MapServices services,
      String token, Constants constants, locationAccuracy) async {
    int cnt = 0;
    double sum = 0.0;
    final GoogleMapController mapController = await _controller.future;

    LocationSettings locationSettings = LocationSettings(
      accuracy: locationAccuracy,
      distanceFilter: 0,
    );

    startTimer();
    getSignsAroundUser(services, token);
    if (ctx.mounted) {
      getNearestSign(ctx, _controller, services);
    }
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      if ((position.speed * 3.6) < 3) {
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

      if (navigation.currentSpeed < 3) {
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
        chartData.add(
          ChartData(i.toString(), navigation.currentSpeed),
        );
      }
      notifyListeners();
    });
  }

  void addMarkers(Constants constants, String token) async {
    // MapServices services = MapServices();
    // var response = await services.getSigns(token, );
    // var data = json.decode(response.body);
    if(markersOnMap.isNotEmpty){
      markersOnMap.removeAll(markersOnMap);
    }
    for (int i = 0; i < signsOnRoad.length; i++) {
      markersOnMap.add(
        Marker(
          markerId: MarkerId('$i'),
          position: LatLng(signsOnRoad[i]['startLocation']['coordinates'][1] * 1.0,
              signsOnRoad[i]['startLocation']['coordinates'][0] * 1.0),
          icon:
          // signsOnRoad[i]['name'] == "Traffic Light"
               constants.trafficLights
              // : constants.stopSign,
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

  void getNearestSign(BuildContext ctx, Completer<GoogleMapController> _controller, MapServices services) {
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      for (int i = 0; i < signsOnRoad.length; i++) {
        double distance = Geolocator.distanceBetween(
          navigation.position.latitude,
          navigation.position.longitude,
          signsOnRoad[i]['startLocation']['coordinates'][1],
          signsOnRoad[i]['startLocation']['coordinates'][0],
        );

        if (distance < 5) {

          TextSpeech.speak("Did you find a ${signsOnRoad[i]['name']}");
          showAutoDismissDialog(ctx, "${signsOnRoad[i]['name']}");
          toggleListening(ctx, _controller, services);
        } else if (distance < 100) {
          print("distance: $distance");
          navigation.warning =
              "There Is A ${signsOnRoad[i]['name']}\n In ${distance.toStringAsFixed(1)} meters";

          TextSpeech.speak(navigation.warning);

          navigation.warningColor = Colors.red;
          break;
        } else {
          navigation.warning = "";
          navigation.warningColor = Colors.blue;
        }
      }
    });
  }
  getSignsAroundUser(MapServices services, String token) async {
    await services.getCurrentLocation();
    // signsOnRoad  = services.getSigns(token, services.lat, services.long);
    signsOnRoad = [
      {
        "id": 4,
        "startLocation": {
          "crs": {
            "type": "name",
            "properties": {
              "name": "EPSG:4326"
            }
          },
          "type": "Point",
          "coordinates": [
            31.21063763465604,
            30.03129769641675
          ]
        },
        "endLocation": null,
        "reportedCount": 10,
        "active": true,
        "oneWay": true,
        "createdAt": "2023-07-04T18:14:04.004Z",
        "updatedAt": "2023-07-04T18:14:04.004Z",
        "signId": 2,
        "distance": 35.00340213
      },
      {
        "id": 5,
        "startLocation": {
          "crs": {
            "type": "name",
            "properties": {
              "name": "EPSG:4326"
            }
          },
          "type": "Point",
          "coordinates": [
            31.209076589162546,
            30.027512555235536
          ]
        },
        "endLocation": null,
        "reportedCount": 20,
        "active": true,
        "oneWay": true,
        "createdAt": "2023-07-04T18:14:50.303Z",
        "updatedAt": "2023-07-04T18:14:50.303Z",
        "signId": 3,
        "distance": 415.41820329
      }
    ];
    addMarkers(constants, token);
    Timer.periodic(const Duration(seconds: 50), (timer) async {
      // signsOnRoad = json.decode((await services.getSigns(token, navigation.position.latitude, navigation.position.longitude)).body);
      signsOnRoad = [
        {
          "id": 4,
          "startLocation": {
            "crs": {
              "type": "name",
              "properties": {
                "name": "EPSG:4326"
              }
            },
            "type": "Point",
            "coordinates": [
              31.21063763465604,
              30.03129769641675
            ]
          },
          "endLocation": null,
          "reportedCount": 10,
          "active": true,
          "oneWay": true,
          "createdAt": "2023-07-04T18:14:04.004Z",
          "updatedAt": "2023-07-04T18:14:04.004Z",
          "signId": 2,
          "distance": 35.00340213
        },
        {
          "id": 5,
          "startLocation": {
            "crs": {
              "type": "name",
              "properties": {
                "name": "EPSG:4326"
              }
            },
            "type": "Point",
            "coordinates": [
              31.209076589162546,
              30.027512555235536
            ]
          },
          "endLocation": null,
          "reportedCount": 20,
          "active": true,
          "oneWay": true,
          "createdAt": "2023-07-04T18:14:50.303Z",
          "updatedAt": "2023-07-04T18:14:50.303Z",
          "signId": 3,
          "distance": 415.41820329
        }
      ];
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
