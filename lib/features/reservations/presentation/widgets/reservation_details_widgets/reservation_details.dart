import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/one_reservation.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/latest_reservation_widgets/latest_reservation_list.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/reservation_details_card.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationDetails extends StatelessWidget {
  const ReservationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final OneReservation? oneReservation = ReservationCubit.get(context).oneReservations;
        print("id:${oneReservation?.user?.sId ?? ""}");
        print("date:${oneReservation?.date ?? ""}");
        return SizedBox(
          height: 1000.h,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            children: [
              ReservationDetailsCard(

                oneReservation: oneReservation,
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
              LatestReservationList(
                reservation:oneReservation ,
                id: oneReservation?.user?.sId ?? "",
                date: oneReservation?.date ?? "",
              )
            ],
          ),
        );
      },
    );
  }
}
