import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:provider/provider.dart';

import '../../constants/sounds.dart';
import '../../constants/text-speech.dart';
import '../../view_model/navigation_on_road_v_m.dart';
import 'package:http/http.dart' as http;

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
  final reportAccuracy = 0.85;
  final ttsAccuracy = 0.60;
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
      if (obj?.className?.trim() == "Doze" ||
          obj?.className?.trim() == "Doze eyes") {
        // obj?.className?.trim() == "Doze eyes" ||obj?.className?.trim() == "Doze mouth"
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
      distance = (1.9 * focalLength * 0.25) / object.rect.width;
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
    sendImage(cameraImage, 30.027512555235536, 31.209076589162546);
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

Future<void> sendImage(CameraImage cameraImage, double lat, double long) async {
  // Convert the CameraImage to bytes
  final planeBytes = cameraImage.planes.map((plane) => plane.bytes).toList();
  final bytes = concatenateBytes(planeBytes);

  // Define the URL and query parameters
  final url = Uri.http('https://ontheroad.onrender.com', '/api/detection/', {
    'lat': lat,
    'long': long,
  });

  // Create a multipart request
  var request = http.MultipartRequest('POST', url);

  // Add the image bytes to the request
  request.files.add(http.MultipartFile.fromBytes('image', bytes));

  // Send the request
  var response = await request.send();

  // Read and print the response
  var responseBody = await response.stream.bytesToString();
  print("@@@@@@@@@@@@@@@@@@" + responseBody);
}

Uint8List concatenateBytes(List<Uint8List> bytesList) {
  final totalLength = bytesList.fold(0, (count, bytes) => count + bytes.length);
  final result = Uint8List(totalLength);
  var offset = 0;
  for (var bytes in bytesList) {
    result.setRange(offset, offset + bytes.length, bytes);
    offset += bytes.length;
  }
  return result;
}
