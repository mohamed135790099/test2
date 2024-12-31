import 'package:dr_mohamed_salah_admin/core/widgets/components/toggle_tabs.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/ended_reservation_list.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/waiting_reservation_list.dart';
import 'package:flutter/material.dart';

class ReservationToggle extends StatefulWidget {
  const ReservationToggle({super.key});

  @override
  State<ReservationToggle> createState() => _ReservationToggleState();
}

class _ReservationToggleState extends State<ReservationToggle> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleTabs(
          isHome: true,
          tabs: const ["في الانتظار", "المنتهية"],
          currentIndex: _currentIndex,
          onIndexChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        const [WaitingReservationList(), EndedReservationList()][_currentIndex]
      ],
    );
  }
}
