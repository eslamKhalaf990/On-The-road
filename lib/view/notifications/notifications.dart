import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/view_model/navigation_on_road_v_m.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:provider/provider.dart';

import '../home_view/home.dart';


void showNotification(BuildContext context, String? notification) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Set up a Timer to dismiss the dialog after 10 seconds
      return Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Colors.grey[900],
            // title: const Text('Auto Dismiss Dialog'),
            content: Center(
              child: Text(
                notification!,
                style: TextStyle(fontFamily: DesignConstants.fontFamily),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors
                          .grey[700]), // Set the background color of the button
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel', style: TextStyle(fontFamily: DesignConstants.fontFamily),),
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
