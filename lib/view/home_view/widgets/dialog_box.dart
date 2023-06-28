import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_the_road/constants/design_constants.dart';

void showAutoDismissDialog(BuildContext context, String message) {
  Timer t;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Set up a Timer to dismiss the dialog after 10 seconds
      t = Timer(const Duration(seconds: 5), () {
        Navigator.of(context).pop();
      });

      return Column(
        // alignment: Alignment.topCenter,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Colors.grey[900],
            // title: const Text('Auto Dismiss Dialog'),
            content: Center(
              child: Text(
                  'Did you find a $message?',
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
                      t.cancel();
                      Navigator.of(context).pop();
                    },
                    child: Text('Yes', style: TextStyle(fontFamily: DesignConstants.fontFamily),),
                  ),
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
                      t.cancel();
                      Navigator.of(context).pop();
                    },
                    child: Text('No', style: TextStyle(fontFamily: DesignConstants.fontFamily),),
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
