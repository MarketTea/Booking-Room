import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColor {
  static const Color success = Colors.green;
  static const Color warn = Colors.amber;
  static const Color error = Colors.red;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;

  static Color primary = hexToColor('#019549');
  static Color secondary = hexToColor('#505050');
  static Color secondaryLight = hexToColor('#F2F2F2');
  static Color subTitle = hexToColor('#A8A8A8');
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Colors.black;
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
