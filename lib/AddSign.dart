import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Services/MapServices.dart';
import 'MapPage.dart';

class AddSign extends StatefulWidget {
  late String token;
  AddSign({
    super.key,
    required this.token,
  });

  @override
  State<AddSign> createState() => _AddSignState();
}

class _AddSignState extends State<AddSign> {
  final TextEditingController _controllerSignName = TextEditingController();
  late TextEditingController _controllerLongitude = TextEditingController();
  late TextEditingController _controllerLatitude = TextEditingController();
  late BitmapDescriptor currentBitmap;
  late BitmapDescriptor bitmap;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  void customizeBitmap() async {
    bitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/stopSign.png');
    currentBitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/currentLocation.png');
  }

  Set<Marker> markersOnMap = {};
  late String state = "";
  late Color color = Colors.black;
  late double _longitude = 0.0;
  late double _latitude = 0.0;
  var icons = [
    "Stop Sign",
    "Traffic Light",
    "Speed Limit",
    "Radar",
    "Speed Bumps",
  ];
  late String dropdownValue = icons.first;
  @override
  void initState() {
    super.initState();
    longitude = 0.0;
    latitude = 0.0;
    getAdminLocation();
    customizeBitmap();
  }

  void getAdminLocation() async {
    final GoogleMapController controller = await _controller.future;
    MapServices services = MapServices();
    await services.getCurrentLocation();
    double zoom = await controller.getZoomLevel();
    setState(() {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(services.lat, services.long),
            zoom: zoom,
          ),
        ),
      );
      _longitude = services.long;
      _latitude = services.lat;
    });

    print(latitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    "Add Sign To The Map",
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'tajawal',
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    state,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'tajawal',
                        fontWeight: FontWeight.w900,
                        color: color),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Container(
                      height: 450,
                      // width: 100,
                      margin:
                          const EdgeInsets.only(left: 2, right: 2, bottom: 6),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        child: buildGoogleMap(),
                      ),
                    ),
                    DropdownButton<String>(
                      // itemHeight: 100,
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      // elevation: 16,
                      // style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 1,
                        color: Colors.black12,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items:
                          icons.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 2, right: 2, top: 6, bottom: 6),
                      child: SizedBox(
                        // width: 70,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                          child: TextButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.grey)),
                            onPressed: () async {
                              print(_controllerLatitude.text);
                              print(_controllerLongitude.text);
                              print(dropdownValue.toString());
                              if (_controllerLongitude.text == "" ||
                                  _controllerLatitude.text == "") {
                                setState(() {
                                  state = "Please Add Marker On The Map";
                                  color = const Color(0xffAA0000);
                                });
                              } else {
                                MapServices services = MapServices();
                                var response = await services.addSign(
                                  dropdownValue.toString(),
                                  _controllerLongitude.text,
                                  _controllerLatitude.text,
                                  widget.token,
                                );
                                print(response.statusCode);
                                if (response.statusCode == 200 ||
                                    response.statusCode == 201) {
                                  setState(() {
                                    _controllerLatitude.text = "";
                                    _controllerLongitude.text = "";
                                    _controllerSignName.text = "";
                                    state = "Sign Added Successfully";
                                    color = const Color(0xff297A18);
                                  });
                                } else {
                                  setState(() {
                                    color = const Color(0xffAA0000);
                                    state = "Failed To Add Sign!";
                                  });
                                }
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 7, right: 20),
                                    child: const Icon(Icons.add_circle_rounded,
                                        size: 30, color: Color(0xff297A18)),
                                  ),
                                  const Text(
                                    'ADD SIGN',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'tajawal'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 2, right: 2, top: 6, bottom: 6),
                      child: SizedBox(
                        // width: 70,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                          child: TextButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.grey)),
                            onPressed: () async {
                              MapServices services = MapServices();
                              await services.getCurrentLocation();
                              var response = await services.addSign(
                                  dropdownValue.toString(),
                                  services.long.toString(),
                                  services.lat.toString(),
                                  widget.token);
                              print(response.statusCode);
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                setState(() {
                                  _controllerLatitude.text = "";
                                  _controllerLongitude.text = "";
                                  _controllerSignName.text = "";
                                  state = "Sign Added Successfully";
                                  color = const Color(0xff297A18);
                                });
                              } else {
                                setState(() {
                                  color = const Color(0xffAA0000);
                                  state = "Failed To Add Sign! Type Wrong";
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 7, right: 20),
                                    child: const Icon(Icons.my_location_rounded,
                                        size: 30, color: Color(0xff297A18)),
                                  ),
                                  const Text(
                                    'Add Sign To Your Current Location',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'tajawal'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  GoogleMap buildGoogleMap() {
    return GoogleMap(
      onTap: (LatLng l) {
        setState(() {
          _controllerLongitude.text = l.longitude.toString();
          _controllerLatitude.text = l.latitude.toString();
          markersOnMap.add(
            Marker(
              markerId: MarkerId('markerToAdd ${l.longitude}, ${l.latitude}'),
              position: LatLng(
                l.latitude,
                l.longitude,
              ),
              icon: currentBitmap,
            ),
          );
        });
      },
      initialCameraPosition: CameraPosition(
        // target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        // tilt: 90,
        // bearing: 0,
        target: LatLng(_latitude, _longitude),
        zoom: 17,
      ),
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
        MapServices services = MapServices();

        var response = await services.getSigns(widget.token);
        var data = json.decode(response.body);
        print(response.statusCode);

        setState(() {
          for (int i = 0; i < data.length; i++) {
            print(data[i]['location']['coordinates'][1] * 1.0);
            print(data[i]['location']['coordinates'][0] * 1.0);
            markersOnMap.add(
              Marker(
                markerId: MarkerId('$i'),
                position: LatLng(data[i]['location']['coordinates'][1] * 1.0,
                    data[i]['location']['coordinates'][0] * 1.0),
                icon: bitmap,
              ),
            );
          }
        });
      },
      markers: markersOnMap,
    );
  }
}
