import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeline extends StatefulWidget {
  const DateTimeline({super.key});

  @override
  State<DateTimeline> createState() => _DateTimelineState();
}

class _DateTimelineState extends State<DateTimeline> {
  @override
  void initState() {
    super.initState();
    final currentDate = DateTime.now();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd', 'en');
    String formattedDate = dateFormat.format(currentDate);

    // Trigger the data fetching for the initial date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReservationCubit.get(context).setDateReservation(currentDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      locale: "en",
      initialDate: DateTime.now(),
      onDateChange: (date) {
        DateFormat dateFormat = DateFormat('yyyy-MM-dd', 'en');
        String formattedDate = dateFormat.format(date);
        ReservationCubit.get(context).setDateReservation(date);
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
