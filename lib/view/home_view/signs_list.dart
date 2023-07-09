import 'package:flutter/material.dart';
import 'package:on_the_road/Services/map_services.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:on_the_road/view/home_view/speed_limit_list.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';

class SignList {
  late double longitude = 0.0;
  late double latitude = 0.0;
  MapServices mapServices = MapServices();

  void getLocation() async {
    await mapServices.getCurrentLocation();
    longitude = mapServices.long;
    latitude = mapServices.lat;
  }

  void viewAddSignList(BuildContext context) {
    String token = Provider.of<User>(context, listen: false).token;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.grey[900],
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
                          backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
                        ),
                        onPressed: () {
                          getLocation();
                          mapServices.addSign("Radar", longitude, latitude, token);
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
                        getLocation();
                        mapServices.addSign(
                            "Speed Bumps", longitude, latitude, token);
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
                          getLocation();
                          mapServices.addSign(
                              "Traffic Light", longitude, latitude, token);
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
                                  child:
                                      Image.asset('images/traffic-lights.png'),
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
                        SpeedList speedList = SpeedList();
                        Navigator.pop(context);
                        speedList.viewSpeedLimitList(context);
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
                                child:
                                    Image.asset('images/icons8-speed-100.png'),
                              ),
                            ),
                          ),
                          Text(
                            "Speed Limit",
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
