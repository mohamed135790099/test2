import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/widgets/patient_details_widgets/patient_details_card.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/latest_reservation_widgets/latest_reservation_list.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../config/style/app_color.dart';
import '../../../../../utils/helpers/world_time_services.dart';
import '../../../../reservations/data/models/get_user_details.dart';
import '../../../../reservations/presentation/manager/cubit.dart';
import '../../../../reservations/presentation/manager/state.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({super.key});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  final WorldTimeService _worldTimeService = WorldTimeService();
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    getCurrentDay();
  }

  Future<void> getCurrentDay() async {
    DateTime dateTime = await _worldTimeService.getCurrentDateTime();
    setState(() {
      formattedDate = DateFormat('yyyy-MM-dd').format(dateTime); // Set and trigger rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final UserModel? userModel = ReservationCubit.get(context).getUserDetail;

        return SizedBox(
          height: 1000.h,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            children: [
              PatientDetailsCard(
                userModel: userModel,
              ),
              12.hs,
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
                    AppStrings.latestReservations,
                    style: AppTextStyle.font16black700,
                  )
                ],
              ),
              formattedDate == null
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: AppColor.primaryBlue,
                    ))
                  : LatestReservationList(
                      reservationModel: userModel,
                      id: userModel?.sId ?? "",
                      date: formattedDate!,
                    ),
            ],
          ),
        );
      },
    );
  }
}
