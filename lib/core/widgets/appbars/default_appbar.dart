
import '../../../features/home/data/model/new_reservation_model.dart';
import '/config/routes/app_routes.dart';
import '/config/style/app_color.dart';
import '/config/style/text_styles.dart';
import '/core/widgets/buttons/button_2.dart';
import '/core/widgets/components/app_image_view.dart';
import '/features/reservations/data/models/get_all_reservations.dart';
import '/features/reservations/presentation/manager/cubit.dart';
import '/features/reservations/presentation/manager/state.dart';
import '/generated/assets.dart';
import '/utils/app_utils/app_strings.dart';
import '/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final ReservationCubit reservationCubit = ReservationCubit.get(context);
        final List<Reservations> allReservations = reservationCubit.allTodayReservations;
        return AppBar(
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: AppColor.white)),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          surfaceTintColor: AppColor.white,
          backgroundColor: AppColor.white,
          titleSpacing: 0,
          leadingWidth: 0,
          leading: const SizedBox(),
          toolbarHeight: 100.h,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppImageView(
                        svgPath: Assets.svgTicket,
                        height: 20.h,
                        width: 20.w,
                      ),
                      8.ws,
                      Text(
                        AppStrings.totalBookingOfDay,
                        style: AppTextStyle.font14black400,
                      ),
                    ],
                  ),
                  Text(
                    "${allReservations.length}",
                    style: AppTextStyle.font20black900,
                  )
                ],
              ),
            ],
          ).withHorizontalPadding(20),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 100.h);
}

// Utility function to normalize Arabic numerals to Western Arabic numerals
String normalizeArabicNumbers(String input) {
  const easternArabicNumerals = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩'
  ];
  for (int i = 0; i < easternArabicNumerals.length; i++) {
    input = input.replaceAll(easternArabicNumerals[i], i.toString());
  }
  return input.replaceAll(RegExp(r'\s+'), ''); // Remove any extra spaces
}
