import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location.dart';

class User extends ChangeNotifier {
  late String name;
  late String email;
  late String token;
  late String password;
  late String drivingLicense;
  late String profilePicture;
  late String phoneNumber;
  late bool isAdmin;
  late String id;
  late Location location = Location();
  late bool exist;
  late var favoritePlaces;

  updateUser(User user) {
    name = user.name;
    email = user.email;
    token = user.token;
    isAdmin = user.isAdmin;
    exist = user.exist;
    id = user.id;
    location = user.location;
    notifyListeners();
  }
}
