import 'dart:convert';
import 'package:http/http.dart' as http;

class SignIn{
  Future<http.Response> signIn(String username, String password) async {

    return await http.post(
      Uri.parse('https://nodeapi-35lq.onrender.com/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password':password,
      },
      ),
    );
  }
}

