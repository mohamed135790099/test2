import '/config/style/app_gradiant.dart';
import '/core/manager/cubit.dart';
import '/core/manager/state.dart';
import '/core/widgets/components/bottom_navbar.dart';
import '/features/emergency/presentation/pages/emergency_screen.dart';
import '/features/home/presentation/pages/home_screen.dart';
import '/features/more/presentation/pages/more_screen.dart';
import '/features/patients/presentation/pages/patients_screen.dart';
import '/features/reservations/presentation/pages/reservations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  int? initialIndex=0;
  MainScreen({super.key,this.initialIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();

  static void navigateTo(BuildContext context, int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MainScreen(initialIndex: index),
      ),
          (Route<dynamic> route) => false,
    );
  }

}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex =0;
  @override
  void initState() {
    _currentIndex = widget.initialIndex??0;
    super.initState();
  }
  final List<Widget> _pages= const [
    HomeScreen(),
    ReservationsScreen(),
    PatientsScreen(),
    EmergencyScreen(),
    MoreScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => Container(
        decoration: const BoxDecoration(
          gradient: AppGradiant.gradiant2,
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          body:_pages[_currentIndex],
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
