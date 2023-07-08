import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapServices {
  late double long;
  late double lat;

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
      String signName, double long, double lat, String token) async {
    return await http.post(
      Uri.parse('https://ontheroad.onrender.com/api/sign/addSign'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "startLocation": [lat, long],
          "signName": signName,
          "oneWay": false
        },
      ),
    );
  }

  Future<http.Response> addEvents(
      String eventName, double long, double lat, String token) async {
    return await http.post(
      Uri.parse('https://ontheroad.onrender.com/api/userEvents/addEvent'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "message": eventName,
          "location": [long, lat]
        },
      ),
    );
  }

  int getSpeedLimit() {
    return 60;
  }

  Future<void> sendUserFeedBack(String token, bool exists, int id) async {
    await http.post(
      Uri.parse('https://ontheroad.onrender.com/api/sign/signFollowUp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"exists": exists, "signId": id}),
    );
  }

  Future<void> sendDailyStat(
      String token,
      int speedBumpDangerous,
      int speedExceeded,
      int speedBump,
      int time,
      int maxSpeed,
      int avgSpeed,
      int distance) async {
    await http.post(
      Uri.parse('https://ontheroad.onrender.com/api/userStats/addDailyStat'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "distance": distance,
          "avgSpeed": avgSpeed,
          "maxSpeed": maxSpeed,
          "speedExceeded": speedExceeded,
          "count": time,
          "speedBumps": speedBump,
          "dangerSpeedBumps": speedBumpDangerous
        },
      ),
    );
  }

  //Retrieve all signs from Database
  Future<http.Response> getSigns(
      String token, double latitude, double longitude) async {
    var response = await http.get(
      Uri.parse(
          'https://ontheroad.onrender.com/api/sign/getSign?lat=$latitude&long=$longitude'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> getFavLocations(String token) async {
    var response = await http.get(
      Uri.parse('https://ontheroad.onrender.com/api/fPlace'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> addFavLocation(
      String token, LatLng loc, String name) async {
    var response = await http.post(
      Uri.parse('https://ontheroad.onrender.com/api/fPlace'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "location": [loc.latitude, loc.longitude],
          "name": name
        },
      ),
    );
    return (response);
  }

  Future<http.Response> removeFavLocation(String token, String name) async {
    var response = await http.delete(
      Uri.parse('https://ontheroad.onrender.com/api/fPlace'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {"name": name},
      ),
    );
    return (response);
  }

  Future<void> sendAction(
      String token, String name, double lat, double long, double speed) async {
    var response = await http.post(
      Uri.parse('https://ontheroad.onrender.com/api/userAction/addAction'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          "name": name,
          "location": [lat, long],
          "speed": speed
        },
      ),
    );
  }
}
