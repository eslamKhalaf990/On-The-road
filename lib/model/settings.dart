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
    ["HIGH", "MEDIUM", "LOW"],
    [const AssetImage("images/ic_launcher.png"), const AssetImage("images/ic_launcher_color.png")],
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