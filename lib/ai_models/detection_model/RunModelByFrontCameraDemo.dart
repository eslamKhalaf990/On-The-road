import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:on_the_road/ai_models/detection_model/ui/front_camera_view.dart';
import 'ui/box_widget.dart';

import 'ui/camera_view.dart';

/// [RunModelByCameraDemo] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats
class RunModelByFrontCameraDemo extends StatefulWidget {
  @override
  _RunModelByFrontCameraDemoState createState() =>
      _RunModelByFrontCameraDemoState();
}

class _RunModelByFrontCameraDemoState extends State<RunModelByFrontCameraDemo> {
  List<ResultObjectDetection?>? results;
  String? classification;

  /// Scaffold Key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          FrontCameraView(resultsCallback, resultsCallbackClassification),
          boundingBoxes2(results),
        ],
      ),
    );
  }

  /// Returns Stack of bounding boxes
  Widget boundingBoxes2(List<ResultObjectDetection?>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoxWidget(result: e!)).toList(),
    );
  }

  void resultsCallback(List<ResultObjectDetection?> results) {
    setState(() {
      this.results = results;
      results.forEach((element) {
        print({
          "rect": {
            "left": element?.rect.left,
            "top": element?.rect.top,
            "width": element?.rect.width,
            "height": element?.rect.height,
            "right": element?.rect.right,
            "bottom": element?.rect.bottom,
          },
        });
      });
    });
  }

  void resultsCallbackClassification(String classification) {
    setState(() {
      this.classification = classification;
    });
  }

  static const BOTTOM_SHEET_RADIUS = Radius.circular(24.0);
  static const BORDER_RADIUS_BOTTOM_SHEET = BorderRadius.only(
      topLeft: BOTTOM_SHEET_RADIUS, topRight: BOTTOM_SHEET_RADIUS);
}

/// Row for one Stats field
class StatsRow extends StatelessWidget {
  final String left;
  final String right;

  StatsRow(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(left), Text(right)],
      ),
    );
  }
}
