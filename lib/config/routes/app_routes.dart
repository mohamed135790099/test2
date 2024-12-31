import 'package:dr_mohamed_salah_admin/core/screens/main_screen.dart';
import 'package:dr_mohamed_salah_admin/features/auth/presentation/pages/login_screen.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/presentation/pages/emergency_chat_details_screen.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/all_reservations_screen.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/article_details_screen.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/articles_screen.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/booking_times_screen.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/pages/patients_details_screen.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/pages/reservation_details_screen.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/pages/upload_electric_prescription.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/analysis_widgets/analysis_details_screen.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/medicines_widgets/medicine_details_screen.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/prescriptions_widgets/electric_prescription_details.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/prescriptions_widgets/prescription_details_screen.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/xray_widgets/xray_details_screen.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:flutter/material.dart';

class RouterApp {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case RouteName.loginScreen:
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        case RouteName.uploadElectricPrescription:
          final patientId = settings.arguments as String;

          return MaterialPageRoute(
              builder: (_) => UploadElectricPrescription(
                    patientId: patientId,
                  ));
        case RouteName.reservationDetailsScreen:
          return MaterialPageRoute(
              builder: (_) =>  ReservationDetailsScreen());
        case RouteName.prescriptionDetailsScreen:
          final prescriptionId = settings.arguments as String;

          return MaterialPageRoute(
              builder: (_) =>
                  PrescriptionsDetailsScreen(prescriptionId: prescriptionId));
        case RouteName.electricPrescriptionDetails:
          final electronicPrescriptionId = settings.arguments as String;

          return MaterialPageRoute(
              builder: (_) => ElectricPrescriptionDetails(
                  electronicPrescriptionId: electronicPrescriptionId));
        case RouteName.xRayDetailsScreen:
          final xrayId = settings.arguments as String;

          return MaterialPageRoute(
              builder: (_) => XRayDetailsScreen(xrayId: xrayId));
        case RouteName.analysisDetailsScreen:
          final analysisId = settings.arguments as String;

          return MaterialPageRoute(
              builder: (_) => AnalysisDetailsScreen(analysisId: analysisId));
        case RouteName.medicinesDetailsScreen:
          final medicineId = settings.arguments as String;

          return MaterialPageRoute(
              builder: (_) => MedicineDetailsScreen(medicineId: medicineId));
        case RouteName.patientDetailsScreen:
          return MaterialPageRoute(builder: (_) => PatientsDetailsScreen());
        case RouteName.emergencyChatDetailsScreen:
          return MaterialPageRoute(
            builder: (_) => const EmergencyChatDetailsScreen(),
          );
        case RouteName.articleScreen:
          return MaterialPageRoute(builder: (_) => const ArticlesScreen());
        case RouteName.articleDetailsScreen:
          final articleId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ArticleDetailsScreen(articleId: articleId),
          );

        case RouteName.allReservationsScreen:
          return MaterialPageRoute(
              builder: (_) => const AllReservationsScreen());
        case RouteName.bookingTimesScreen:
          return MaterialPageRoute(builder: (_) => const BookingTimesScreen());
        case RouteName.addBookingTimesScreen:
          return MaterialPageRoute(builder: (_) => const BookingTimesScreen());
        case RouteName.mainScreen:
          return MaterialPageRoute(builder: (_) =>  MainScreen());
        default:
          return MaterialPageRoute(builder: (_) => const LoginScreen());
      }
    } catch (e) {
      return _errorRoute();
    }
  }

  static Future pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
  }) async {
    return await navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }

  static Future pushNamed(
    String routeName, {
    Object? arguments,
  }) async {
    return await navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  static pop<T>([T? result]) {
    return navigatorKey.currentState?.pop(result);
  }

  static bool get canPop => navigatorKey.currentState?.canPop() ?? false;

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('خطأ'),
        ),
        body: const Center(
          child: Text('نعتذر حدث خطأ , الرجاء اعادة المحاولة'),
        ),
      );
    });
  }

  static _animateRouteBuilder(Widget to, {double x = 1, double y = 0}) =>
      PageRouteBuilder(
          pageBuilder: (_, __, ___) => to,
          opaque: false,
          transitionDuration: const Duration(milliseconds: 150),
          reverseTransitionDuration: const Duration(milliseconds: 150),
          transitionsBuilder: (context, animation, animationTime, child) {
            final tween = Tween<Offset>(
              begin: Offset(x, y),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.ease));
            final tween2 = Tween<double>(
              begin: 0,
              end: 1,
            );
            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation.drive(tween2),
                child: child,
              ),
            );
          });
}
