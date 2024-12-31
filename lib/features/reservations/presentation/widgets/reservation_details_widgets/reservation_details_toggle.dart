import 'package:dr_mohamed_salah_admin/core/widgets/components/toggle_tabs.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/one_reservation.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_history.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/reservation_details.dart';
import 'package:flutter/material.dart';

class ReservationDetailsToggle extends StatefulWidget {
  String id;

  ReservationDetailsToggle({super.key, required this.id});

  @override
  State<ReservationDetailsToggle> createState() =>
      _ReservationDetailsToggleState();
}

class _ReservationDetailsToggleState extends State<ReservationDetailsToggle> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final OneReservation? oneReservation =
        ReservationCubit.get(context).oneReservations;
    return ListView(
      children: [
        ToggleTabs(
          tabs: const ["تفاصيل الحجز", "التاريخ المرضي"],
          currentIndex: _currentIndex,
          onIndexChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        [
          const ReservationDetails(),
          PatientHistory(id: oneReservation?.user?.sId ?? "")
        ][_currentIndex]
      ],
    );
  }
}
