// patients_screen.dart

import 'dart:async';

import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/total_patient_appbar.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/widgets/patients_list.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _handleRefresh() async {
    await context.read<ReservationCubit>().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        return LiquidPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: AppColor.primaryBlue,
          child: Stack(
            children: [
              Scaffold(
                appBar: const TotalPatientsAppbar(),
                body: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    10.hs,
                    Row(
                      children: [
                        Container(
                            width: 10.w,
                            height: 7.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColor.primaryBlue)),
                        4.ws,
                        Text(
                          AppStrings.patients,
                          style: AppTextStyle.font16black700,
                        ),
                        const Spacer(),
                        // block Button to be implemented later
                        // InkWell(
                        //   onTap: () {
                        //     // click it make the list of the patients available to select patient to be blocked
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsetsDirectional.symmetric(
                        //         vertical: 12.h, horizontal: 25.h),
                        //     decoration: BoxDecoration(
                        //         color: Colors.redAccent,
                        //         borderRadius: BorderRadius.circular(20)),
                        //     child: const Text(
                        //       "قائمة المرضي المحظورين",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.w700),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    14.hs,
                    const PatientsList(),
                  ],
                ),
              ),
              state is ReservationLoading || state is GetAllUserLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: AppColor.primaryBlue,
                    ))
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}
