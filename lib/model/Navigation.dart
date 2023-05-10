import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Navigation{
  late double currentSpeed = 0.0;
  late String warning = "";
  late Position position;
  late Color warningColor = Colors.black;
  late double zoomLevel;
  late double avgSpeed = 0.0;
}