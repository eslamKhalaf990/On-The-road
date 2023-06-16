import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/user.dart';
import '../road_sign_view/add_sign.dart';
import '../../auto_login.dart';

class Admin extends StatefulWidget {
  late User user;
  Admin({super.key,required this.user,
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
                            style: TextStyle(fontSize: 40, fontFamily: 'tajawal', fontWeight: FontWeight.w900, color: Colors.grey),
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
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(15),
                                child: Row(
                                  children:[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10, right: 20),
                                        child: const Icon(Icons.person, size: 25, color: Colors.grey
                                        ),
                                    ),
                                    const Text(
                                      "Admin One",
                                      style: TextStyle(fontSize: 25, fontFamily: 'tajawal', fontWeight: FontWeight.w900, color: Colors.grey),
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
                                           color: Colors.grey
                                      ),
                                    ),
                                    const Text(
                                      "admin@mail.com",
                                      style: TextStyle(fontSize: 25, fontFamily: 'tajawal', fontWeight: FontWeight.w900, color: Colors.grey),
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
                                           color: Colors.grey
                                      ),
                                    ),
                                    const Text(
                                      "01234567890",
                                      style: TextStyle(fontSize: 25, fontFamily: 'tajawal', fontWeight: FontWeight.w900, color: Colors.grey),
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
                                    return AddSign(token: widget.user.token);
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