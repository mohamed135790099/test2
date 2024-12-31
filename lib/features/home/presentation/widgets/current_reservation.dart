import '/config/style/app_color.dart';
import '/config/style/text_styles.dart';
import '/features/home/presentation/widgets/reservation_card.dart';
import '/features/reservations/data/models/get_all_reservations.dart';
import '/features/reservations/presentation/manager/cubit.dart';
import '/features/reservations/presentation/manager/state.dart';
import '/utils/app_utils/app_strings.dart';
import '/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CurrentReservation extends StatelessWidget {
  const CurrentReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final List<GetAllReservations> allReservations =
            ReservationCubit.get(context).allReservations;

        DateTime now = DateTime.now();
        List<GetAllReservations> filteredByStatus =
        allReservations.where((reservation) {
          try {
            DateTime reservationDateTime = DateFormat('yyyy-MM-dd HH:mm')
                .parse('${reservation.date} ${reservation.time}');
            return reservationDateTime.year == now.year &&
                reservationDateTime.month == now.month &&
                reservationDateTime.day == now.day &&
                reservationDateTime.hour == now.hour &&
                reservation.status == "pending";
          } catch (e) {
            print("Error parsing reservation time: ${reservation.time} - $e");
            return false;
          }
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  AppStrings.currentReservation,
                  style: AppTextStyle.font16black700,
                )
              ],
            ),
            filteredByStatus.isEmpty
                ? Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Center(
                child: Text(
                  "لا توجد كشوفات حالية",
                  style: AppTextStyle.font14black500,
                ),
              ),
            )
                : ReservationCard(
              index: 0,
              sortedList: filteredByStatus,
            )
          ],
        );
      },
    );
  }
}
