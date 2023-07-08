import 'package:flutter/material.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:on_the_road/view/home_view/home.dart';

void viewSpeedLimitList(BuildContext context) {
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
                              backgroundColor: Colors.white,
                              radius: 40,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                child: Image.asset(
                                    'images/speedLimits/speed-limit(30).png'),
                              ),
                            ),
                          ),
                          Text(
                            "Speed 30",
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
                              child: Image.asset(
                                  'images/speedLimits/speed-limit(40).png'),
                            ),
                          ),
                        ),
                        Text(
                          "Speed 40",
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
                                child: Image.asset(
                                    'images/speedLimits/speed-limit(50).png'),
                              ),
                            ),
                          ),
                          Text(
                            "Speed 50",
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
                            backgroundColor: Colors.grey.shade100,
                            radius: 40,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                              child: Image.asset(
                                  'images/speedLimits/speed-limit(60).png'),
                            ),
                          ),
                        ),
                        Text(
                          "Speed 60",
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
                              backgroundColor: Colors.white,
                              radius: 40,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                child: Image.asset(
                                    'images/speedLimits/speed-limit(70).png'),
                              ),
                            ),
                          ),
                          Text(
                            "Speed 70",
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
                            backgroundColor: Colors.grey.shade100,
                            radius: 40,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                              child: Image.asset(
                                  'images/speedLimits/speed-limit(80).png'),
                            ),
                          ),
                        ),
                        Text(
                          "Speed 80",
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
                              backgroundColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                child: Image.asset(
                                    'images/speedLimits/speed-limit(90).png'),
                              ),
                            ),
                          ),
                          Text(
                            "Speed 90",
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
                            backgroundColor: Colors.grey.shade100,
                            radius: 40,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                              child: Image.asset(
                                  'images/speedLimits/speed-limit(100).png'),
                            ),
                          ),
                        ),
                        Text(
                          "Speed 100",
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