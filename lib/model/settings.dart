import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SettingsModel extends ChangeNotifier {
  LocationAccuracy locationAccuracy = LocationAccuracy.bestForNavigation;
  MapType mapTheme = MapType.normal;
  double notifyDistance = 0.0;
  double safeDistanceTime = 2.0;
  bool askAboutObjects = false;
  bool voiceAssistEnabled = false;

  List<String> settings = [
    "Location Accuracy",
    "Map Theme",
    "Notify Distance",
    "Safe Distance",
    "Ask About Objects on Road",
    "Voice Assist",
  ];
  List<IconData> icons = [
    Icons.location_searching_outlined,
    Icons.map_outlined,
    Icons.notification_important,
    Icons.timer,
    Icons.question_answer,
    Icons.volume_up,
  ];
  List<List> options = [
    [
      "HIGH",
      "MEDIUM",
      "LOW",
    ],
    [
      const AssetImage("images/ic_launcher.png"),
      const AssetImage("images/ic_launcher_color.png"),
    ],
  ];

  void setLocationAccuracy(LocationAccuracy accuracy) {
    locationAccuracy = accuracy;
    notifyListeners();
  }

  void setMapTheme(MapType type) {
    mapTheme = type;
    notifyListeners();
  }

  void setNotifyDistance(double distance) {
    notifyDistance = distance;
    notifyListeners();
  }

  void setSafeDistanceTime(double time) {
    safeDistanceTime = time;
    notifyListeners();
  }

  void setAskAboutObjects(bool value) {
    askAboutObjects = value;
    notifyListeners();
  }

  void setVoiceAssistEnabled(bool value) {
    voiceAssistEnabled = value;
    notifyListeners();
  }
}
