import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_shadows.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_all_reservations.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/pages/reservation_details_screen.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationCard extends StatelessWidget {
  final int index;
  final List<GetAllReservations> sortedList;

  const ReservationCard(
      {super.key, required this.index, required this.sortedList});

  @override
  Widget build(BuildContext context) {
    final reservation = sortedList[index];
    final isCanceled = reservation.status == "canceled";

    return InkWell(
      onTap: () {
        ReservationCubit.get(context)
            .getOneReservations(reservation.id ?? "")
            .then((value) => ReservationCubit.get(context).getUserReservations(
                ReservationCubit.get(context).oneReservations?.user?.sId ?? ""))
            .then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationDetailsScreen(
                        initialId: reservation.user.id),
                  ),
                ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        height: 140.h,
        width: 335.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: AppShadows.shadow2,
            color: AppColor.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "${AppStrings.reservationNumber} ( ${index+1} )",
                  style: AppTextStyle.font12black700,
                ),
                40.ws,
                Text(
                  "${reservation.time} ",
                  style: AppTextStyle.font12black700,
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                    color: AppColor.white2,
                    border: Border(
                      right: BorderSide(
                        color: reservation.paid == "false"
                            ? AppColor.red
                            : AppColor.primaryBlue,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "${reservation.totalPrice}  ",
                          style: AppTextStyle.font13primaryBlue500,
                          children: [
                            TextSpan(
                              text: " ${AppStrings.egp} ",
                              style: AppTextStyle.font8black400,
                            ),
                            TextSpan(
                              text: reservation.paid == "true"
                                  ? "مدفوعة بالعيادة"
                                  : "غير مدفوعة",
                              style: AppTextStyle.font8black400,
                            ),
                          ],
                        ),
                      ),
                      if (isCanceled) ...[
                        const Divider(
                          color: AppColor.red,
                          thickness: 1,
                        ),
                        Center(
                          child: Text(
                            "حجز ملغي",
                            style: AppTextStyle.font8black400
                                .copyWith(color: AppColor.red),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                10.ws,
                AppImageView(
                  svgPath: Assets.svgArrow,
                  height: 12.h,
                  width: 12.w,
                  fit: BoxFit.scaleDown,
                )
              ],
            ),
            8.hs,
            const Divider(),
            8.hs,
            SizedBox(
              child: Row(
                children: [
                  Text(
                    AppStrings.patientName,
                    style: AppTextStyle.font12black400,
                  ),
                  8.ws,
                  SizedBox(
                    height: 20.h,
                    child: const VerticalDivider(
                      color: AppColor.grey4,
                      thickness: 1,
                    ),
                  ),
                  8.ws,
                  Text(
                    reservation.user?.fullName ?? "",
                    style: AppTextStyle.font12black700,
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0.w),
                    child: Text(
                      reservation.date ?? "",
                      style: AppTextStyle.font12black700,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
