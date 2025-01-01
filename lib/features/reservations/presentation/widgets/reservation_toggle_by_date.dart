import 'package:dr_mohamed_salah_admin/core/widgets/components/toggle_tabs.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/ended_reservation_list_by_date.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/waiting_reservation_list_by_date.dart';
import 'package:flutter/material.dart';

class ReservationToggleByDate extends StatefulWidget {
   const ReservationToggleByDate({super.key});

  @override
  State<ReservationToggleByDate> createState() =>
      _ReservationToggleByDateState();
}

class _ReservationToggleByDateState extends State<ReservationToggleByDate> {
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
        _currentIndex == 0
            ? const WaitingReservationListByDate()
            : const EndedReservationListByDate(),
      ],
    );
  }
}
