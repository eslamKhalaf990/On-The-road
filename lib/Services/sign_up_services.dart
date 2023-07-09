import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUp{
  Future<http.Response> signUp(String name, String email, String password, String fcToken)async{

    return await http.post(
      Uri.parse('https://ontheroad.onrender.com/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': name,
        'email': email,
        'password':password,
        'notiLocation':fcToken
      }),
    );
  }
}