import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'camera_view_singleton.dart';

class CameraView extends StatefulWidget {
  final Function(List<ResultObjectDetection?> recognitions) resultsCallback;
  final Function(String classification) resultsCallbackClassification;

  const CameraView(this.resultsCallback, this.resultsCallbackClassification);
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  late List<CameraDescription> cameras;

  CameraController? cameraController;

  late bool predicting;

  ModelObjectDetection? _objectModel;

  bool classification = false;
  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  //load your model
  Future loadModel() async {
    //String pathCustomModel = "assets/models/custom_model.ptl";
    String pathObjectDetectionModel = "assets/models/4-7-a.torchscript";
    try {
      //_customModel = await PytorchLite.loadCustomModel(pathCustomModel);
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
          pathObjectDetectionModel, 10, 640, 640,
          labelPath: "assets/labels/4-7-a.txt");
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);
    await loadModel();

    // Camera initialization
    initializeCamera();

    // Initially predicting = false
    predicting = false;
  }

  /// Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    cameras = await availableCameras();

    // cameras[0] for rear-camera
    cameraController =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

    cameraController?.initialize().then((_) async {
      // Stream of image passed to [onLatestImageAvailable] callback
      await cameraController?.startImageStream(onLatestImageAvailable);

      /// previewSize is size of each image frame captured by controller
      ///
      /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
      Size? previewSize = cameraController?.value.previewSize;

      /// previewSize is size of raw input image to the model
      CameraViewSingleton.inputImageSize = previewSize!;

      // the display width of image on screen is
      // same as screenWidth while maintaining the aspectRatio
      Size screenSize = MediaQuery.of(context).size;
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio = screenSize.width / previewSize.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return empty container while the camera is not initialized
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            child: CameraPreview(cameraController!)),
      ),
    );
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  onLatestImageAvailable(CameraImage cameraImage) async {
    // if (classifier.interpreter != null && classifier.labels != null) {

    // If previous inference has not completed then return
    if (predicting) {
      //print("here processing");
      return;
    }

    setState(() {
      predicting = true;
    });
    if (_objectModel != null) {
      List<ResultObjectDetection?> objDetect = await _objectModel!
          .getImagePredictionFromBytesList(
              cameraImage.planes.map((e) => e.bytes).toList(),
              cameraImage.width,
              cameraImage.height,
              minimumScore: 0.3,
              IOUThershold: 0.3);

      print("data outputted $objDetect");
      widget.resultsCallback(objDetect);
    }

    // set predicting to false to allow new frames
    setState(() {
      predicting = false;
    });
    // }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController?.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController!.value.isStreamingImages) {
          await cameraController?.startImageStream(onLatestImageAvailable);
        }
        break;
      default:
    }
  }

  // @override
  // void dispose() {
  //   print("killing stream");
  //   // cameraController?.dispose();
  //   // Provider.of<PositionStream>(context, listen: false).fun();
  //   // WidgetsBinding.instance.removeObserver(this);
  //
  //   super.dispose();
  // }
}
