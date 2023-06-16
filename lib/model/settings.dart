import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SettingsModel extends ChangeNotifier{
  late LocationAccuracy locationAccuracy = LocationAccuracy.bestForNavigation;
  late MapType mapTheme = MapType.normal;

  List<String> settings = [
    "Location Accuracy",
    "Map Theme"
  ];
  List<IconData>icons = [
    Icons.location_searching_outlined,
    Icons.map_outlined,
  ];
  List<List>options = [
    ["BEST", "Lowest"],
    [Icons.map_rounded, Icons.map_outlined],
  ];

  setLocationAccuracy(LocationAccuracy accuracy){
    locationAccuracy = accuracy;
    notifyListeners();
  }
  setMapTheme(MapType type){
    mapTheme = type;
    notifyListeners();
  }
}