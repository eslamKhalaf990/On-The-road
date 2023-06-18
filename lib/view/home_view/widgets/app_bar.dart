import 'package:flutter/material.dart';
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              // color: Color(0xffEEEEEE),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 0.1), // changes position of shadow
            ),
          ],
      ),
      height: 70,
      margin: const EdgeInsets.only(left: 2, right: 2, top: 3, bottom: 3),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: Container(
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                  },
                  icon: const Icon(
                    Icons.navigation_outlined,
                    size: 35,
                    color: Colors.red,
                  ),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.analytics_outlined,
                    size: 35,
                    color: Colors.grey,
                  ),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings_applications_outlined,
                    size: 35,
                    color: Colors.grey,
                  ),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  onPressed: () {
                    // if (_activeColor == Colors.green) {
                    //   positionStream.cancel();
                    // }
                    // setState(() {
                    //   _activeColor = Colors.grey;
                    // });
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //       return Profile(
                    //         token: widget.token,
                    //       );
                    //     }));
                  },
                  icon: CircleAvatar(
                    radius: 18,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      child: Image.asset('images/admin.png'),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
