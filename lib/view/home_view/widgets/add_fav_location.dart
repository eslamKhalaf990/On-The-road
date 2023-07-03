import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/view_model/navigation_on_road_v_m.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:provider/provider.dart';

import '../home.dart';

void addFavLocation(BuildContext context, LatLng latLng) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Set up a Timer to dismiss the dialog after 10 seconds
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Colors.grey[900],
            // title: const Text('Auto Dismiss Dialog'),
            content: Center(
              child: Text(
                'Add Marked Location To Favorite List',
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
                      Navigator.of(context).pop();
                    },
                    child: Text('Add', style: TextStyle(fontFamily: DesignConstants.fontFamily),),
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
                      Provider.of<NavigationOnRoad>(context, listen: false).removeMarker(
                        Marker(
                        markerId: const MarkerId('favorite place'),
                        position: LatLng(
                          latLng.latitude,
                          latLng.longitude,
                        ),
                        icon: constants.userLocation,
                      ),);
                      Navigator.of(context).pop();
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
