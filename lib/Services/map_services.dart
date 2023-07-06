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

  //Retrieve all signs from Database
  Future<http.Response> getSigns(
      String token, double latitude, double longitude) async {
    var response = await http.get(
      Uri.parse('https://nodeapi-35lq.onrender.com/api/sign/'),
      // https://ontheroad.onrender.com/api/sign/getSign
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    return (response);
  }

  // Future<Response> getNearSigns(String token, double lat, double lng) async {
  //   dio.options.headers['Authorization'] = '$token';
  //   return await dio.get<dynamic>(
  //       'https://ontheroad.onrender.com/api/sign/getSign',
  //       queryParameters: <String, dynamic>{"lat": lat, "long": lng});
  // }

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
}
