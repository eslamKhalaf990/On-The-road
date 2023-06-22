import 'package:flutter/material.dart';
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black12,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 4,
            blurRadius: 2,
            offset:
            Offset(0, 0.1), // changes position of shadow
          ),
        ],
      ),
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