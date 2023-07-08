import 'package:flutter/material.dart';

class DesignConstants{
  static String fontFamily = 'tajawal';
  static Color dark = Colors.black12;
  static BoxDecoration roundedBorder = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: DesignConstants.dark,
    boxShadow: [
      BoxShadow(
        color: DesignConstants.dark,
        spreadRadius: 1,
        blurRadius: 2,
        offset: const Offset(0, 0.1), // changes position of shadow
      ),
    ],
  );
}