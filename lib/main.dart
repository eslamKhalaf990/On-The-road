import 'package:flutter/material.dart';
import 'package:on_the_road/Services/position_stream.dart';
import 'package:on_the_road/auto_login.dart';
import 'package:on_the_road/model/settings.dart';
import 'package:provider/provider.dart';
import 'model/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_)=>User()),
        ChangeNotifierProvider<SettingsModel>(create: (_)=>SettingsModel()),
        ChangeNotifierProvider<PositionStream>(create: (_)=>PositionStream()),
      ],
      child: MaterialApp(
        title: 'On The Road',
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AutoLogIn(),
      ),
    );
  }
}
