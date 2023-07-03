import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/navigation_on_road_v_m.dart';
import '../../../constants/design_constants.dart';
class Warning extends StatelessWidget {
  const Warning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationOnRoad>(
      builder: (BuildContext context, stream, child) {
        return SafeArea(
          child: Column(
            children: [
              Container(
                decoration: DesignConstants.roundedBorder,
                height: 100,
                margin: const EdgeInsets.only(
                    left: 2, right: 2, top: 5, bottom: 3),
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(35)),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(30)),
                        child: Material(
                          color: DesignConstants.dark,
                          elevation: 20,
                          child: SizedBox(
                            height: 98,
                            width: 120,
                            child: Center(
                              child: Text(
                                "${stream.navigation.currentSpeed.toStringAsFixed(2)} km/h\n"
                                    "${stream.navigation.distanceTraveled.toStringAsFixed(2)} km",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: DesignConstants.fontFamily,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          stream.navigation.warning,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: DesignConstants.fontFamily,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}