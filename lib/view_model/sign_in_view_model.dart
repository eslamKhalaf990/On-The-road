import 'dart:convert';

import 'package:http/http.dart';
import 'package:on_the_road/Services/sign_in_services.dart';
import 'package:on_the_road/model/user.dart';

class SignInViewModel {
  Future<User> getUserInformation(String username, String password) async {
    SignIn signIn = SignIn();
    User user = User();

    Response response = await signIn.signIn(username, password);

    if (response.statusCode == 200 || response.statusCode == 201) {
      user.token = jsonDecode(response.body)['accessToken'];
      user.name = jsonDecode(response.body)['username'];
      user.email = jsonDecode(response.body)['email'];
      user.id = jsonDecode(response.body)['_id'];
      user.isAdmin = jsonDecode(response.body)['isAdmin'];
      user.exist = true;
      user.favoritePlaces = jsonDecode(response.body)['favouritPlaces'];
    }
    return user;
  }
}
