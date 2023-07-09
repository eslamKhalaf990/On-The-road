import 'package:firebase_messaging/firebase_messaging.dart';
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

  bool isPasswordLengthValid = false;
  bool isPasswordContainsUppercase = false;
  bool isPasswordContainsNumber = false;
  late String fcToken;
  void getToken()async{
    final firebase = FirebaseMessaging.instance;
    await firebase.requestPermission();
    fcToken = (await firebase.getToken())!;
    print("token: $fcToken");
  }

  @override
  void initState() {
    super.initState();
    if (widget.signedIn == "failed") {
      state = "Email Already Exist, Try a different one";
      color = Colors.redAccent;
    } else {
      state = "FILL THIS FORM WITH YOUR INFORMATION";
      color = Colors.black;
    }
  }

  void checkPassword(String value) {
    setState(() {
      isPasswordLengthValid = value.length >= 6;
      isPasswordContainsUppercase = RegExp(r'[A-Z]').hasMatch(value);
      isPasswordContainsNumber = RegExp(r'[0-9]').hasMatch(value);
    });
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
                  child: Image.asset("images/n.jpg"),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(7),
                  margin: const EdgeInsets.only(top: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView(
                    children: [
                      const Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'tajawal',
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        state,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'tajawal',
                          fontWeight: FontWeight.w900,
                          color: color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Field(
                        name: "Username",
                        icon: const Icon(Icons.person),
                        controller: _controllerName,
                        obsText: false,
                      ),
                      Field(
                        name: "Email",
                        icon: const Icon(Icons.email_rounded),
                        controller: _controllerEmail,
                        obsText: false,
                      ),
                      Field(
                        name: "Password",
                        icon: const Icon(Icons.key_rounded),
                        controller: _controllerPassword,
                        obsText: true,
                        onChanged: checkPassword,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      // Password validation checks
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 7,
                            ),
                            if (_controllerPassword.text.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    isPasswordLengthValid
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: isPasswordLengthValid
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Password must be at least 6 characters",
                                    style: TextStyle(
                                      color: isPasswordLengthValid
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 7,
                            ),
                            if (_controllerPassword.text.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    isPasswordContainsUppercase
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: isPasswordContainsUppercase
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Password must contain an uppercase letter",
                                    style: TextStyle(
                                      color: isPasswordContainsUppercase
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 7,
                            ),
                            if (_controllerPassword.text.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    isPasswordContainsNumber
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: isPasswordContainsNumber
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Password must contain a number",
                                    style: TextStyle(
                                      color: isPasswordContainsNumber
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 7,
                            ),
                          ],
                        ),
                      ),
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
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                              ),
                              onPressed: () async{
                                getToken();
                                print(fcToken);
                                Future.delayed(const Duration(seconds: 2),(){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return LoadingSignUp(
                                          name: _controllerName.text,
                                          email: _controllerEmail.text,
                                          password: _controllerPassword.text,
                                          fcToken: fcToken,
                                        );
                                      }));
                                });

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
      ),
    );
  }
}
