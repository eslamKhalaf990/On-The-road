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
      user.name = jsonDecode(response.body)['user']['username'];
      user.email = jsonDecode(response.body)['user']['email'];
      user.isAdmin = jsonDecode(response.body)['user']['isAdmin'];
      user.exist = true;
      print("---------------------------");
      print("---------------------------");
      print(jsonDecode(response.body));
      print("---------------------------");
      print("---------------------------");
      if (jsonDecode(response.body)['user']['phone'] == null) {
        user.phoneNumber = "NaN";
      } else {
        user.phoneNumber = jsonDecode(response.body)['user']['phone'];
      }
      if (jsonDecode(response.body)['user']['car_type'] == null) {
        user.carType = "NaN";
      } else {
        user.carType = jsonDecode(response.body)['user']['car_type'];
      }
      if (jsonDecode(response.body)['user']['age'] == null) {
        user.age = 0;
      } else {
        user.age = jsonDecode(response.body)['user']['age'];
      }
      if (jsonDecode(response.body)['user']['gender'] == null) {
        user.gender = true;
      } else {
        user.gender = jsonDecode(response.body)['user']['gender'];
      }
    }
    return user;
  }
}
