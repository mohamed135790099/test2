import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_1.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/pages/all_filtered_reservations.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalBookingsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const TotalBookingsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: AppColor.white,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      surfaceTintColor: AppColor.white,
      backgroundColor: AppColor.white,
      titleSpacing: 0,
      leadingWidth: 0,
      leading: const SizedBox(),
      toolbarHeight: 70.h,
      title: BlocBuilder<ReservationCubit, ReservationState>(
        builder: (context, state) {
          if (state is GetAllReservationsLoading) {
            const Center(
                child: CircularProgressIndicator(color: AppColor.primaryBlue));
          }
          final int reservationCount =
              ReservationCubit.get(context).allReservations.length;

          return Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppImageView(
                        svgPath: Assets.svgBook,
                        height: 20.h,
                        width: 20.w,
                      ),
                      8.ws,
                      Text(
                        AppStrings.totalBooking,
                        style: AppTextStyle.font14black400,
                      ),
                    ],
                  ),
                  Text(
                    "$reservationCount",
                    style: AppTextStyle.font20black900,
                  ),
                ],
              ),
              const Spacer(),
              AppButton1(
                width: 165.w,
                leading: AppImageView(
                  svgPath: Assets.svgBook,
                  height: 16.h,
                  width: 24.w,
                  fit: BoxFit.scaleDown,
                ),
                title: AppStrings.viewAllReservations,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllFilteredReservation(),
                    ),
                  );
                },
              ),
            ],
          ).withHorizontalPadding(20);
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 70.h);
}
