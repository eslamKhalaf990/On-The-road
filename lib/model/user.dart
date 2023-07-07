import 'dart:convert';
import 'package:flutter/material.dart';
import '../Services/map_services.dart';
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
  late List<FavoriteLoc> favList = [];

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

  var favoriteLocations;

  void getFavLocation()async{
    MapServices services = MapServices();
    favoriteLocations = jsonDecode((await services.getFavLocations(token)).body);
    int len = favoriteLocations.length;
    if(favList.isNotEmpty){
      favList.clear();
    }
    for(int i=0;i<len;i++){
      FavoriteLoc f = FavoriteLoc();
      f.name = favoriteLocations[i]['name'].toString();
      f.color = Colors.red.shade700;
      favList.add(f);
    }
    notifyListeners();
  }
}

class FavoriteLoc{
  late String name;
  late Color color;
}