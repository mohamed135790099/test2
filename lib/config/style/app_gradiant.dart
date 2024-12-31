import 'package:flutter/painting.dart';

class AppGradiant {
  static const gradiant1 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color.fromRGBO(0, 0, 0, 0.00), Color.fromRGBO(0, 0, 0, 0.75)]);
  static const gradiant2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff0162dd), Color(0xff003477)],
  );
  static const gradiant3 = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xBF0162dd), Color(0xBF003477)],
  );
  static const gradiant4 = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xff0162dd), Color(0xff003477)],
  );
}
