import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:on_the_road/LoadingSignIn.dart';
import '/main.dart';
import 'package:tflite/tflite.dart';
import 'package:on_the_road/Services/MapServices.dart';

class Camera extends StatefulWidget {
  Function updateMap;
  // const Camera({Key? key}) : super(key: key);

  Camera(this.updateMap, {super.key});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadmodel();
  }

  @override
  void dispose() {
    super.dispose();
    stopCam();
  }

  loadCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras![0], ResolutionPreset.low);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 5,
          threshold: 0.9,
          asynch: true);
      predictions!.forEach((element) async {
        // if (element['confidence'] < 0.999) element['label'] = '???';
        if (element['label'] == 'Stop Sign') {
          //call the api...
          MapServices addSign = MapServices();
          await addSign.getCurrentLocation();
          var response = await addSign.addSignForUser(element['label'],
              addSign.long.toString(), addSign.lat.toString(), global_token);
          // var response = await addSign.addSignHere();
          widget.updateMap();
        }
        setState(() {
          output = element['label'];
        });
      });
    }
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: "assets/models/model.tflite",
        labels: "assets/models/labels.txt");
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.18,
            width: MediaQuery.of(context).size.width * 0.24,
            child: !cameraController!.value.isInitialized
                ? Container()
                : AspectRatio(
                    aspectRatio: cameraController!.value.aspectRatio,
                    child: CameraPreview(cameraController!),
                  ),
          ),
        ),
      ),
      Text(
        output,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ]);
  }

  void stopCam() {
    cameraController!.pausePreview();
  }

  void startCam() {
    cameraController!.resumePreview();
  }
}
