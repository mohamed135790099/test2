import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../reservations/presentation/pages/reservation_details_screen.dart';
import '../../../data/model/new_reservation_model.dart';
import '/config/style/app_color.dart';
import '/config/style/app_shadows.dart';
import '/config/style/text_styles.dart';
import '/core/widgets/components/app_image_view.dart';
import '/features/reservations/presentation/manager/cubit.dart';
import '/generated/assets.dart';
import '/utils/app_utils/app_strings.dart';
import '/utils/extentions/extention.dart';

class NewReservationCard extends StatelessWidget {
  final int index;
  final List<Reservations> sortedList;

  const NewReservationCard({super.key, required this.index, required this.sortedList});

  @override
  Widget build(BuildContext context) {
    final reservation = sortedList[index];
    final isCanceled = reservation.status == "canceled";

    return InkWell(
      onTap: () async {
        final reservationCubit = ReservationCubit.get(context);
        final stableContext = context; // Capture a stable context

        try {
          await reservationCubit.getOneReservations(reservation.sId ?? "");
          await reservationCubit.getUserReservations(reservation.user?.sId ?? "");

          if (stableContext.mounted) {
            Navigator.push(
              stableContext,
              MaterialPageRoute(
                builder: (context) => ReservationDetailsScreen(
                  initialId: reservation.user?.sId,
                ),
              ),
            );
          }
        } catch (e) {
          debugPrint("Error occurred: $e");
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        height: 160.h,
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
                  "${AppStrings.reservationNumber} ${index + 1}",
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
                          text: "${reservation.price}",
                          style: AppTextStyle.font8primaryBlue700,
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
                  Expanded(
                    child: Text(
                        reservation.user?.fullName ?? "",
                        style: AppTextStyle.font12black700,
                      ),
                  ),
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
