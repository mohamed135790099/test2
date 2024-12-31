import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_2.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/create_reservations_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/reservation_details_card_item.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoneReservation extends StatelessWidget {
  const DoneReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final CreateReservationsResponse? createReservationsResponse =
            ReservationCubit.get(context).createReservationsResponse;
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: AppColor.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppImageView(
                  svgPath: Assets.svgDone,
                  height: 40.h,
                  width: 40.w,
                  fit: BoxFit.scaleDown,
                ),
                16.hs,
                Text(
                  AppStrings.doneReservation,
                  style: AppTextStyle.font18black700,
                ),
                16.hs,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReservationDetailsCardItem(
                      title: AppStrings.reservationStatus,
                      widget: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4)),
                              color: AppColor.white2,
                              border: Border(
                                  right:
                                      BorderSide(color: AppColor.primaryBlue))),
                          child: Text.rich(
                            TextSpan(
                                text:
                                    "${createReservationsResponse?.price ?? ""}",
                                style: AppTextStyle.font8primaryBlue700,
                                children: [
                                  TextSpan(
                                      text:
                                          "${AppStrings.egp} تم الدفع في العيادة",
                                      style: AppTextStyle.font8black400),
                                ]),
                          )),
                    ),
                    8.hs,
                    ReservationDetailsCardItem(
                      title: AppStrings.reservationDate,
                      text: createReservationsResponse?.date ?? "",
                    ),
                    8.hs,
                    ReservationDetailsCardItem(
                      title: AppStrings.reservationTime,
                      text: createReservationsResponse?.time ?? "",
                    ),
                  ],
                ).withHorizontalPadding(16),
                28.hs,
                AppButton2(
                  title: AppStrings.returnToReservation,
                  onPressed: () {
                    RouterApp.pushNamedAndRemoveUntil(RouteName.mainScreen);
                  },
                )
              ],
            ).withVerticalPadding(20),
          ),
        );
      },
    );
  }
}
