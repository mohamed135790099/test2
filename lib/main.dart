import 'package:dr_mohamed_salah_admin/blocobserve.dart';

import 'package:dr_mohamed_salah_admin/config/localiztion/localization.dart';
import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_status_bar.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_theme.dart';
import 'package:dr_mohamed_salah_admin/core/data/local/cache_helper.dart';
import 'package:dr_mohamed_salah_admin/core/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/core/screens/splash_screen.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_check_internet.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/repositories/sign_in_repo.dart';
import 'package:dr_mohamed_salah_admin/features/auth/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/repositories/more_repo.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/book_times_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/manager/doctor_additions_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/repositories/electronic_prescription_repo.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/repositories/reservations_repo.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/elec_prescription_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:oktoast/oktoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("6f98b857-4490-47c6-b300-69f4b6fd470f");

  OneSignal.Notifications.requestPermission(true);
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.Notifications.requestPermission(true);
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await CacheHelper.init();
  await AppLocalization.init();
  ServiceLocator.init();
  AppStatusBar.setStatusBarStyle();

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, child) => OKToast(
        child: LocalizedApp(
          child: AppCheckInternetBuilder(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => AuthCubit(sl<SignInRepo>())),
                BlocProvider(create: (_) => AppCubit()),
                BlocProvider(
                    create: (_) => ReservationCubit(sl<ReservationsRepo>())..getAllUsers()),
                BlocProvider(create: (_) => MoreCubit(sl<MoreRepo>())),
                BlocProvider(create: (_) => BookingTimesCubit()),
                BlocProvider(
                    create: (_) => ElectronicPrescriptionCubit(
                        sl<ElectronicPrescriptionRepo>())),
                BlocProvider<PatientDetailsCubit>(
                  create: (_) => PatientDetailsCubit(sl<ReservationsRepo>()),
                ),
                BlocProvider(
                    create: (_) => DoctorAdditionsCubit(sl<MoreRepo>())),
              ],
              child: MaterialApp(
                title: 'Clinic App',
                debugShowCheckedModeBanner: false,
                theme: appTheme,
                themeMode: ThemeMode.light,
                color: AppColor.white,
                home: const SplashScreen(),
                navigatorKey: RouterApp.navigatorKey,
                onGenerateRoute: RouterApp.generateRoute,
                builder: LocalizeAndTranslate.directionBuilder,
                locale: context.locale,
                localizationsDelegates: context.delegates,
                supportedLocales: context.supportedLocales,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
