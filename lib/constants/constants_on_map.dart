import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants{
  late BitmapDescriptor bitmap;
  late BitmapDescriptor currentBitmap;
  late Color activeColor = Colors.grey;
  var icons = [
    "Stop Sign",
    "Traffic Light",
    "Speed Limit",
    "Radar",
    "Speed Bumps",
  ];
  void customizeBitmap() async {
     bitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/stopSign.png');
     currentBitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/currentLocation.png');
  }

}