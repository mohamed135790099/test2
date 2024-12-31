import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/patients_widgets/add_new_patient.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/patients_widgets/data_timeline_reservation_widget.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/patients_widgets/done_reservation.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/patients_widgets/patient_dropdown_search.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/patients_widgets/reservation_type_dropdown.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/world_time_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewReservation extends StatefulWidget {
  const AddNewReservation({super.key});

  @override
  State<AddNewReservation> createState() => _AddNewReservationState();
}

class _AddNewReservationState extends State<AddNewReservation> {
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  String? selectedTime;
  bool isSubmitting = false;
  List<String> availableHours = [];
  bool isFetchingHours = false;
  final WorldTimeService _worldTimeService = WorldTimeService();
  String _convertTo12HourFormat(String hour24) {
    final time = DateTime.parse("1970-01-01 $hour24:00");
    return "${time.hour % 12 == 0 ? 12 : time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        if (state is ReservationHoursLoaded) {
          availableHours = state.availableHours.toSet().toList();
        } else if (state is ReservationHoursError) {
          availableHours = [];
        }
        final ReservationCubit reservationCubit = ReservationCubit.get(context);
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                onChanged: () {
                  isValid = _formKey.currentState?.validate() ?? false;
                  setState(() {});
                },
                key: _formKey,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: AppColor.white),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'إضافة حجز جديد',
                              style: AppTextStyle.font18black700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'إسم المريض',
                                      style: AppTextStyle.font14black500,
                                    ),
                                    const Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  const AddNewPatient());
                                        },
                                        child: Text(
                                          'إضافة مريض جديد',
                                          style:
                                              AppTextStyle.font14primaryBlue500,
                                        ))
                                  ],
                                ),
                                10.hs,
                                const PatientDropDownSearch(),
                                16.hs,
                                const ReservationTypeDropDown(),
                                16.hs,
                                DateTimelineReservationFiltering(
                                  dateController,
                                  onFetchingHours: (bool fetching) {
                                    setState(() {
                                      isFetchingHours = fetching;
                                      selectedTime = null;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'الاوقات المتاحة:',
                                  style: AppTextStyle.font14black500,
                                ),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  value: availableHours.contains(selectedTime)
                                      ? selectedTime
                                      : null,
                                  items: availableHours.isEmpty
                                      ? [
                                          const DropdownMenuItem<String>(
                                            value: null,
                                            child: Text('لا توجد أوقات متاحة'),
                                          )
                                        ]
                                      : (availableHours..sort()).map((hour) {
                                          final hourDisplay =
                                              _convertTo12HourFormat(hour);
                                          return DropdownMenuItem<String>(
                                            value: hour,
                                            child: Text(hourDisplay),
                                          );
                                        }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTime = value;
                                    });
                                  },
                                  hint: const Text('إختر الوقت المناسب'),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ).withHorizontalPadding(16),
                          ),
                          22.hs,
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: AppButton3(
                              title: isSubmitting
                                  ? 'جاري إضافة الحجز...'
                                  : 'إضافة حجز',
                              isValid:
                                  !isFetchingHours && isValid && !isSubmitting,
                              onPressed: isSubmitting
                                  ? null
                                  : () async {
                                      if (dateController.text.isEmpty ||
                                          selectedTime == null) {
                                        ErrorAppToaster.show(
                                            "من فضلك إختر اليوم والوقت المناسب");
                                        return;
                                      }
                                      if (reservationCubit.patientName ==
                                              null ||
                                          reservationCubit.typeName == null) {
                                        ErrorAppToaster.show(
                                            "من فضلك إختر إسم المريض ونوع الكشف");
                                        return;
                                      }

                                      String patientId = reservationCubit.patientId!;
                                      String selectedDate = dateController.text;
                                      String selectedTimeSlot = selectedTime!;
                                      String reservationType =
                                          reservationCubit.typeName!;
                                      String reservationFee =
                                          reservationCubit.price.toString();

                                      setState(() {
                                        isSubmitting = true;
                                      });

                                      try {
                                        final result = await reservationCubit
                                            .createReservations(
                                          patientId,
                                          selectedDate,
                                          selectedTimeSlot,
                                          reservationFee,
                                          reservationType,
                                        );

                                        if (result == true) {
                                          showModalBottomSheet(
                                            isDismissible: true,
                                            context: context,
                                            builder: (context) => const DoneReservation(),
                                          );

                                          reservationCubit.patientName.clear();
                                          reservationCubit.typeName == null;
                                        }
                                      } finally {
                                        setState(() {
                                          isSubmitting = false;
                                        });
                                      }
                                    },
                            ),
                          )
                        ],
                      ).withVerticalPadding(20),
                    ],
                  ),
                ),
              ),
            ),
            if (state is ReservationHoursLoading ||
                state is GetAllReservationsLoading ||
                state is CreateReservationLoading)
              const Center(
                  child: CircularProgressIndicator(
                color: AppColor.primaryBlue,
              )),
          ],
        );
      },
    );
  }
}
