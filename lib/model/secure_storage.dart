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
  void saveGyroState(bool state){

    const storage = FlutterSecureStorage();
    storage.write(
      key: "gyroscope_state",
      value: state.toString(),
    );
  }
  Future<String> getGyroState()async{
    const storage = FlutterSecureStorage();

    String? state = await storage.read(
      key: "gyroscope_state",
    );
    print("-----------------------------");
    print(state);
    print("-----------------------------");

    return state!;
  }

  void deleteCredentials(){
    const storage = FlutterSecureStorage();
    storage.deleteAll();
  }
}