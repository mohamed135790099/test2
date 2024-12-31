import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';

extension Dimentions on num {
  SizedBox get hs => SizedBox(height: toDouble().h);

  SizedBox get ws => SizedBox(width: toDouble().w);
}

extension TimeTranslate on Jiffy {
  String get jmAr => jm.replaceAll("PM", "م").replaceAll("AM", "ص");
}

extension S on Widget {
  SizedBox withSize({double? width, double? height}) {
    return SizedBox(
      width: width?.w,
      height: height?.h,
      child: this,
    );
  }

  Padding withHorizontalPadding(double horizontal) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal.w),
      child: this,
    );
  }

  Padding withVerticalPadding(double vertical) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical.h),
      child: this,
    );
  }
}

extension ObjectToJson on Object {
  Map<String, dynamic> get toMapJson {
    var body = jsonEncode(this);
    var json = jsonDecode(body) as Map<String, dynamic>;

    return json;
  }
}

extension StringToJson on String {
  Map<String, dynamic> get toMap {
    log(this);

    Map<String, dynamic> json = jsonDecode(this);
    return json;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
