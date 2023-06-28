import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/constants/text-speach.dart';
import 'package:on_the_road/view/home_view/widgets/dialog_box.dart';
import '../constants/constants_on_map.dart';
import '../model/Navigation.dart';
import '../view/home_view/home.dart';
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
  late List<LatLng> coordinates = [];
  Set<Marker> markersOnMap = {};
  bool isStreaming = false;
  bool analyze = false;
  var signsOnRoad;
  int time = 0;
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



  getPloyLine(LatLng source, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      constants.googleApiKey,
      PointLatLng(
        source.latitude,
        source.longitude,
      ),
      PointLatLng(
          destination.latitude,
          destination.longitude,
      ),
    );
    print("points length: ${result.points.length}");
    if(coordinates.isNotEmpty){
      coordinates.removeRange(0, coordinates.length);
    }
    result.points.forEach((PointLatLng point) =>
        coordinates.add(LatLng(point.latitude, point.longitude)));
    notifyListeners();
  }

  getNearestSign(BuildContext ctx){

    Timer.periodic(const Duration(seconds: 15), (timer) async{
    for (int i = 0; i < signsOnRoad.length; i++) {
      signsOnRoad[i]['last_notified'] = -120;
      double distance = Geolocator.distanceBetween(
        navigation.position.latitude,
        navigation.position.longitude,
        signsOnRoad[i]['location']['coordinates'][1],
        signsOnRoad[i]['location']['coordinates'][0],
      );
      if(distance<5 ){
        showAutoDismissDialog(ctx, "traffic light");
      }
      if (distance < 100) {
        print("distance: $distance");
        navigation.warning = "There Is A ${signsOnRoad[i]['name']}\n In ${distance.toStringAsFixed(1)} meters";

        Text_Speach.speak(navigation.warning);

        signsOnRoad[i]['last_notified'] = time;
        navigation.warningColor = Colors.red;
        break;
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
