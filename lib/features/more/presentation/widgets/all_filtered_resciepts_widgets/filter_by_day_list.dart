import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/reservation_card.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/all_filtered_resciepts_widgets/total_receipts_container.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/bill_calendar.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_all_reservations.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class FilterReceiptsBySpecificDurationList extends StatefulWidget {
  const FilterReceiptsBySpecificDurationList({super.key});

  @override
  _FilterReceiptsBySpecificDurationListState createState() =>
      _FilterReceiptsBySpecificDurationListState();
}

class _FilterReceiptsBySpecificDurationListState
    extends State<FilterReceiptsBySpecificDurationList> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  DateTime _parseDate(String date) {
    const arabicNumerals = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9'
    };

    String westernDate = date;
    arabicNumerals.forEach((arabic, western) {
      westernDate = westernDate.replaceAll(arabic, western);
    });

    try {
      return DateFormat('yyyy-MM-dd').parse(westernDate);
    } catch (e) {
      return DateFormat('dd/MM/yyyy').parse(westernDate);
    }
  }

  void onDateSelected() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final reservationCubit = ReservationCubit.get(context);
        final List<GetAllReservations> allReservations =
            reservationCubit.allReservations;

        final String startDateStr = startDateController.text;
        final String endDateStr = endDateController.text;

        final DateTime? startDate =
            startDateStr.isNotEmpty ? _parseDate(startDateStr) : null;
        final DateTime? endDate =
            endDateStr.isNotEmpty ? _parseDate(endDateStr) : null;

        final DateTime? endDatePlusOne = endDate?.add(const Duration(days: 1));

        List<GetAllReservations> filteredByDateAndStatus =
            allReservations.where((reservation) {
          if (reservation.status != "confirmed") {
            return false;
          }

          final DateTime reservationDate = _parseDate(reservation.date!);

          if (startDate != null && endDatePlusOne != null) {
            return reservationDate.isSameDate(startDate) ||
                (reservationDate.isAfter(startDate) &&
                    reservationDate.isBefore(endDatePlusOne));
          } else if (startDate != null) {
            return reservationDate.isAfter(startDate);
          } else if (endDatePlusOne != null) {
            return reservationDate.isSameDate(endDatePlusOne);
          } else {
            return true;
          }
        }).toList();

        num totalPriceSum() {
          return filteredByDateAndStatus.fold<num>(
              0.0, (sum, item) => sum + (item.price ?? 0));
        }

        filteredByDateAndStatus
            .sort((a, b) => _parseDate(a.date!).compareTo(_parseDate(b.date!)));

        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Stack(
            children: [
              Column(
                children: [
                  BillCalendarDateForm(
                    startDateController,
                    addressText: "من الفترة",
                    onDateSelected: onDateSelected,
                  ),
                  16.hs,
                  BillCalendarDateForm(
                    endDateController,
                    addressText: "إلي الفترة",
                    onDateSelected: onDateSelected,
                  ),
                  22.hs,
                  TotalReceiptsContainer(total: "${totalPriceSum()}"),
                  14.hs,
                  filteredByDateAndStatus.isEmpty
                      ? const SizedBox()
                      : SizedBox(
                          height: 350.h,
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 60.h),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => ReservationCard(
                              index: index,
                              sortedList: filteredByDateAndStatus,
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemCount: filteredByDateAndStatus.length,
                          ),
                        ),
                ],
              ),
              if (state is GetUserReservationsLoading ||
                  state is GetOneReservationsLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryBlue,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
