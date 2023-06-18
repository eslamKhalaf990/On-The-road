import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/model/settings.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (BuildContext context, settingsModel, child) {
        return Scaffold(
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: settingsModel.settings.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 130,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 4,
                      blurRadius: 2,
                      offset: Offset(0, 0.1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(settingsModel.icons[index]),
                      title: Text(settingsModel.settings[index]),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: settingsModel.options[index].length,
                          itemBuilder: (BuildContext ctx, k) {
                            return Container(
                              margin:
                                  const EdgeInsets.only(right: 1, left: 1),
                              child: Row(
                                children: [
                                  settingsModel.options[index][k] is String
                                      ? MaterialButton(onPressed: () {
                                    print(settingsModel.options[index].length,);
                                    if(index == 0 && k==0){
                                      settingsModel.locationAccuracy = LocationAccuracy.bestForNavigation;
                                    }
                                    else if(index == 0 && k==1){
                                      settingsModel.locationAccuracy = LocationAccuracy.lowest;
                                    }
                                  },
                                      child: Text(settingsModel.options[index][k]))
                                      : MaterialButton(
                                          onPressed: () {
                                            if(index == 1 && k==0){
                                              settingsModel.mapTheme = MapType.normal;
                                            }
                                            else if(index == 1 && k==1){

                                              settingsModel.mapTheme = MapType.satellite;
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(13),
                                            ),
                                            child: Image(
                                              height: 45,
                                              image: settingsModel.options[index][k],),
                                          ),
                                        ),
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}