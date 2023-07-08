import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:on_the_road/Services/map_services.dart';
import 'package:on_the_road/view_model/navigation_on_road_v_m.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';



class FavoriteLocation extends StatefulWidget {
  const FavoriteLocation({super.key});

  @override
  _FavoriteLocationState createState() => _FavoriteLocationState();
}

class _FavoriteLocationState extends State<FavoriteLocation> {

  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).getFavLocation();
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
                itemCount: Provider.of<User>(context, listen: false).favList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: DesignConstants.roundedBorder,
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(3),
                    child: ListTile(
                      title: Text(
                        Provider.of<User>(context, listen: false).favList[index].name,
                        style: const TextStyle(fontFamily: 'tajawal'),
                      ),
                      onTap: () async {
                      },
                      trailing: IconButton(
                        onPressed: (){
                          MapServices services = MapServices();
                          services.removeFavLocation(Provider.of<User>(context, listen: false).token,
                              Provider.of<User>(context, listen: false).favoriteLocations[index]['name']);
                          setState(() {
                            Provider.of<User>(context, listen: false).favList[index].color = Colors.white;
                            Provider.of<User>(context, listen: false).favList.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.favorite), color: Provider.of<User>(context, listen: false).favList[index].color,
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
