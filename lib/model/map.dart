import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map{
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Marker> markersOnMap = {};
  late BitmapDescriptor currentBitmap;
  late BitmapDescriptor bitmap;
  late double _apiSpeed;
  late Position position;
  late String warning = "";

}