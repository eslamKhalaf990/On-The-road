import 'dart:collection';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../LoadingSignIn.dart';

class MapServices {
  late double long;
  late double lat;
  bool firstTime = true;

  //Get User Current Location
  Future<void> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      long = position.longitude;
      lat = position.latitude;
    } catch (e) {
      print(e);
    }
  }

  //Add Sign to a given location
  Future<http.Response> addSign(
      String signName, String long, String lat, String token) async {
    return await http.post(
      Uri.parse('https://nodeapi-35lq.onrender.com/api/sign/admin/addSign'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "name": signName,
          "location": {
            "type": "Point",
            "coordinates": [double.parse(long), double.parse(lat)]
          },
        },
      ),
    );
  }

  //Add sign to current location
  Future<http.Response> addSignForUser(
      String signName, String long, String lat, String token) async {
    return await http.post(
      Uri.parse('https://nodeapi-35lq.onrender.com/api/sign/user/addSign'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "name": signName,
          "location": {
            "type": "Point",
            "coordinates": [double.parse(long), double.parse(lat)]
          },
        },
      ),
    );
    // return await http.post(
    //   Uri.parse('https://nodeapi-35lq.onrender.com/api/sign/user/addSign'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     'Authorization': 'Bearer $global_token',
    //   },
    //   body: jsonEncode(
    //     {
    //       "name": signName,
    //       "location": {
    //         "type": "Point",
    //         "coordinates": [global_long, global_lat]
    //       },
    //     },
    //   ),
    // );
  }

  //Retrieve all signs from Database
  Future<http.Response> getSigns(String token) async {
    var response = await http.get(
      Uri.parse('https://nodeapi-35lq.onrender.com/api/sign/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return (response);
  }

  //BitMapLiveLocation
  Set<Marker> bitmapLiveLocation(
      var markersOnMap, Position position, BitmapDescriptor currentBitmap) {
    double pastLong = 0.0;
    double pastLat = 0.0;
    if (firstTime) {
      pastLong = position.longitude;
      pastLat = position.latitude;
      markersOnMap.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(
            position.latitude,
            position.longitude,
          ),
          icon: currentBitmap,
        ),
      );
      print("mark added first time");
      firstTime = false;
    } else {
      markersOnMap.remove(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(
            pastLat,
            pastLong,
          ),
          icon: currentBitmap,
        ),
      );
      print("mark removed");
      pastLong = position.longitude;
      pastLat = position.latitude;
      markersOnMap.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(
            pastLat,
            pastLong,
          ),
          icon: currentBitmap,
        ),
      );
      print("mark added");
    }
    return markersOnMap;
  }
}
