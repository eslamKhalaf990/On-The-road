import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  late String googleApiKey = "AIzaSyA10i_LPMic7RByXKoYmbskcR89Fw7erus";
  late BitmapDescriptor userLocation;
  late BitmapDescriptor mph100;
  late BitmapDescriptor mph60;
  late BitmapDescriptor mph30;
  late BitmapDescriptor mph40;
  late BitmapDescriptor mph50;
  late BitmapDescriptor mph70;
  late BitmapDescriptor mph80;
  late BitmapDescriptor mph90;
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
    userLocation = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/user-location-3.png',
    );
    stopSign = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/stopSign.png',
    );
    trafficLights = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/traffic-lights.png',
    );
    bump = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/road-bump.png',
    );
    radar = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/speed-camera.png',
    );
    forbidden = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/forbidden.png',
    );

    mph60 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/speedLimits/60.png',
    );

    mph30 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/speedLimits/30.png',
    );

    mph100 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/speedLimits/100.png',
    );
    mph40 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/speedLimits/40.png',
    );
    mph50 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/speedLimits/50.png',
    );
    mph70 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/speedLimits/70.png',
    );
    mph80 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/speedLimits/80.png',
    );
    mph90 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'images/speedLimits/90.png',
    );

  }
}
