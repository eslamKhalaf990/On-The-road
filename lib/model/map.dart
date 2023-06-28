// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../Services/position_stream.dart';
//
// class Map{
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
//   Set<Marker> markersOnMap = {};
//   late BitmapDescriptor currentBitmap;
//   late BitmapDescriptor bitmap;
//   late double _apiSpeed;
//   late Position position;
//   late String warning = "";
//
//   // Future<void> getLiveLocation() async {
//   //   final GoogleMapController controller = await _controller.future;
//   //   PositionStream positionStream = PositionStream();
//   //   positionStream.streamPosition(_controller, controller, services, widget.user.token);
//   //       navigation = event;
//   //       markersOnMap = services.bitmapLiveLocation(
//   //           markersOnMap, navigation.position, constants.currentBitmap);
//   //       controller.animateCamera(
//   //         CameraUpdate.newCameraPosition(
//   //           CameraPosition(
//   //             target: LatLng(
//   //                 navigation.position.latitude, navigation.position.longitude),
//   //             zoom: navigation.zoomLevel,
//   //             tilt: 90,
//   //             bearing: 10,
//   //           ),
//   //         ),
//   //       );
//   //       if (navigation.currentSpeed < 2) {
//   //         timer?.cancel();
//   //       } else {
//   //         startTimer();
//   //       }
//   //       print(navigation.warning);
//   //   });
//   }