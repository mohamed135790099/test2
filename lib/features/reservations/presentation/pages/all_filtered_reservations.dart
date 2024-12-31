import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_2.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/reservation_card.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_all_reservations.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/date_timeline_widget.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/all_filtered_reservations_widgets/total_reservations_container.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AllFilteredReservation extends StatefulWidget {
  const AllFilteredReservation({super.key});

  @override
  State<AllFilteredReservation> createState() => _AllFilteredReservationState();
}

class _AllFilteredReservationState extends State<AllFilteredReservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar2(
          title: AppStrings.viewAllReservations,
        ),
        body: BlocBuilder<ReservationCubit, ReservationState>(
          builder: (context, state) {
            final ReservationCubit reservationCubit =
                ReservationCubit.get(context);
            final List<GetAllReservations> allReservations =
                reservationCubit.allReservations;
            final DateTime selectedDate =
                reservationCubit.reservationSelectedDate ?? DateTime.now();

            List<GetAllReservations> filteredByDate =
                allReservations.where((reservation) {
              String normalizedDate = normalizeArabicNumbers(reservation.date!);
              DateTime reservationDate;
              try {
                reservationDate =
                    DateFormat('yyyy-MM-dd').parse(normalizedDate);
              } catch (e) {
                return false; // Skip dates that can't be parsed
              }
              return reservationDate.year == selectedDate.year &&
                  reservationDate.month == selectedDate.month &&
                  reservationDate.day == selectedDate.day;
            }).toList();

            // Sort the filtered list
            filteredByDate.sort((a, b) => a.date!.compareTo(b.date!));

            return Stack(children: [
              Scaffold(
                body: Column(
                  children: [
                    const DateTimeline(),
                    12.hs,
                    TotalReservationsContainer(
                        total: "${filteredByDate.length}"),
                    12.hs,
                    filteredByDate.isEmpty
                        ? const SizedBox()
                        : SizedBox(
                            height: 350.h,
                            child: ListView.separated(
                              padding: EdgeInsets.only(bottom: 60.h),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => ReservationCard(
                                index: index,
                                sortedList: filteredByDate,
                              ),
                              separatorBuilder: (context, index) => 12.hs,
                              itemCount: filteredByDate.length,
                            ),
                          ),
                  ],
                ),
              ),
              if (state is GetReservationsByDateLoading ||
                  state is GetUserReservationsLoading ||
                  state is GetOneReservationsLoading)
                const Center(
                    child: CircularProgressIndicator(
                  color: AppColor.primaryBlue,
                ))
            ]);
          },
        ));
  }
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
