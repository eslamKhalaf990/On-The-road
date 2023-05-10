import 'package:flutter/material.dart';
import 'Widgets/widgets.dart';
import 'loading_sign_up.dart';

class SignUpScreen extends StatefulWidget {
  String signedIn;
  SignUpScreen({
    super.key,
    required this.signedIn,
  });

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  late String state;
  late Color color;

  @override
  void initState() {
    super.initState();
    if (widget.signedIn == "failed") {
      state = "Email Already Exist, Try different one";
      color = Colors.redAccent;
    } else {
      state = "FILL THIS FORM WITH YOUR INFORMATION";
      color = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 1, right: 1, bottom: 0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                  child: Image.asset("images/n.jpg")),
            ),
            // const Expanded(child: SizedBox()),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(7),
                margin: const EdgeInsets.only(top: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 0.1), // changes position of shadow
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    const Text(
                      "SIGN UP",
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'tajawal',
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      state,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'tajawal',
                          fontWeight: FontWeight.w900,
                          color: color),
                      textAlign: TextAlign.center,
                    ),
                    Field(
                      name: "Full Name",
                      icon: const Icon(Icons.person),
                      controller: _controllerName,
                      obsText: false,
                    ),
                    Field(
                      name: "Email or Username",
                      icon: const Icon(Icons.email_rounded),
                      controller: _controllerEmail,
                      obsText: false,
                    ),
                    Field(
                      name: "Password",
                      icon: const Icon(Icons.key_rounded),
                      controller: _controllerPassword,
                      obsText: true,
                    ),
                    // const Expanded(child: SizedBox()),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 140,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          child: TextButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.grey)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoadingSignUp(
                                    name: _controllerName.text,
                                    email: _controllerEmail.text,
                                    password: _controllerPassword.text);
                              }));
                            },
                            child: const Text(
                              'SIGN UP',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'tajawal',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
