import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredUserStorage{
  void saveCredentials(TextEditingController controllerName, TextEditingController controllerPassword ){

    const storage = FlutterSecureStorage();
    storage.write(
      key: "Key_Username",
      value: controllerName.text,
    );
    storage.write(
      key: "Key_Password",
      value: controllerPassword.text,
    );
    storage.write(key: "Logged_In", value: "true");
  }
  void deleteCredentials(){
    const storage = FlutterSecureStorage();
    storage.deleteAll();
  }
}