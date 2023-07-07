import 'package:flutter/material.dart';
import 'package:flutter_pytorch/pigeon.dart';
import '../detection_services.dart';
import 'camera_view_singleton.dart';

class BoxWidget extends StatelessWidget {
  final ResultObjectDetection result;
  final Color? boxesColor;
  final bool showPercentage;

  const BoxWidget({
    Key? key,
    required this.result,
    this.boxesColor,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? usedColor;
    Size screenSize = CameraViewSingleton.actualPreviewSizeH;
    double factorX = screenSize.width;
    double factorY = screenSize.height;

    if (boxesColor == null) {
      usedColor = Colors.primaries[
          ((result.className ?? result.classIndex.toString()).length +
                  (result.className ?? result.classIndex.toString())
                      .codeUnitAt(0) +
                  result.classIndex) %
              Colors.primaries.length];
    } else {
      usedColor = boxesColor;
    }

    DetectionServices detectServices =
        DetectionServices(); // Create an instance of DetectionServices

    return Positioned(
      left: result.rect.left * factorX,
      top: result.rect.top * factorY - 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100,),
          FutureBuilder<double>(
            future: detectServices
                .calculateDistance(result), // Call the calculateDistance method
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Placeholder container while waiting for the result
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                double distance = snapshot.data ?? 0.0;
                return ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(13),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 50,
                    alignment: Alignment.centerRight,
                    color: usedColor,
                    //change Design
                    child: Text(
                      '${distance.toStringAsFixed(2)}m ${result.className ?? result.classIndex.toString()}_${showPercentage ? "${(result.score * 100).toStringAsFixed(2)}%" : ""}',
                    ),
                  ),
                );
              }
            },
          ),
          Container(
            width: result.rect.width.toDouble() * factorX,
            height: result.rect.height.toDouble() * factorY,
            decoration: BoxDecoration(
              border: Border.all(color: usedColor!, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
