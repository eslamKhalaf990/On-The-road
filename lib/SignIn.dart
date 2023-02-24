
import 'package:flutter/material.dart';

import 'LoadingSignIn.dart';
import 'Admin.dart';

class SignInScreen extends StatefulWidget {
  String signedIn;
  SignInScreen({super.key,
    required this.signedIn,
  });


  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  late String state;
  late Color color;

  @override
  void initState() {
    super.initState();
    if(widget.signedIn == "failed"){
      state = "Username doesn't match password";
      color = Colors.redAccent;
    }
    else{
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
                  margin: const EdgeInsets.only(left:1, right: 1, bottom: 0),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      child: Image.asset("images/n.jpg")
                  ),
                ),
                // const Expanded(child: SizedBox()),
                Expanded(
                  child: Container(
                    padding:const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: Colors.black54, spreadRadius: 2),
                      ],
                    ),
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            children:  [
                              const Text(
                                "SIGN IN",
                                style: TextStyle(fontSize: 40, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                state,
                                style: TextStyle(fontSize: 18, fontFamily: 'tajawal', fontWeight: FontWeight.w900 ,color: color),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Field(name: "Username", icon: const Icon(Icons.email_rounded),controller: _controllerName, obsText: false,),
                        Field(name: "Password", icon: const Icon(Icons.key_rounded),controller: _controllerPassword,obsText: true,),
                        Container(
                          margin: const EdgeInsets.only(left:10, top: 5, bottom: 5, right: 5),
                          child: Row(
                            children: const [
                              Text(
                                "Forget your ",
                                style: TextStyle(fontSize: 16, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "password?",
                                style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
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
                                    backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return LoadingScreen(name: _controllerName.text,
                                        password: _controllerPassword.text);
                                  }));
                                },
                                child: const Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'tajawal'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),

                // const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ));
  }
}

class Field extends StatelessWidget {

  const Field({super.key, required this.name, required this.icon, required this.controller, required this.obsText});
  final String name;
  final TextEditingController controller;
  final Icon icon;
  final bool obsText;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This Field Is Required';
          }
          return null;
        },
        controller: controller,
        obscureText: obsText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
            borderSide: BorderSide(
                color: Colors.black,
                width: 1
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
            borderSide: BorderSide(
                color: Colors.black,
                width: 1
            ),
          ),
          labelText: name,
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 10, bottom: 6),
            child: icon,
          ),
          labelStyle: const TextStyle(fontFamily: 'tajawal'),
        ),
      ),
    );
  }
}
