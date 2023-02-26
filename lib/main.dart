import 'package:flutter/material.dart';
import 'package:on_the_road/AutoLogin.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("images/n.jpg"), context);
    return MaterialApp(
      title: 'On The Road',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AutoLogIn(),
    );
  }
}
