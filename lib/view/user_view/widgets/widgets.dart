import 'package:flutter/material.dart';

import '../../../model/user.dart';

class UserData extends StatelessWidget {
  const UserData({
    super.key,
    required this.info, required this.icon,

  });
  final String info;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      margin: const EdgeInsets.all(5),
      child: Row(
        children:[
          Container(
            margin: const EdgeInsets.only(bottom: 4, right: 10),
            child: icon,
          ),
          Text(
            info,
            style: const TextStyle(fontSize: 20, fontFamily: 'tajawal', fontWeight: FontWeight.w900),
            textAlign: TextAlign.left,
          ),
          // Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Container(
        margin: const EdgeInsets.all(1),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            margin: const EdgeInsets.all(2),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3.0,
                        spreadRadius: 3,
                        blurStyle: BlurStyle.normal,
                        offset: Offset(0.0, 3.0,),
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: "profile",
                    child: CircleAvatar(
                      radius: 50,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          child: Image.asset('images/admin.png')),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 20),
                  child: Text(
                    user.name,
                    style: const TextStyle(fontSize: 30,color: Colors.grey, fontFamily: 'tajawal',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}