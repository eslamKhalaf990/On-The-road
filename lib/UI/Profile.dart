import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_the_road/AutoLogin.dart';

class Profile extends StatefulWidget {
  late String token;
  Profile({super.key,required this.token,
  });


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left:1, right: 1, bottom: 1),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  child: Image.asset('images/user.jpg')),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: const Text(
                                "USER ONE",
                                style: TextStyle(fontSize: 30,color: Colors.grey, fontFamily: 'tajawal', fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // const Expanded(child: SizedBox()),
                Expanded(
                  child: Container(
                    padding:const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 0.1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  children:[
                                    const Expanded(child: SizedBox()),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10, right: 20),
                                      child: IconButton(
                                        onPressed: () {
                                          print("logged Out");
                                          const storage = FlutterSecureStorage();
                                          storage.deleteAll();
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                            return const AutoLogIn();
                                          }));
                                        },
                                        icon: const Icon(Icons.logout_outlined, size: 35,
                                          color: Color(0xffAA0000),
                                        ),
                                      ),
                                    ),
                                    // Expanded(child: SizedBox()),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  children:[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10, right: 20),
                                      child: const Icon(Icons.person, size: 35,
                                      ),
                                    ),
                                    const Text(
                                      "User One",
                                      style: TextStyle(fontSize: 25, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.left,
                                    ),
                                    // Expanded(child: SizedBox()),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(15),
                                child: Row(
                                  children:[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10, right: 20),
                                      child: const Icon(Icons.mail_rounded, size: 25,
                                      ),
                                    ),
                                    const Text(
                                      "u1@mail.com",
                                      style: TextStyle(fontSize: 22, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.left,
                                    ),
                                    // Expanded(child: SizedBox()),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(15),
                                child: Row(
                                  children:[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10, right: 20),
                                      child: const Icon(Icons.phone_android_rounded, size: 25,
                                      ),
                                    ),
                                    const Text(
                                      "01234567890",
                                      style: TextStyle(fontSize: 22, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.left,
                                    ),
                                    // Expanded(child: SizedBox()),
                                  ],
                                ),
                              ),

                            ],
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