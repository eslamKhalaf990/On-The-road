// ignore_for_file: use_build_context_synchronously
import 'sign_in.dart';
import 'sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../Services/sign_up_services.dart';

class LoadingSignUp extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const LoadingSignUp(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      }
  );
  @override
  State<LoadingSignUp> createState() => _LoadingSignUpState();
}

class _LoadingSignUpState extends State<LoadingSignUp> {
  @override
  void initState() {
    super.initState();
    signUp(widget.name, widget.email, widget.password);
  }
  void signUp(String name, String email, String password) async {
    SignUp signUp = SignUp();
    var response = await signUp.signUp(name, email, password);
    print(response.statusCode);
    if(response.statusCode == 201 || response.statusCode == 200){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const SignInScreen(signedIn: "sign in",);
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
