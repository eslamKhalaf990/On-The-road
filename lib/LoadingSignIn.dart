// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:on_the_road/Services/MapServices.dart';

import 'SignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Services/SignInService.dart';
import 'MapPage.dart';
import 'Admin.dart';

String global_token = "";
double global_long = 0.0;
double global_lat = 0.0;

class LoadingScreen extends StatefulWidget {
  String name;
  String password;
  LoadingScreen({
    super.key,
    required this.name,
    required this.password,
  });
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    signIn(widget.name, widget.password);
  }

  void signIn(String name, String password) async {
    SignIn signIn = SignIn();
    var response = await signIn.signIn(name, password);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      String token = jsonDecode(response.body)['accessToken'];
      global_token = token;
      if (name == "admin") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Admin(token: token);
        }));
      } else {
        getLocation(token);
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignInScreen(
              signedIn: "failed",
            );
          },
        ),
      );
    }
  }

  void getLocation(String token) async {
    MapServices services = MapServices();
    await services.getCurrentLocation();

    double long = services.long;
    double lat = services.lat;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MapScreen(
            longitude: long,
            latitude: lat,
            token: token,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitPulse(
          color: Colors.black54,
          size: 70,
        ),
      ),
    );
  }
}
