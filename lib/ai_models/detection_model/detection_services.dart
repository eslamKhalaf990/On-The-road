import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:provider/provider.dart';

import '../../constants/sounds.dart';
import '../../constants/text-speech.dart';
import '../../view_model/navigation_on_road_v_m.dart';

class DetectionServices extends ChangeNotifier {
  Sounds s = Sounds();
  //to be decided in settings
  final objectsWidth = {
    'Car': 1.9,
    'Bus': 2.0,
    'tv': 0.51,
    'laptop': 0.51,
    'Sign': 0.01
  };
  DateTime lastNotified = DateTime.now().subtract(const Duration(seconds: 5));
  final objectsToReport = ['Sign', 'tv', 'laptop'];
  final reportAccuracy = 0.085;
  final ttsAccuracy = 0.080;
  final channel = const MethodChannel('java_channel');
  final safeDistanceTime = 2.0; // 2 seconds
  double focalLength = 0;

  void objectDetected(CameraImage cameraImage,
      List<ResultObjectDetection?> objDetect, BuildContext context) {
    NavigationOnRoad navigationOnRoad =
        Provider.of<NavigationOnRoad>(context, listen: false);
    for (var obj in objDetect) {
      if (objectsToReport.contains(obj?.className?.trim()) &&
          obj!.score >= reportAccuracy) {
        sendToServer(cameraImage);
      }
      if (objectsWidth.containsKey(obj?.className?.trim()) &&
          obj!.score >= ttsAccuracy) {
        calculateDistance(obj).then((distance) {
          double safeDistance = calculateSafeDistance();
          if (distance < safeDistance) {
            notKeepingSafeDistance(
                obj.className!.trim(), distance, navigationOnRoad);
          } else {
            navigationOnRoad.navigation.warningColor = Colors.blue;
            navigationOnRoad.navigation.warning = "";
          }
        });
      }
      if (obj?.className?.trim() == "Doze eyes" ||
          obj?.className?.trim() == "Doze mouth") {
        s.playSound();
      } else {
        navigationOnRoad.navigation.warningColor = Colors.blue;
        navigationOnRoad.navigation.warning = "";
      }
    }
    // tts
    // or send to server
  }

  Future<double> calculateDistance(ResultObjectDetection object) async {
    double distance = 0.01;
    if (focalLength == 0) {
      focalLength = await getFocalLength();
    }
    if (focalLength > 0) {
      distance = (0.5 * focalLength * 0.25) / object.rect.width;
    }
    distance = double.parse(distance.toStringAsFixed(1));
    return distance;
  }

  double calculateSafeDistance() {
    var currentSpeed = 2.0;
    // get current speed in meters
    return safeDistanceTime * currentSpeed;
  }

  Future<double> getFocalLength() async {
    if (focalLength == 0) {
      double fL = await channel.invokeMethod('getFocalLength');
      focalLength = fL;
    }
    return focalLength;
  }

  void sendToServer(CameraImage cameraImage) {
    print('Sending to server...');
  }

  void notKeepingSafeDistance(
      String obj, double distance, NavigationOnRoad navigationOnRoad) {
    navigationOnRoad.navigation.warning = 'There is a $obj at $distance meters';
    navigationOnRoad.navigation.warningColor = Colors.red;
    tts('There is a $obj at $distance meters. Please maintain a safe distance.');
  }

  void tts(String text) {
    if (DateTime.now().difference(lastNotified).inSeconds > 5) {
      lastNotified = DateTime.now();
      TextSpeech.speak(text);
    }
  }

  DetectionServices();
}
