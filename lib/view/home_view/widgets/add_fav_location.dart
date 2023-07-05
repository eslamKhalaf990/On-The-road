import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/Services/map_services.dart';
import 'package:on_the_road/model/user.dart';
import 'package:on_the_road/view_model/navigation_on_road_v_m.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:provider/provider.dart';

import '../home.dart';

void addFavLocation(BuildContext context, LatLng latLng) {
  MapServices mapServices = MapServices();
  TextEditingController controller = TextEditingController();
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
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This Field Is Required';
                  }
                  return null;
                },
                controller: controller,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  labelText: "Location name",
                  prefixIcon: Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 6),
                    child: Icon(Icons.location_history),
                  ),
                  labelStyle: const TextStyle(fontFamily: 'tajawal'),
                ),
              ),
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
                      if (controller.text.isNotEmpty) {
                        mapServices.addFavLocation(
                            Provider.of<User>(context, listen: false).token,
                            latLng,
                            controller.text);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(fontFamily: DesignConstants.fontFamily),
                    ),
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
                      Provider.of<NavigationOnRoad>(context, listen: false)
                          .removeMarker(
                        Marker(
                          markerId: const MarkerId('favorite place'),
                          position: LatLng(
                            latLng.latitude,
                            latLng.longitude,
                          ),
                          icon: constants.userLocation,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontFamily: DesignConstants.fontFamily),
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
