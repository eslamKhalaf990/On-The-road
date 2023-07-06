import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pytorch/pigeon.dart';

class DetectionServices {
  //to be decided in settings

  final objectsWidth = {'Car': 1.9, 'tv': 0.51, 'laptop': 0.51};
  final objectsToReport = ['Stop Sign', 'Speed Pump', 'tv', 'laptop'];
  final reportAccuracy = 0.085;
  final ttsAccuracy = 0.080;
  final channel = const MethodChannel('java_channel');
  final safeDistanceTime = 2.0; // 2 seconds
  double focalLength = 0;

  void objectDetected(
      CameraImage cameraImage, List<ResultObjectDetection?> objDetect) {
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
            notKeepingSafeDistance(obj.className!, distance);
          }
        });
      }
    }
    // tts
    // or send to server
  }

  Future<double> calculateDistance(ResultObjectDetection object) async {
    double fL = await getFocalLength();
    double distance = (0.51 * fL * 0.25) / object.rect.width;
    return distance;
  }

  double calculateSafeDistance() {
    var currentSpeed = 0.0;
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

  void notKeepingSafeDistance(String obj, double distance) {
    tts('There is a $obj at $distance. Please maintain a safe distance.');
  }

  void tts(String text) {
    // call text-to-speech method
  }

  DetectionServices();
}
