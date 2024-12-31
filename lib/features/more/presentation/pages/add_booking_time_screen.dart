import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_2.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/reservation_date_form.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/book_times_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/book_times_state.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/world_time_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddBookingTimeScreen extends StatefulWidget {
  final String? date;
  final String? dayName;
  final String? id;

  const AddBookingTimeScreen({
    super.key,
    this.date,
    this.dayName,
    this.id,
  });

  @override
  State<AddBookingTimeScreen> createState() => _AddBookingTimeScreenState();
}

class _AddBookingTimeScreenState extends State<AddBookingTimeScreen> {
  final TextEditingController dateController = TextEditingController();
  final List<String> selectedTimes = [];
  bool _isLoading = false;
  final WorldTimeService _worldTimeService = WorldTimeService();

  @override
  void initState() {
    super.initState();
    if (widget.date != null) {
      _initializeDate();
    }
  }

  Future<void> _initializeDate() async {
    if (widget.date != null) {
      dateController.text = widget.date!;
      _loadExistingTimes(widget.date!);
    } else {
      try {
        final currentDateTime = await _worldTimeService.getCurrentDateTime();
        dateController.text = DateFormat('yyyy-MM-dd').format(currentDateTime);
        _loadExistingTimes(dateController.text);
      } catch (e) {
        AppToaster.show("Failed to load current date");
      }
    }
  }

  Future<void> _loadExistingTimes(String date) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final bookingCubit = BlocProvider.of<BookingTimesCubit>(context);
      await bookingCubit.fetchBookingDays();

      final state = bookingCubit.state;
      if (state is BookingTimesLoaded) {
        final existingBookings = state.bookingDays;
        final bookingDay = existingBookings.firstWhere(
          (booking) => booking['date'] == date,
          orElse: () => null,
        );

        if (bookingDay != null) {
          setState(() {
            selectedTimes.addAll(List<String>.from(
                bookingDay['times'].map((time) => time['time'])));
          });
        }
      }
    } catch (e) {
      AppToaster.show("Error loading existing times: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitSchedule() async {
    if (dateController.text.isEmpty || selectedTimes.isEmpty) {
      AppToaster.show("من فضلك إختر التاريخ والاوقات المتاحة");
      return;
    }

    String date = dateController.text;

    date = date.replaceAllMapped(RegExp(r'[٠١٢٣٤٥٦٧٨٩]'), (match) {
      const arabicToWestern = {
        '٠': '0',
        '١': '1',
        '٢': '2',
        '٣': '3',
        '٤': '4',
        '٥': '5',
        '٦': '6',
        '٧': '7',
        '٨': '8',
        '٩': '9',
      };
      return arabicToWestern[match.group(0)]!;
    });

    DateTime parsedDate;
    try {
      parsedDate = DateFormat('yyyy-MM-dd').parse(date);
    } catch (e) {
      ErrorAppToaster.show("Invalid date format");
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    String dayName = DateFormat('EEEE').format(parsedDate);

    setState(() {
      _isLoading = true;
    });
    try {
      final bookingCubit = BlocProvider.of<BookingTimesCubit>(context);
      await bookingCubit.fetchBookingDays();

      final state = bookingCubit.state;
      if (state is BookingTimesLoaded) {
        final existingBookings = state.bookingDays;

        final existingBookingDay = existingBookings.firstWhere(
          (booking) => booking['date'] == formattedDate,
          orElse: () => null,
        );

        List<Map<String, String>> timesInFuture = [];
        for (String time in selectedTimes) {
          try {
            DateTime currentDateTime =
                await _worldTimeService.getCurrentDateTime();

            DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm')
                .parse('$formattedDate ${_convertTimeTo24Hour(time)}');
            if (dateTime.isAfter(currentDateTime)) {
              timesInFuture.add({"time": time});
            }
          } catch (e) {
            ErrorAppToaster.show("Invalid time format");
            return;
          }
        }

        if (timesInFuture.isEmpty) {
          ErrorAppToaster.show("من فضلك إختر ساعه قادمة");
          return;
        }

        try {
          Map<String, dynamic> bookingData = {
            "date": formattedDate,
            "name": dayName,
            "times": timesInFuture,
          };

          Map<String, dynamic> existingBookingData = {
            "times": timesInFuture,
          };
          if (existingBookingDay != null &&
              existingBookingDay.containsKey('_id')) {
            await bookingCubit.updateBooking(
                existingBookingDay['_id'], existingBookingData);
            AppToaster.show("تم التعديل بنجاح");
          } else {
            await bookingCubit.submitSchedule(bookingData);
            AppToaster.show("تم الإضافة بنجاح");
          }

          Navigator.pop(context, true);
        } catch (e) {
          ErrorAppToaster.show("Error updating booking: ${e.toString()}");
        }
      }
    } catch (e) {
      ErrorAppToaster.show("Error checking existing bookings: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _convertTimeTo24Hour(String time) {
    Map<String, String> arabicToWestern = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    String westernTime =
        time.replaceAllMapped(RegExp(r'[٠١٢٣٤٥٦٧٨٩]'), (match) {
      return arabicToWestern[match.group(0)]!;
    });

    if (westernTime.length == 4) {
      westernTime =
          "${westernTime.substring(0, 2)}:${westernTime.substring(2)}";
    }

    return westernTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const DefaultAppBar2(title: "إضافة يوم حجز"),
        body: BlocListener<BookingTimesCubit, BookingTimesState>(
          listener: (context, state) {
            if (state is BookingTimesSuccess) {
              Navigator.pop(context, true);
            } else if (state is BookingTimesError) {
              ErrorAppToaster.show(state.message);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20.w),
                  children: [
                    widget.date != null
                        ? Container(
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 12.h, horizontal: 20.w),
                            decoration: BoxDecoration(
                              color: AppColor.grey7,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              dateController.text,
                              style: AppTextStyle.font16black700,
                              textAlign: TextAlign.center,
                            ))
                        : ReservationDateForm(dateController),
                    20.hs,
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.green,
                          ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إختر ساعات الحجز المتاحة',
                                style: AppTextStyle.font16black400,
                              ),
                              SizedBox(height: 10.h),
                              Wrap(
                                spacing: 10.w,
                                runSpacing: 10.h,
                                children: List.generate(
                                  24,
                                  (index) {
                                    final time = DateFormat('HH:00')
                                        .format(DateTime(0, 0, 0, index));
                                    final isSelected =
                                        selectedTimes.contains(time);
                                    return FilterChip(
                                      label: Text(time),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            selectedTimes.add(time);
                                          } else {
                                            selectedTimes.remove(time);
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              AppButton3(
                title: 'حفظ',
                isValid: true,
                onPressed: _submitSchedule,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ));
  }
}
