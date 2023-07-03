import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Navigation extends ChangeNotifier{
  late double currentSpeed = 0.0;
  late String warning = "";
  late Position position;
  late Color warningColor = Colors.black;
  late double avgSpeed = 0.0;
  late double distanceTraveled = 0.0;
  late double maxSpeed = -1.0;
  late List<LatLng> coordinates = [];
}