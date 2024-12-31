import 'dart:async';

import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_status_bar.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:dr_mohamed_salah_admin/utils/cache_utils/cache_vars.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    AppStatusBar.hide();
    _loading();
  }

  _loading() {
    Timer(const Duration(seconds: 3), () {
      CacheVars.token != null
          ? RouterApp.pushNamedAndRemoveUntil(RouteName.mainScreen)
          : RouterApp.pushNamedAndRemoveUntil(RouteName.loginScreen);
    });
  }

  @override
  void dispose() {
    super.dispose();
    AppStatusBar.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryBlue,
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: ClipOval(
              child: AppImageView(
                imagePath: Assets.splashIcon,
                height: 165.h,
                width: 150.w,
                fit: BoxFit.fill,
              ),
            ),
          ),
          16.hs,
          Text("Dr Mohamed Salah", style: AppTextStyle.font16white500),
          8.hs,
          Text("Dentist", style: AppTextStyle.font16white400),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Column(
              children: [
                Text(
                  "Powered by Safe Hand (Version 1)",
                  style: AppTextStyle.font14white400,
                ),
                Text(
                  "2024 All rights reserved@",
                  style: AppTextStyle.font14white400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
