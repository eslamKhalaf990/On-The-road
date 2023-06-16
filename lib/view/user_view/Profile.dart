import 'package:flutter/material.dart';
import 'package:on_the_road/auto_login.dart';
import 'package:provider/provider.dart';
import '../../model/secure_storage.dart';
import '../../model/user.dart';
import 'widgets/widgets.dart';

class Profile extends StatelessWidget {
  Profile({
    super.key,
  });

  final SecuredUserStorage securedUserStorage = SecuredUserStorage();

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (BuildContext context, user, child) {
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: UserAvatar(
                        user: Provider.of<User>(context),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 30, right: 5),
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {},
                            backgroundColor: Colors.black38,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 30, right: 10),
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              print("logged Out");
                              securedUserStorage.deleteCredentials();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const AutoLogIn();
                                  },
                                ),
                                (route) => false,
                              );
                            },
                            backgroundColor: Colors.black38,
                            child: const Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                              Row(
                                children: [
                                  UserData(
                                      info: user.name,
                                      icon: const Icon(
                                        Icons.person,
                                      )),
                                  const UserData(
                                    info: "01234567890",
                                    icon: Icon(Icons.phone_android_outlined),
                                  ),
                                ],
                              ),
                              UserData(
                                info: user.email,
                                icon: const Icon(
                                  Icons.email,
                                ),
                              ),
                              UserData(
                                info: user.email,
                                icon: const Icon(
                                  Icons.abc,
                                  size: 40,
                                ),
                              ),
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
      },
    );
  }
}
