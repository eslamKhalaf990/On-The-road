import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_the_road/AutoLogin.dart';

import '../../model/secure_storage.dart';
import '../../model/user.dart';
import 'widgets/widgets.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({super.key,required this.user,
  });


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SecuredUserStorage securedUserStorage = SecuredUserStorage();
  late User user;
  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                UserAvatar(user: user,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.black12,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 0.1),
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
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  children:[
                                    const Expanded(child: SizedBox()),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 1),
                                      child: IconButton(
                                        onPressed: () {
                                          print("logged Out");
                                          securedUserStorage.deleteCredentials();
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                            return const AutoLogIn();
                                          }));
                                        },
                                        icon: const Icon(Icons.logout_outlined, size: 35,
                                          color: Color(0xffAA0000),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  UserData(info: user.name,),
                                  const UserData(info: "01234567890",),
                                ],
                              ),
                              UserData(info: user.email,),
                            ],
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