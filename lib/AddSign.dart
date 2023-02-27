import 'package:flutter/material.dart';
import 'Services/MapServices.dart';

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
  final TextEditingController _controllerLongitude = TextEditingController();
  final TextEditingController _controllerLatitude = TextEditingController();
  late String state = "";
  late Color color = Colors.black;

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
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(top: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 0.1), // changes position of shadow
                    ),
                  ],
                ),
                child: ListView(children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This Field Is Required';
                        }
                        return null;
                      },
                      controller: _controllerSignName,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: "Sign Name",
                        labelStyle: TextStyle(fontFamily: 'tajawal'),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This Field Is Required';
                        }
                        return null;
                      },
                      controller: _controllerLongitude,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: "LONGITUDE",
                        labelStyle: TextStyle(fontFamily: 'tajawal'),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This Field Is Required';
                        }
                        return null;
                      },
                      controller: _controllerLatitude,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: "LATITUDE",
                        labelStyle: TextStyle(fontFamily: 'tajawal'),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 70,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: TextButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey)),
                          onPressed: () async {
                            // print(_controllerSignName.text);
                            // print(_controllerLongitude.text);
                            // print(_controllerLatitude.text);
                            // AddSignToMap addSign = AddSignToMap();
                            MapServices services = MapServices();
                            // GetLocation location = GetLocation();
                            await services.getCurrentLocation();
                            var response = await services.addSign(
                                _controllerSignName.text,
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
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 70,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: TextButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey)),
                          onPressed: () async {
                            MapServices services = MapServices();
                            var response = await services.addSign(
                              _controllerSignName.text,
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
                ]),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
