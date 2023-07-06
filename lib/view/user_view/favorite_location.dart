import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:on_the_road/Services/map_services.dart';
import 'package:on_the_road/view_model/navigation_on_road_v_m.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';

class FavoriteLoc{
  late String name;
  late Color color;
}
class FavoriteLocation extends StatefulWidget {
  const FavoriteLocation({super.key});

  @override
  _FavoriteLocationState createState() => _FavoriteLocationState();
}

class _FavoriteLocationState extends State<FavoriteLocation> {
  Color c = Colors.red.shade700;
  late List<FavoriteLoc> favList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var len =Provider.of<User>(context, listen: false).favoritePlaces.length;
    var fav =Provider.of<User>(context, listen: false).favoritePlaces;
    for(int i=0;i<len;i++){
      FavoriteLoc f = FavoriteLoc();
      f.name = fav[i]['name'];
      f.color = Colors.red.shade700;
      favList.add(f);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: const Text(
                "FAVORITE LOCATIONS",
                style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'tajawal',
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: Provider.of<User>(context).favoritePlaces.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: DesignConstants.roundedBorder,
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(3),
                    child: ListTile(
                      title: Text(
                        Provider.of<User>(context).favoritePlaces[index]['name'],
                        style: const TextStyle(fontFamily: 'tajawal'),
                      ),
                      onTap: () async {
                      },
                      trailing: IconButton(
                          onPressed: (){
                            MapServices services = MapServices();
                            services.removeFavLocation(Provider.of<User>(context, listen: false).token,
                                Provider.of<User>(context, listen: false).favoritePlaces[index]['name']);
                            setState(() {
                              favList[index].color = Colors.white;
                            });
                          },
                          icon: const Icon(Icons.favorite), color: favList[index].color,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
