import 'package:flutter/material.dart';

import '../../../constants/design_constants.dart';
class AnalysisCard extends StatefulWidget {
  const AnalysisCard({
    super.key, required this.title, required this.value,
  });
  final String title;
  final double value;

  @override
  State<AnalysisCard> createState() => _AnalysisCardState();
}

class _AnalysisCardState extends State<AnalysisCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(20),
      height: 120,
      width: 150,
      alignment: Alignment.center,
      decoration: DesignConstants.roundedBorder,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(widget.title),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.value == -1.0
                    ? "0.0"
                    : widget.value
                    .toStringAsFixed(2),
                style: const TextStyle(fontSize: 30),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(" km/h")),
            ],
          ),
        ],
      ),
    );
  }
}