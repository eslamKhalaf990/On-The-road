import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location.dart';

class User extends ChangeNotifier {
  late String name;
  late String email;
  late String token;
  late String password;
  late String carType;
  late String profilePicture;
  late String phoneNumber;
  late bool isAdmin;
  late bool gender;
  late int age;
  late String id;
  late Location location = Location();
  late bool exist = false;
  late var favoritePlaces;

  updateUser(User user) {
    name = user.name;
    email = user.email;
    token = user.token;
    isAdmin = user.isAdmin;
    exist = user.exist;
    location = user.location;
    favoritePlaces = user.favoritePlaces;
    notifyListeners();
  }
}
