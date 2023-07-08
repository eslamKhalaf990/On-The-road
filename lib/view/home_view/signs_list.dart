import 'package:flutter/material.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:on_the_road/view/home_view/home.dart';
import 'package:on_the_road/view/home_view/speed_limit_list.dart';

void viewAddSignList(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Set up a Timer to dismiss the dialog after 10 seconds
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: Colors.grey[900],
        // title: const Text('Auto Dismiss Dialog'),
        actions: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[700]),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 40,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                child: Image.asset('images/speed-camera.png'),
                              ),
                            ),
                          ),
                          Text(
                            "Radar",
                            style: TextStyle(
                                fontFamily: DesignConstants.fontFamily),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[700]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 40,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                              child: Image.asset('images/road-bump.png'),
                            ),
                          ),
                        ),
                        Text(
                          "Speed Bump",
                          style:
                              TextStyle(fontFamily: DesignConstants.fontFamily),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[700]),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 40,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                child: Image.asset('images/traffic-lights.png'),
                              ),
                            ),
                          ),
                          Text(
                            "Traffic Light",
                            style: TextStyle(
                                fontFamily: DesignConstants.fontFamily),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[700]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      viewSpeedLimitList(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            radius: 40,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                              child: Image.asset('images/icons8-speed-100.png'),
                            ),
                          ),
                        ),
                        Text(
                          "Speed Limit",
                          style:
                              TextStyle(fontFamily: DesignConstants.fontFamily),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    },
  );
}
