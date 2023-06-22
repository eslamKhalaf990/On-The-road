import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/view/home_view/widgets/dialog_box.dart';
import '../constants/constants_on_map.dart';
import '../model/Navigation.dart';
import 'map_services.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class PositionStream extends ChangeNotifier {
  Navigation navigation = Navigation();
  List<ChartData> chartData = <ChartData>[];
  late StreamSubscription positionStream;
  late StreamSubscription positionStreamForCamera;
  Set<Marker> markersOnMap = {};
  bool analyze = false;
  bool isStreaming = false;
  int time = 0;
  var signsOnRoad;

  int i = 0;

  Future<void> streamPosition(Completer<GoogleMapController> _controller, BuildContext ctx,
      MapServices services, String token, Constants constants, locationAccuracy) async {
    int cnt = 0;
    double sum = 0.0;
    final GoogleMapController mapController = await _controller.future;

    LocationSettings locationSettings = LocationSettings(
      accuracy: locationAccuracy,
      distanceFilter: 0,
    );

    startTimer();
    getSignsAroundUser(services, token);
    getNearestSign(ctx);

    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) async {

      navigation.currentSpeed = position.speed * 3.6;

      if(navigation.currentSpeed>navigation.maxSpeed){
        navigation.maxSpeed = navigation.currentSpeed;
      }
      navigation.position = position;
      isStreaming = true;

      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(navigation.position.latitude, navigation.position.longitude),
            zoom: await mapController.getZoomLevel(),
          ),
        ),
      );

      sum += navigation.currentSpeed;
      cnt++;

      navigation.avgSpeed = sum / cnt;
      navigation.distanceTraveled = (navigation.avgSpeed*0.277778*time)/1000;

      if (analyze) {
        i++;
        chartData.add(
          ChartData(i.toString(), navigation.currentSpeed),
        );
      }
      notifyListeners();
    });
  }

  addMarkers(Constants constants, String token) async {
    MapServices services = MapServices();
    var response = await services.getSigns(token);
    var data = json.decode(response.body);
    for (int i = 0; i < data.length; i++) {
      markersOnMap.add(
        Marker(
          markerId: MarkerId('$i'),
          position: LatLng(data[i]['location']['coordinates'][1] * 1.0,
              data[i]['location']['coordinates'][0] * 1.0),
          icon: data[i]['name']=="Traffic Light"?constants.trafficLights:constants.stopSign,
        ),
      );
    }
    notifyListeners();
  }

  getNearestSign(BuildContext ctx){
    Timer.periodic(const Duration(seconds: 10), (timer) async{
    for (int i = 0; i < signsOnRoad.length; i++) {
      double distance = Geolocator.distanceBetween(
        navigation.position.latitude,
        navigation.position.longitude,
        signsOnRoad[i]['location']['coordinates'][1],
        signsOnRoad[i]['location']['coordinates'][0],
      );

      if (distance < 100) {
        print("distance: $distance");
        navigation.warning = "There Is A Stop Sign\n In Less Than 100 meters";
        navigation.warningColor = Colors.red;
        showAutoDismissDialog(ctx, "traffic light");
        break;
      }
      else if(distance<5){

      }
      else {
        navigation.warning = "";
        navigation.warningColor = Colors.blue;
      }
    }
    });
  }

  getSignsAroundUser(MapServices services, String token)async{
      signsOnRoad = json.decode((await services.getSigns(token)).body);
      Timer.periodic(const Duration(seconds: 50), (timer) async{
        signsOnRoad = json.decode((await services.getSigns(token)).body);
        print("Getting Signs on road");
      });
  }

  startTimer(){
    Timer(const Duration(seconds: 0), () {
      print('Timer started!');
      //pause if speed < 1

      Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        time++;
        print('Seconds passed: $time');
      });

    });
  }

  analyzeAvg() {
    analyze = true;
  }
}
