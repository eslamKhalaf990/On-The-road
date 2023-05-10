import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/view/home_view/home.dart';
import '../model/Navigation.dart';
import 'map_services.dart';

class PositionStream{
  Navigation navigation = Navigation();

  Future<void> streamPosition(Completer<GoogleMapController> _controller,GoogleMapController controller,MapServices services, String token) async {
    int cnt = 0;
    double sum = 0.0;

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) async {

          navigation.zoomLevel =  await controller.getZoomLevel();
          navigation.currentSpeed = position.speed * 3.6;
          sum +=navigation.currentSpeed;
          cnt++;
          navigation.avgSpeed = sum/cnt;
          navigation.position = position;

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
             if (distance < 6) {
                navigation.warning = "There Is A Stop Sign\n In Less Than 100 meters";
                navigation.warningColor = Colors.red;
                print("<100");
                break;
             }
             else{
               navigation.warning = "";
               navigation.warningColor = Colors.blue;
             }
          }

          streamController.add(navigation);
    });
  }

}