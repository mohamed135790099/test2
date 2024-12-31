import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/world_time_services.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimelineReservationFiltering extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool) onFetchingHours; // New callback function

  const DateTimelineReservationFiltering(
    this.controller, {
    required this.onFetchingHours,
    super.key,
  });

  @override
  State<DateTimelineReservationFiltering> createState() =>
      _DateTimelineReservationFilteringState();
}

class _DateTimelineReservationFilteringState
    extends State<DateTimelineReservationFiltering> {
  DateTime? initialDate;

  final WorldTimeService _worldTimeService = WorldTimeService();

  @override
  void initState() {
    super.initState();
    _initializeDate();
  }

  Future<void> _initializeDate() async {
    DateTime currentDateTime = await _worldTimeService.getCurrentDateTime();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd', 'en');
    String formattedDate = dateFormat.format(currentDateTime);
    widget.controller.text = formattedDate;

    setState(() {
      initialDate = currentDateTime;
    });
    await ReservationCubit.get(context).fetchHours(formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return initialDate == null
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColor.primaryBlue,
            ),
          )
        : EasyDateTimeLine(
            locale: "en",
            initialDate: initialDate!,
            onDateChange: (date) async {
              widget.onFetchingHours(true);
              DateFormat dateFormat = DateFormat('yyyy-MM-dd', 'en');
              String formattedDate = dateFormat.format(date);

              widget.controller.text = formattedDate;

              await ReservationCubit.get(context).updateSelectedDate(date);
              await ReservationCubit.get(context).fetchHours(formattedDate);

              widget.onFetchingHours(false);
            },
            headerProps: const EasyHeaderProps(
              monthPickerType: MonthPickerType.switcher,
              dateFormatter: DateFormatter.fullDateDMY(),
            ),
            dayProps: EasyDayProps(
              dayStructure: DayStructure.dayStrDayNum,
              inactiveDayStyle: DayStyle(
                dayNumStyle: AppTextStyle.font18black700,
              ),
              activeDayStyle: DayStyle(
                dayNumStyle: AppTextStyle.font18white700,
                dayStrStyle: AppTextStyle.font18white700,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
          );
  }
}
