import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pytorch/pigeon.dart';

class detectionServices {
  var objectsWidth = {'Car': 1.9, 'tv': 0.51, 'laptop': 0.51};
  var objectsToReport = ['Stop Sign', 'Speed Pump'];
  var reportAccuarcy = 0.85;
  var ttsAccuarcy = 0.80;
  final channel = MethodChannel('java_channel');
  var safeDistanceTime = 2.0; //2 seconds
  double focalLength = 0;

  objectDetected(
      CameraImage cameraImage, List<ResultObjectDetection> objDetect) {
    for (var obj in objDetect) {
      if (objectsToReport.contains(obj.className) &&
          obj.score >= reportAccuarcy) {
        sendToServer(cameraImage);
      }
      if (objectsWidth.containsKey(obj.className) && obj.score >= ttsAccuarcy) {
        double distance = calculateDistance(obj) as double;
        double safeDistance = calculateSafeDistance();
        if (distance > safeDistance) {
          notKeepingSafeDistance(obj.className!, distance);
        }
      }
    }
    //tts
    //or send to server
  }

  Future<double> calculateDistance(ResultObjectDetection object) async {
    var FL = await getFocalLength();
    double distance = double.parse(
        ((0.51 * FL * 0.5) / object.rect.width).toStringAsFixed(1));
    return distance;
    double focalLength = getFocalLength();
    return double.parse(
        ((objectsWidth[object.className]! * focalLength) / object.rect.width)
            .toStringAsFixed(1));
  }

  calculateSafeDistance() {
    var currentSpeed = 0.0;
    //get current speed in meters
    return safeDistanceTime * currentSpeed;
  }

  getFocalLength() async {
    if (focalLength == 0) {
      double FL;
      FL = await channel.invokeMethod('getFocalLength');
      focalLength = FL;
    }
    return focalLength;
  }

  sendToServer(CameraImage cameraImage) {
    print("sending to server...");
  }

  notKeepingSafeDistance(String obj, double distance) {
    tts("there is a $obj in $distance Please keep your safe distance");
  }

  tts(String text) {
    //call text to speech method
  }
}
