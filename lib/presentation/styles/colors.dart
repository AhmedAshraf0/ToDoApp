import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';

Color buttonColor = const Color(0xFF25C06D);

class MainColor{
  // static int colorNumber = Random().nextInt(1000000);
  Color checkBoxColor = HexColor((Random().nextInt(1000000)).toString()).lighter(20);
  // Color checkMark = HexColor(colorNumber.toString()).lighter(50);
}

