import 'package:flutter/material.dart';

extension MyColors on Color {
  static MaterialColor primary = const MaterialColor(0XFF5E59FF, <int, Color>{
    900: Color(0XFF3F3BAA),
    700: Color(0XFF4E4AD4),
    500: Color(0XFF5E59FF),
    300: Color(0XFF7975FF),
    100: Color(0XFFF0F0FF),
  });

  static MaterialColor secondary = const MaterialColor(0xFF808390, <int, Color>{
    900: Color(0XFF4D4F56),
    700: Color(0XFF666973),
    500: Color(0xFF808390),
    300: Color(0XFF999CA6),
    100: Color(0XFFF3F3F4),
  });

  static MaterialColor neutral = const MaterialColor(0xFF707784, {
    900: Color(0xFF101623),
    800: Color(0xFF232B39),
    700: Color(0xFF3B4453),
    600: Color(0xFF515966),
    500: Color(0xFF707784),
    400: Color(0xFFA0A8B0),
    300: Color(0xFFD3D6DA),
    200: Color(0xFFE5E7EB),
    100: Color(0xFFF4F5F6),
    50: Color(0xFFFAFAFA),
  });

  //error
  static MaterialColor error = const MaterialColor(0xFFFF5630, <int, Color>{
    900: Color(0xFFAA3920),
    700: Color(0xFFD44828),
    500: Color(0xFFFF5630),
    300: Color(0xFFFF7252),
    100: Color(0xFFFFF2F0),
  });

  //warning
  static MaterialColor warning = const MaterialColor(0xFFFFAB00, <int, Color>{
    900: Color(0xFFAA7200),
    700: Color(0xFFD48E00),
    500: Color(0xFFFFAB00),
    300: Color(0xFFFFB92A),
    100: Color(0xFFFFF7E5),
  });

  //success
  static MaterialColor success = const MaterialColor(0xFF36B37E, <int, Color>{
    900: Color(0xFF247754),
    700: Color(0xFF2D9569),
    500: Color(0xFF36B37E),
    300: Color(0xFF57C093),
    100: Color(0xFFE5F5EE),
  });

  //success
  static MaterialColor info = const MaterialColor(0xFF0065FF, <int, Color>{
    900: Color(0xFF0043AA),
    700: Color(0xFF0054D4),
    500: Color(0xFF0065FF),
    300: Color(0xFF2A7FFF),
    100: Color(0xFFE6F0FF),
  });

  //Background
  static Color backgroundWhite = const Color(0XFFFFFFFF);
}
