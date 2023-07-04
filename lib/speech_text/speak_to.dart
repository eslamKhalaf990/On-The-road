import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_the_road/speech_text/speech_to_text.dart' as s;
import 'package:provider/provider.dart';
import '../services/map_services.dart';
import '../../constants/text-speech.dart';
import '../view/home_view/home.dart';
import '../view_model/navigation_on_road_v_m.dart';
import 'package:on_the_road/view/home_view/widgets/bottom_bar.dart';

Future<void> toggleListening(BuildContext context,
    Completer<GoogleMapController> _controller, MapServices services) async {
  var word = await s.sttFn(['yes', 'no', 'home', 'fci', 'navigation']);
  print("the function has returned ${word.toString()}");
  if (word.toString() == 'yes') {
    TextSpeech.speak("thank you for your feedback");
  }
  if (word.toString() == 'navigation') {
    if (context.mounted) {
      startNavigation(context, _controller, services);
    }
  }

  if (word.toString() == 'fci') {
    TextSpeech.speak("Going to your college from your current location");
    MapServices service = MapServices();
    await service.getCurrentLocation();
    LatLng source = LatLng(service.lat, service.long);
    LatLng destination = const LatLng(30.030243, 31.210859);

    if (context.mounted) {
      Provider.of<NavigationOnRoad>(context, listen: false)
          .getPloyLine(source, destination);
    }
  }
}
