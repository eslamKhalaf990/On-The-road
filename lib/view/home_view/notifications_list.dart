import 'package:flutter/material.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:provider/provider.dart';

import '../../Services/map_services.dart';
import '../../model/user.dart';

class EventList {
  late double longitude = 0.0;
  late double latitude = 0.0;
  MapServices mapServices = MapServices();
  void getLocation() async {
    await mapServices.getCurrentLocation();
    longitude = mapServices.long;
    latitude = mapServices.lat;
  }

  void viewEventsList(BuildContext context) {
    String token = Provider.of<User>(context, listen: false).token;
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
                          mapServices.addEvents(
                              "Car Accident", longitude, latitude, token);
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
                                  child: Image.asset('images/accident.png'),
                                ),
                              ),
                            ),
                            Text(
                              "Car Accident",
                              style: TextStyle(
                                  fontFamily: DesignConstants.fontFamily),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
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
                        mapServices.addEvents(
                            "Traffic Jam", longitude, latitude, token);
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
                                child: Image.asset('images/cars.png'),
                              ),
                            ),
                          ),
                          Text(
                            "Traffic Jam",
                            style: TextStyle(
                                fontFamily: DesignConstants.fontFamily),
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
                          mapServices.addEvents(
                              "Construction Zone", longitude, latitude, token);
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
                                  child: Image.asset('images/barrier.png'),
                                ),
                              ),
                            ),
                            Text(
                              "Construction Zone",
                              style: TextStyle(
                                  fontFamily: DesignConstants.fontFamily),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
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
                        mapServices.addEvents(
                            "Dangerous Driver", longitude, latitude, token);
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
                                child: Image.asset('images/car.png'),
                              ),
                            ),
                          ),
                          Text(
                            "Dangerous Driver",
                            style: TextStyle(
                                fontFamily: DesignConstants.fontFamily),
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
}