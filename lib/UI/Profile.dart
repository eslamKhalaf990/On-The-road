import 'package:flutter/material.dart';

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
                  margin: const EdgeInsets.only(left:1, right: 1, bottom: 0),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Hi! User",
                            style: TextStyle(fontSize: 30, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
                            textAlign: TextAlign.left,
                          ),
                          const Expanded(child: SizedBox()),
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: CircleAvatar(
                              radius: 30,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  child: Image.asset('images/admin.png')),
                            ),
                          )
                        ],
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
                            children: [
                              Container(
                                margin: EdgeInsets.all(15),
                                child: Row(
                                  children:[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10, right: 20),
                                      child: const Icon(Icons.person, size: 25,
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
                                      child: const Icon(Icons.phone_android_rounded, size: 25,
                                      ),
                                    ),
                                    const Text(
                                      "01234567890",
                                      style: TextStyle(fontSize: 25, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
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