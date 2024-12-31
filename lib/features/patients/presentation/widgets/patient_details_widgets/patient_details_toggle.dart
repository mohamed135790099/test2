import 'package:dr_mohamed_salah_admin/core/widgets/components/toggle_tabs.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/widgets/patient_details_widgets/patient_details.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientDetailsToggle extends StatefulWidget {
  String id;

  PatientDetailsToggle({super.key, required this.id});

  @override
  State<PatientDetailsToggle> createState() => _PatientDetailsToggleState();
}

class _PatientDetailsToggleState extends State<PatientDetailsToggle> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 650.h,
          child: ListView(
            children: [
              ToggleTabs(
                tabs: const ["نبذة والحجوزات", "التاريخ المرضي"],
                currentIndex: _currentIndex,
                onIndexChange: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              [
                const PatientDetails(),
                PatientHistory(id: widget.id)
              ][_currentIndex],
            ],
          ),
        ),
        // block Button to be implemented later
        // InkWell(
        //   onTap: () {
        //     // click it make the list of the patients available to select patient to be blocked
        //   },
        //   child: Container(
        //     margin: EdgeInsetsDirectional.symmetric(horizontal: 90.h),
        //     padding: EdgeInsetsDirectional.symmetric(
        //         vertical: 12.h, horizontal: 45.h),
        //     decoration: BoxDecoration(
        //         color: Colors.redAccent,
        //         borderRadius: BorderRadius.circular(12)),
        //     child: const Center(
        //       child: Text(
        //         "حظر هذا المريض",
        //         style:
        //             TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
