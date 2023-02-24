// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:on_the_road/Services/MapServices.dart';

import 'SignIn.dart';
import 'SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Services/SignUpService.dart';
import 'MapPage.dart';

class LoadingScreen extends StatefulWidget {
  String name;
  String email;
  String password;
  LoadingScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      }
  );
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    signUp(widget.name, widget.email, widget.password);
  }
  void signUp(String name, String email, String password) async {
    SignUp signUp = SignUp();
    var response = await signUp.signUp(name, email, password);
    print(response.statusCode);
    if(response.statusCode == 201 || response.statusCode==200){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignInScreen(signedIn: "sign in",);
          },
        ),
      );
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignUpScreen(signedIn: "failed",);
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
            token: token,
            longitude: long,
            latitude: lat,
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
