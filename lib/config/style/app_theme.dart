import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color.dart';

ThemeData get appTheme => ThemeData(
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColor.white,
        modalBackgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white),
    useMaterial3: true,
    fontFamily: "cairo",
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: AppColor.white,
            statusBarIconBrightness: Brightness.dark)),
    scaffoldBackgroundColor: Colors.white,
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    colorScheme: const ColorScheme.light(
        primary: Colors.white, background: AppColor.white));
