
import 'package:flutter/material.dart';

import 'AddSign.dart';
import 'LoadingSignIn.dart';
import 'RemoveSign.dart';

class Admin extends StatefulWidget {
  late String token;
  Admin({super.key,required this.token,
  });


  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
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
                            "Hi! Admin",
                            style: TextStyle(fontSize: 40, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
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
                                      "Admin One",
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
                                      "admin@mail.com",
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
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: 70,
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
                                    return AddSign(token: widget.token);
                                  }));
                                },
                                child:Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 7, right: 20),
                                        child: const Icon(Icons.add_circle_rounded, size: 30,
                                          color: Color(0xff297A18),
                                        ),
                                      ),
                                      const Text(
                                        'ADD SIGN',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'tajawal'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: 70,
                            height: 60,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: TextButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(Colors.grey),),
                                onPressed: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context){
                                  //   return const RemoveSign();
                                  // }));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 7, right: 20),
                                        child: const Icon(Icons.delete_rounded, size: 30,
                                          color: Color(0xffAA0000),
                                        ),
                                      ),
                                      const Text(
                                        'REMOVE SIGN',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'tajawal'),
                                      ),
                                    ],
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
