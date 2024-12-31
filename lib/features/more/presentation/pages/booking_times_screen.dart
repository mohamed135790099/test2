import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_2.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/book_times_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/book_times_state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/add_booking_time_screen.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BookingTimesScreen extends StatefulWidget {
  const BookingTimesScreen({super.key});

  @override
  State<BookingTimesScreen> createState() => _BookingTimesScreenState();
}

class _BookingTimesScreenState extends State<BookingTimesScreen> {
  @override
  void initState() {
    super.initState();
    _fetchBookingDays();
  }

  void _fetchBookingDays() {
    BlocProvider.of<BookingTimesCubit>(context).fetchBookingDays();
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      BlocProvider.of<BookingTimesCubit>(context).fetchBookingDays();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar2(
        title: "أيام إستقبال الحجوزات",
      ),
      body: BlocConsumer<BookingTimesCubit, BookingTimesState>(
        listener: (context, state) {
          if (state is BookingTimesError) {
            ErrorAppToaster.show(state.message);
          }
        },
        builder: (context, state) {
          if (state is BookingTimesLoading || state is HideScheduleLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryBlue,
              ),
            );
          } else if (state is BookingTimesLoaded) {
            final bookingDays = state.bookingDays;
            if (bookingDays.isEmpty) {
              const Center(child: Text("لا توجد أيام متاحة"));
            }
            return RefreshIndicator(
              onRefresh: _refreshData,
              color: AppColor.primaryBlue,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: AppButton3(
                      title: 'إضافة يوم',
                      isValid: true,
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddBookingTimeScreen(),
                          ),
                        );
                        if (result == true) {
                          _fetchBookingDays();
                        }
                      },
                    ),
                  ),
                  20.ws,
                  Text(
                    "الايام المتاحة للحجز",
                    style: AppTextStyle.font18black700,
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    height: 500.h,
                    child: ListView.builder(
                      itemCount: bookingDays.length,
                      itemBuilder: (context, index) {
                        // Sort the booking days by date in ascending order
                        bookingDays.sort((a, b) {
                          final dateA =
                              DateFormat('yyyy-MM-dd').parse(a['date']);
                          final dateB =
                              DateFormat('yyyy-MM-dd').parse(b['date']);
                          final dayA =
                              int.parse(DateFormat('dd').format(dateA));
                          final dayB =
                              int.parse(DateFormat('dd').format(dateB));
                          return dayA.compareTo(dayB);
                        });

                        final bookingDay = bookingDays[index];
                        final date =
                            DateFormat('yyyy-MM-dd').parse(bookingDay['date']);
                        final formattedDate =
                            DateFormat('dd MMMM yyyy', 'en').format(date);

                        return InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddBookingTimeScreen(
                                  date: bookingDay['date'],
                                  dayName: bookingDay['name'],
                                  id: bookingDay['id'],
                                ),
                              ),
                            );
                            if (result == true) {
                              _fetchBookingDays();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.grey6,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${bookingDay['name']} $formattedDate",
                                  style: AppTextStyle.font16black400,
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios_sharp),
                                IconButton(
                                  icon: Icon(bookingDay['isShown']
                                      ? Icons.visibility
                                      : Icons.hide_source),
                                  onPressed: () async {
                                    await context
                                        .read<BookingTimesCubit>()
                                        .hideSchedule(bookingDay['_id']);

                                    if (bookingDay['isShown']) {
                                      AppToaster.show(
                                          "تم إخفاء هذا اليوم من الحجوزات");
                                    } else {
                                      AppToaster.show(
                                          "تم إظهار هذا اليوم من الحجوزات");
                                    }

                                    setState(() {
                                      bookingDay['isShown'] =
                                          !bookingDay['isShown'];
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is BookingTimesError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
