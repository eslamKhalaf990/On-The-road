// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_the_road/welcome.dart';
import 'view/sign_in_view/loading_sign_in.dart';

class AutoLogIn extends StatefulWidget {
  const AutoLogIn({Key? key}) : super(key: key);

  @override
  State<AutoLogIn> createState() => _AutoLogInState();
}

class _AutoLogInState extends State<AutoLogIn> {
  @override
  void initState() {
    super.initState();
    autoLogIn();
  }
  void autoLogIn()async{
    const _storage = FlutterSecureStorage();
    String? username = await _storage.read(key: "Key_Username");
    String? password = await _storage.read(key: "Key_Password");
    print(await _storage.read(key: "Logged_In"));

    if(await _storage.read(key: "Logged_In") == "true"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return LoadingSignIn(name: username.toString(),
            password: password.toString());
      }));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return const WelcomeScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
