import 'package:flutter/material.dart';

import '../../../model/user.dart';

class UserData extends StatelessWidget {
  const UserData({
    super.key,
    required this.info,
  });
  final String info;

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
            child: const Icon(Icons.mail_rounded, size: 20,
            ),
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
      margin: const EdgeInsets.only(left:1, right: 1, bottom: 1),
      child: Container(
        margin: const EdgeInsets.all(1),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            margin: const EdgeInsets.all(2),
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
                  child: Text(
                    user.name,
                    style: const TextStyle(fontSize: 30,color: Colors.grey, fontFamily: 'tajawal', fontWeight: FontWeight.bold),
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