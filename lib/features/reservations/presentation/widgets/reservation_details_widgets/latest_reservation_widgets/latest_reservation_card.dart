import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_shadows.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/last_reservation_model.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LatestReservationCard extends StatelessWidget {
  final List<Reservation>? lastReservations;
  final int index;

  const LatestReservationCard({super.key, required this.lastReservations, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        height: 60.h,
        width: 335.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: AppShadows.shadow2,
            color: AppColor.white),
        child: Row(
          children: [
            Text("${lastReservations?[index].date}",
              style: AppTextStyle.font12black700,
            ),
            const Spacer(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4)),
                    color: AppColor.white2,
                    border:
                        Border(right: BorderSide(color: AppColor.primaryBlue))),
                child: Text(lastReservations?[index].status == "confirmed" ? "تم الكشف عليه"
                      : lastReservations?[index].status == "canceled"
                          ? "ملغي"
                          : "لم يتم الكشف",
                  style: AppTextStyle.font8black400,
                )),
            18.ws,
            AppImageView(
              svgPath: Assets.svgArrow,
              height: 12.h,
              width: 12.w,
              fit: BoxFit.scaleDown,
            )
          ],
        ));
  }
}
