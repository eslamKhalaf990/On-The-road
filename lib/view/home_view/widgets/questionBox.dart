import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class questionBoxWidget extends StatelessWidget {
  const questionBoxWidget({
    Key? key,
    required this.isVisible,
    required this.lineAnimation,
  }) : super(key: key);

  final bool isVisible;
  final Animation<double> lineAnimation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: isVisible,
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Text(
                'Did You Found a Radar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Perform action for button 1
                    },
                    child: Text('Yes'),
                  ),
                  SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      // Perform action for button 2
                    },
                    child: Text('No'),
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              AnimatedBuilder(
                animation: lineAnimation,
                builder: (context, child) {
                  return Container(
                    height: 2.0,
                    width:
                        lineAnimation.value * 200, // Width decreases over time
                    color: Colors.black,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
