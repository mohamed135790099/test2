import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_2.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_analysis.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/analysis_widgets/add_new_analysis.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/analysis_widgets/analysis_card.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalysisList extends StatefulWidget {
  String patientId;

  AnalysisList({super.key, required this.patientId});

  @override
  State<AnalysisList> createState() => _AnalysisListState();
}

class _AnalysisListState extends State<AnalysisList> {
  @override
  void initState() {
    super.initState();
    context.read<ReservationCubit>().getUserReservations(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final List<GetUserAnalysis> userAnalysis =
            ReservationCubit.get(context).userAnalysis;

        return SizedBox(
            height: 530.h,
            child: Scaffold(
              bottomSheet: AppButton2(
                title: AppStrings.addAnalysis,
                onPressed: () {
                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (context) => const AddNewAnalysis());
                },
              ),
              body: ListView.separated(
                  padding: EdgeInsets.only(bottom: 50.h, top: 20.h),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => AnalysisCard(
                        userAnalysis: userAnalysis,
                        index: index,
                      ),
                  separatorBuilder: (context, index) => 12.hs,
                  itemCount: userAnalysis.length),
            ));
      },
    );
  }
}
