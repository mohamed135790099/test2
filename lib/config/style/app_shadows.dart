import 'package:flutter/material.dart';

class AppShadows {
  static const shadow1 = [
    BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.08),
        offset: Offset(0, 4),
        blurRadius: 25,
        spreadRadius: 0),
  ];
  static const shadow2 = [
    BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.04),
        offset: Offset(0, 4),
        blurRadius: 25,
        spreadRadius: 0),
  ];
}
