import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/toggle_custom_tabs.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/analysis_widgets/analysis_list.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/patient_history_details.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/prescriptions_widgets/prescriptions_list.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/xray_widgets/xray_list.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientHistory extends StatefulWidget {
  String id;

  PatientHistory({super.key, required this.id});

  @override
  State<PatientHistory> createState() => _PatientHistoryState();
}

class _PatientHistoryState extends State<PatientHistory> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColor.primaryBlue,
        backgroundColor: AppColor.white,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          children: [
            ToggleCustomTabs(
              tabs: [
                AppStrings.prescriptions,
                AppStrings.xRays,
                AppStrings.analysis,
                AppStrings.patientInfo
              ],
              currentIndex: _currentIndex,
              onIndexChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            [
              PrescriptionsList(patientId: widget.id),
              XRayList(patientId: widget.id),
              AnalysisList(patientId: widget.id),
              PatientHistoryDetails(patientId: widget.id),
            ][_currentIndex]
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    final ReservationCubit cubit = ReservationCubit.get(context);
    final PatientDetailsCubit cubit0 = PatientDetailsCubit.get(context);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      cubit.getUserReservations(widget.id);
      cubit0.getPatientData(widget.id);
    });
  }
}
