import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants{
  late BitmapDescriptor currentBitmap;
  late BitmapDescriptor mph100;
  late BitmapDescriptor mph60;
  late BitmapDescriptor mph10;
  late BitmapDescriptor trafficLights;
  late BitmapDescriptor stopSign;
  late BitmapDescriptor radar;
  late BitmapDescriptor noParking;
  late BitmapDescriptor bump;
  late BitmapDescriptor forbidden;


  late Color activeColor = Colors.white;
  var icons = [
    "Stop Sign",
    "Traffic Light",
    "Speed Limit",
    "Radar",
    "Speed Bumps",
  ];
  void customizeBitmap() async {
    currentBitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'images/user_location_1.png',
    );
     stopSign = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/stopSign.png',
     );
     trafficLights = await BitmapDescriptor.fromAssetImage(
       ImageConfiguration.empty, 'images/traffic-lights.png',
     );
     bump = await BitmapDescriptor.fromAssetImage(
       ImageConfiguration.empty, 'images/road-bump.png',
     );
  }

}