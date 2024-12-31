import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/reservation_card.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_all_reservations.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EndedReservationListByDate extends StatelessWidget {
  const EndedReservationListByDate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final reservationCubit = ReservationCubit.get(context);
        final List<GetAllReservations> allReservations =
            reservationCubit.allReservations;
        final DateTime selectedDate =
            reservationCubit.reservationSelectedDate ?? DateTime.now();

        List<GetAllReservations> filteredByDate =
            allReservations.where((reservation) {
          String normalizedDate = normalizeArabicNumbers(reservation.date!);
          DateTime reservationDate;
          try {
            reservationDate = DateFormat('yyyy-MM-dd').parse(normalizedDate);
          } catch (e) {
            return false;
          }
          return reservationDate.year == selectedDate.year &&
              reservationDate.month == selectedDate.month &&
              reservationDate.day == selectedDate.day;
        }).toList();

        List<GetAllReservations> filteredByStatus = filteredByDate
            .where((reservation) =>
                reservation.status == "confirmed" ||
                reservation.status == "canceled")
            .toList();

        filteredByStatus.sort((a, b) => a.date!.compareTo(b.date!));

        return filteredByStatus.isEmpty
            ? Column(
                children: [
                  SizedBox(height: 150.h),
                  const Center(child: Text('لا توجد حجوزات منتهيه')),
                ],
              )
            : SizedBox(
                height: 500.h,
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 60.h),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ReservationCard(
                      index: index, sortedList: filteredByStatus),
                  separatorBuilder: (context, index) => 12.hs,
                  itemCount: filteredByStatus.length,
                ),
              );
      },
    );
  }
}


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
