import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/constants_on_map.dart';
import '../model/Navigation.dart';
import 'map_services.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class PositionStream extends ChangeNotifier {
  Navigation navigation = Navigation();
  List<ChartData> chartData = <ChartData>[];
  Set<Marker> markersOnMap = {};
  late
  bool analyze = false;
  bool isStreaming = false;

  int i = 0;

  Future<void> streamPosition(Completer<GoogleMapController> controller,
      MapServices services, String token, Constants constants, locationAccuracy) async {
    int cnt = 0;
    double sum = 0.0;
    final GoogleMapController mapController = await controller.future;

    LocationSettings locationSettings = LocationSettings(
      accuracy: locationAccuracy,
      distanceFilter: 0,
    );


    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) async {

      navigation.zoomLevel = await mapController.getZoomLevel();
      navigation.currentSpeed = position.speed * 3.6;
      navigation.position = position;
      isStreaming = true;

      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(navigation.position.latitude, navigation.position.longitude),
            zoom: navigation.zoomLevel,
          ),
        ),
      );

      sum += navigation.currentSpeed;
      cnt++;

      i++;
      navigation.avgSpeed = sum / cnt;

      if (analyze) {
        chartData.add(
          ChartData(cnt.toString(), navigation.avgSpeed),
        );
      }

      var response = await services.getSigns(token);
      var data = json.decode(response.body);

      for (int i = 0; i < data.length; i++) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          data[i]['location']['coordinates'][1],
          data[i]['location']['coordinates'][0],
        );

        print("distance: $distance");
        if (distance < 100) {
          navigation.warning = "There Is A Stop Sign\n In Less Than 100 meters";
          navigation.warningColor = Colors.red;
          break;
        } else {
          navigation.warning = "";
          navigation.warningColor = Colors.blue;
        }
      }
      notifyListeners();
    });
  }

  addMarkers(Constants constants, String token) async {
    MapServices services = MapServices();
    var response = await services.getSigns(token);
    var data = json.decode(response.body);
    for (int i = 0; i < data.length; i++) {
      print(data[i]['location']['coordinates'][1] * 1.0);
      print(data[i]['location']['coordinates'][0] * 1.0);
      markersOnMap.add(
        Marker(
          markerId: MarkerId('$i'),
          position: LatLng(data[i]['location']['coordinates'][1] * 1.0,
              data[i]['location']['coordinates'][0] * 1.0),
          icon: constants.stopSign,
        ),
      );
    }
    notifyListeners();
  }

  analyzeAvg() {
    analyze = true;
  }
}
