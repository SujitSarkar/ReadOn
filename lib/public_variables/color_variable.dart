import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CColor{

  static const Color themeColor = Color(0xffCC0027);

  static const Map<int, Color> themeColorMap = {
    50: Color.fromRGBO(236,26,59,.1),
    100: Color.fromRGBO(236,26,59,.2),
    200: Color.fromRGBO(236,26,59,.3),
    300: Color.fromRGBO(236,26,59,.4),
    400: Color.fromRGBO(236,26,59,.5),
    500: Color.fromRGBO(236,26,59,.6),
    600: Color.fromRGBO(236,26,59,.7),
    700: Color.fromRGBO(236,26,59,.8),
    800: Color.fromRGBO(236,26,59,.9),
    900: Color.fromRGBO(236,26,59,1),
  };


  static var portraitMood =SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  static var landscapeMood =SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);

}