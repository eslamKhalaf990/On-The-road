import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:on_the_road/auto_login.dart';
import 'package:provider/provider.dart';
import '../../constants/design_constants.dart';
import '../../model/secure_storage.dart';
import '../../model/user.dart';
import 'widgets/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final SecuredUserStorage securedUserStorage = SecuredUserStorage();

  // void configureFirebaseMessaging() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Received notification:');
  //     print('Title: ${message.notification?.title}');
  //     print('Body: ${message.notification?.body}');
  //     // Additional data can be accessed using message.data
  //     print('Data: ${message.data}');
  //   });
  // }
  //
  //
  // Future<void> sendPushNotificationToAll(String title, String body) async {
  //   try {
  //     // Initialize Firebase Messaging
  //     FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //     // Create the notification message
  //     RemoteNotification notification = RemoteNotification(
  //       title: title,
  //       body: body,
  //     );
  //     Map<String, String> data1 = {
  //       "event":"Accident"
  //     };
  //     RemoteMessage message = RemoteMessage(
  //       notification: notification,
  //       data: data1,
  //     );
  //     // Create the data message
  //     Map<String, RemoteMessage> data2 = {
  //       "event":message
  //     };
  //
  //     // Create the message
  //
  //
  //     // Send the message to all registered devices
  //     // await messaging.send(to:(await messaging.getToken()).toString(), data: data2);
  //
  //     print('Push notification sent to all users successfully.');
  //   } catch (e) {
  //     print('Error sending push notification: $e');
  //   }
  // }

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
                            onPressed: () {

                            },
                            backgroundColor: Colors.black38,
                            child: const Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                    decoration: DesignConstants.roundedBorder,
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  UserData(
                                      info: "${user.name} USER 1",
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
                              const UserData(
                                info: "ABCQWEF123",
                                icon: Icon(
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
