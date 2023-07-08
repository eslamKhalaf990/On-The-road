import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/model/secure_storage.dart';
import 'package:on_the_road/model/settings.dart';
import 'package:provider/provider.dart';
import '../../constants/design_constants.dart';
import '../../ai_models/tree_accelaration/gyroscope.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SecuredUserStorage securedUserStorage = SecuredUserStorage();
  // TextEditingController distance = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (BuildContext context, settingsModel, child) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: const Text(
                      "SETTINGS",
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'tajawal',
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    height: 130,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: DesignConstants.roundedBorder,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(settingsModel.icons[0]),
                          title: Text(settingsModel.settings[0]),
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: settingsModel.options[0].length,
                            itemBuilder: (BuildContext ctx, k) {
                              return Container(
                                margin:
                                    const EdgeInsets.only(right: 1, left: 1),
                                child: Row(
                                  children: [
                                    if (settingsModel.options[0][k] is String)
                                      MaterialButton(
                                        onPressed: () {
                                          if (k == 0) {
                                            settingsModel.locationAccuracy =
                                                LocationAccuracy
                                                    .bestForNavigation;
                                          } else if (k == 2) {
                                            settingsModel.locationAccuracy =
                                                LocationAccuracy.lowest;
                                          }
                                        },
                                        child:
                                            Text(settingsModel.options[0][k]),
                                      )
                                    else
                                      MaterialButton(
                                        onPressed: () {
                                        },
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(13),
                                          ),
                                          child: Image(
                                            height: 45,
                                            image: settingsModel.options[0][k],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 130,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: DesignConstants.roundedBorder,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(settingsModel.icons[1]),
                          title: Text(settingsModel.settings[1]),
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: settingsModel.options[1].length,
                            itemBuilder: (BuildContext ctx, k) {
                              return Container(
                                margin:
                                    const EdgeInsets.only(right: 1, left: 1),
                                child: Row(
                                  children: [
                                    if (settingsModel.options[1][k] is String)
                                      MaterialButton(
                                        onPressed: () {
                                          if (k == 0) {
                                            settingsModel.mapTheme =
                                                MapType.normal;
                                          } else if (k == 1) {
                                            settingsModel.mapTheme =
                                                MapType.satellite;
                                          }
                                        },
                                        child:
                                            Text(settingsModel.options[1][k]),
                                      )
                                    else
                                      MaterialButton(
                                        onPressed: () {
                                          if ( k == 0) {
                                            settingsModel.mapTheme =
                                                MapType.normal;
                                          } else if ( k == 1) {
                                            settingsModel.mapTheme =
                                                MapType.satellite;
                                          }
                                        },
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(13),
                                          ),
                                          child: Image(
                                            height: 45,
                                            image: settingsModel.options[1][k],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 130,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: DesignConstants.roundedBorder,
                    child: ListTile(
                      leading: const Icon(Icons.gesture),
                      title: const Text('Gyroscope'),
                      trailing: Switch(
                        value: Provider.of<SettingsModel>(context,listen: false).isGyroscopeOn,
                        onChanged: (value) {
                          setState(() {
                            securedUserStorage.saveGyroState(value);
                            Provider.of<SettingsModel>(context,listen: false).setGyroState(value);
                            if(Provider.of<SettingsModel>(context,listen: false).gyro.working){
                              Provider.of<SettingsModel>(context, listen: false).gyro.end();
                            }
                            else{
                              Provider.of<SettingsModel>(context, listen: false).gyro.start();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: DesignConstants.roundedBorder,
                    child: ListTile(
                      leading: const Icon(Icons.notification_important),
                      title: const Text('Notify Distance'),
                      trailing: SizedBox(
                        width: 120,
                        child: TextFormField(
                          initialValue: settingsModel.notifyDistance.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if(value.isNotEmpty){
                              securedUserStorage.saveDistanceState(double.parse(value));
                              settingsModel.setNotifyDistance(double.parse(value));
                            }
                          },
                          // controller: distance,
                          decoration: const InputDecoration(
                            hintText: 'Enter distance',
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: DesignConstants.roundedBorder,
                    child: ListTile(
                      leading: const Icon(Icons.timer),
                      title: const Text('Safe Distance'),
                      trailing: ToggleButtons(
                        borderRadius: BorderRadius.circular(8),
                        selectedColor: Colors.white,
                        fillColor: Colors.blue,
                        isSelected: [
                          settingsModel.safeDistanceTime == 2.0,
                          settingsModel.safeDistanceTime == 3.0,
                        ],
                        onPressed: (index) {
                          settingsModel.safeDistanceTime = [2.0, 3.0][index];
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('2 sec'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('3 sec'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: DesignConstants.roundedBorder,
                    child: ListTile(
                      leading: const Icon(Icons.question_answer),
                      title: const Text('Ask About Objects on Road'),
                      trailing: Switch(
                        value: Provider.of<SettingsModel>(context).askAboutObjects,
                        onChanged: (value) {
                          settingsModel.setAskAboutObjects(value);
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: DesignConstants.roundedBorder,
                    child: ListTile(
                      leading: const Icon(Icons.volume_up),
                      title: const Text('Voice Assist'),
                      trailing: Switch(
                        value: settingsModel.voiceAssistEnabled,
                        onChanged: (value) {
                          settingsModel.setVoiceAssistEnabled(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
