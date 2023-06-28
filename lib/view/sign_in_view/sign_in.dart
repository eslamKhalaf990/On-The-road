import 'package:flutter/material.dart';
import 'package:on_the_road/model/secure_storage.dart';
import '../../constants/design_constants.dart';
import 'Widgets/widgets.dart';
import 'loading_sign_in.dart';

class SignInScreen extends StatefulWidget {
  final String signedIn;
  const SignInScreen({
    super.key,
    required this.signedIn,
  });

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  SecuredUserStorage securedUserStorage = SecuredUserStorage();
  late String state;
  late Color color;

  @override
  void initState() {
    super.initState();
    if (widget.signedIn == "failed") {
      state = "Username doesn't match password";
      color = Colors.redAccent;
    } else {
      state = "";
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
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(top: 7),
                decoration: DesignConstants.roundedBorder,
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const Text(
                            "SIGN IN",
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'tajawal',
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            state,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'tajawal',
                                fontWeight: FontWeight.w900,
                                color: color),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Field(
                      name: "Username",
                      icon: const Icon(Icons.email_rounded),
                      controller: _controllerName,
                      obsText: false,
                    ),
                    Field(
                      name: "Password",
                      icon: const Icon(Icons.key_rounded),
                      controller: _controllerPassword,
                      obsText: true,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, top: 5, bottom: 5, right: 5),
                      child: Row(
                        children: const [
                          Text(
                            "Forget your ",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'tajawal',
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "password?",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16,
                                fontFamily: 'tajawal',
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
                                    MaterialStatePropertyAll(Colors.grey),
                            ),
                            onPressed: () {

                              securedUserStorage.saveCredentials(_controllerName, _controllerPassword);

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoadingSignIn(
                                    name: _controllerName.text,
                                    password: _controllerPassword.text,
                                );
                              }));
                            },
                            child: const Text(
                              'SIGN IN',
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
