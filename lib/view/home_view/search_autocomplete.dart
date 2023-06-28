import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:on_the_road/Services/map_services.dart';
import 'package:on_the_road/Services/position_stream.dart';
import 'package:provider/provider.dart';

class SearchAutocomplete extends StatefulWidget {
  const SearchAutocomplete({super.key});

  @override
  _SearchAutocompleteState createState() => _SearchAutocompleteState();
}

class _SearchAutocompleteState extends State<SearchAutocomplete> {
  final TextEditingController _source = TextEditingController();
  late bool sourceFocus = false;
  late bool destinationFocus = false;
  late bool sourcePicked = false;
  late bool destinationPicked = false;
  late LatLng sourceLatLng;
  late LatLng destinationLatLng;
  final TextEditingController _destination = TextEditingController();
  late List<dynamic> _predictions = [];
  var result;

  Future<LatLng> getLocationDetails(String placeId) async {
    LatLng place = const LatLng(-1.0, -1.0);
    String apiKey = 'AIzaSyA10i_LPMic7RByXKoYmbskcR89Fw7erus';
    String details = 'https://maps.googleapis.com/maps/api/place/details/json';

    String detailsURL = '$details?place_id=$placeId&key=$apiKey';

    var detailsResponse = await http.get(Uri.parse(detailsURL));
    print(detailsResponse.statusCode);

    if (detailsResponse.statusCode == 200) {
      var jsonResponse = json.decode(detailsResponse.body);

      if (jsonResponse['status'] == 'OK') {
        var result = jsonResponse['result'];
        var geometry = result['geometry'];
        var location = geometry['location'];

        double latitude = location['lat'];
        double longitude = location['lng'];
        place = LatLng(latitude, longitude);
        print('Latitude: $latitude');
        print('Longitude: $longitude');
      }
    }
    return place;
  }

  Future<void> _autocompletePlace(String input) async {
    String apiKey = 'AIzaSyA10i_LPMic7RByXKoYmbskcR89Fw7erus';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String url = '$baseUrl?input=$input&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'OK') {
        setState(() {
          _predictions = jsonResponse['predictions'];
        });
      } else {
        setState(() {
          _predictions = [];
        });
      }
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FocusScope(
                          onFocusChange: (focus) => sourceFocus = focus,
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                              ),
                              labelText: "Source",
                              prefixIcon: Container(
                                margin: const EdgeInsets.only(
                                    right: 10, bottom: 0, left: 10),
                                child: const Icon(
                                    Icons.location_searching_outlined),
                              ),
                              labelStyle:
                                  const TextStyle(fontFamily: 'tajawal'),
                            ),
                            controller: _source,
                            onChanged: (value) {
                              _autocompletePlace(value);
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async{
                          _source.text = "Current Location";
                          MapServices service = MapServices();
                          await service.getCurrentLocation();
                          sourceLatLng = LatLng(service.lat, service.long) ;
                          sourcePicked = true;
                        },
                        icon: const Icon(
                          Icons.my_location,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      ".\n.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  FocusScope(
                    onFocusChange: (focus) => destinationFocus = focus,
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: "Destination",
                        prefixIcon: Container(
                          margin: const EdgeInsets.only(
                              right: 10, bottom: 0, left: 10),
                          child: const Icon(Icons.location_on_rounded),
                        ),
                        labelStyle: const TextStyle(fontFamily: 'tajawal'),
                      ),
                      controller: _destination,
                      onChanged: (value) {
                        _autocompletePlace(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _predictions[index]['description'],
                      style: const TextStyle(fontFamily: 'tajawal'),
                    ),
                    onTap: () async {
                      if (sourceFocus) {
                        sourceLatLng = await getLocationDetails(
                            _predictions[index]['place_id']);
                        if (sourceLatLng.latitude != -1.0) {
                          sourcePicked = true;
                          _source.text =  _predictions[index]['description'];
                        }
                      }
                      if (destinationFocus) {
                        destinationLatLng = await getLocationDetails(
                            _predictions[index]['place_id']);
                        if (destinationLatLng.latitude != -1.0) {
                          destinationPicked = true;
                          _destination.text =  _predictions[index]['description'];
                        }
                      }
                      if (sourcePicked &&
                          destinationPicked &&
                          sourceLatLng.latitude != -1.0) {
                        print("both picked");
                        Provider.of<PositionStream>(context, listen: false)
                            .getPloyLine(sourceLatLng, destinationLatLng);
                        Navigator.pop(context);
                      }
                      print('Selected place: ${_predictions[index]}');
                      print("src focus: $sourceFocus");
                      print("dest focus: $destinationFocus");
                      getLocationDetails(_predictions[index]['place_id']);
                    },
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
