import 'LoadingSignIn.dart';
import 'SignUp.dart';
import 'SignIn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  ImageProvider logo = const AssetImage("images/2.png");
  @override
  void initState() {
    super.initState();
    // autoLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(left: 1, right: 1, bottom: 7),
              child: const ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  child: Image(image: AssetImage('images/n.jpg'),)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Text(
                    'ON ROAD',
                    style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Increasing use of computer technology in transportation'
                    ' will provide us with much greater levels of safety and reliability',
                    style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(fontSize: 20)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 120),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: 140,
                    height: 50,
                    child:  ClipRRect(
                      borderRadius:const BorderRadius.all(
                           Radius.circular(17)
                      ),
                      child: TextButton(
                        style: const ButtonStyle(
                            backgroundColor:
                            MaterialStatePropertyAll(Colors.grey)),
                        onPressed: () {
                          // read();
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return SignInScreen(signedIn: "sign in",);
                          }));
                        },
                        child: Text(
                          'SIGN IN',
                          style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: 140,
                    height: 50,
                    child: ClipRRect(
                      borderRadius:const BorderRadius.all(
                           Radius.circular(17),
                      ),
                      child: TextButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.grey)),
                        onPressed: () {
                          // save();
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return SignUpScreen(signedIn: "sign up",);
                          }));
                        },
                        child: Text(
                          'SIGN UP',
                          style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
