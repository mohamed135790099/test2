import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_theme.dart';
import 'package:dr_mohamed_salah_admin/core/screens/no_internet_screen.dart';
import 'package:dr_mohamed_salah_admin/locator.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/check_internet.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AppCheckInternetBuilder extends StatelessWidget {
  final Widget child;

  const AppCheckInternetBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        final isConnected = CheckInternet.isConnected(snapshot.data);
        return isConnected
            ? child
            : MaterialApp(
                theme: appTheme,
                debugShowCheckedModeBanner: false,
                builder: LocalizeAndTranslate.directionBuilder,
                home: const NoInternetScreen(),
                locale: context.locale,
                localizationsDelegates: context.delegates,
                supportedLocales: context.supportedLocales,
              );
      },
      stream: sl<Connectivity>().onConnectivityChanged,
    );
  }
}
