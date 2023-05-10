import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapEdit{
  Future<Stream<Position>> getLiveLocation(
      Completer<GoogleMapController> _controller) async {
    var controllerS = StreamController<Position>();
    final GoogleMapController controller = await _controller.future;
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
          // double zoomLevel = await controller.getZoomLevel();

          // var response = await services.getSigns(widget.token);
          // var data = json.decode(response.body);

          // for (int i = 0; i < data.length; i++) {
          //   double distance = Geolocator.distanceBetween(
          //       position.latitude,
          //       position.longitude,
          //       data[i]['location']['coordinates'][1],
          //       data[i]['location']['coordinates'][0]);
          //   if (distance < 100) {
          //      setState(() {
          //       warningColor = Colors.red;
          //       warning = "There Is A Stop Sign\n In Less Than 100 meters";
          //     });
          //   }
          // }
      print(position.longitude);
      controllerS.add(position);

          // setState(() {
          //   markersOnMap =
          //       services.bitmapLiveLocation(markersOnMap, position, currentBitmap);
          //   _apiSpeed = position.speed * 3.6;
          //   if (_apiSpeed < 2) {
          //     _apiSpeed = 0.0;
          //   }
          //
          //   controller.animateCamera(
          //     CameraUpdate.newCameraPosition(
          //       CameraPosition(
          //         target: LatLng(position.latitude, position.longitude),
          //         zoom: zoomLevel,
          //         tilt: 90,
          //         bearing: 10,
          //       ),
          //     ),
          //   );
          // });
        });
    return controllerS.stream;
  }
}