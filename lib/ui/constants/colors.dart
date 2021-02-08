import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

final Color primaryColor = HexColor('#1167b1');
final Color primaryColorLight = HexColor('#2a9df4');
final Color primaryColorDark = HexColor('#03254c');
final Color backgroundColor = HexColor('#F9F8F7');
final Color textColor = Colors.white;
