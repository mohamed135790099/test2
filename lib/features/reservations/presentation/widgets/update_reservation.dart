import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/reservation_date_form.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateReservation extends StatefulWidget {
  final String id;

  const UpdateReservation({super.key, required this.id});

  @override
  State<UpdateReservation> createState() => _UpdateReservationState();
}

class _UpdateReservationState extends State<UpdateReservation> {
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  String? selectedTime;
  List<String> availableHours = [];
  bool isFetchingHours = false;
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final ReservationCubit reservationCubit = ReservationCubit.get(context);

        if (state is ReservationHoursLoading) {
          isFetchingHours = true;
        } else if (state is ReservationHoursLoaded) {
          isFetchingHours = false;
          availableHours = state.availableHours.toSet().toList();
          if (availableHours.isEmpty) {
            ErrorAppToaster.show("لا توجد أوقات متاحة لهذا اليوم");
          }
        } else if (state is ReservationHoursError) {
          isFetchingHours = false;
          availableHours = [];
        }

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom),
              child: Form(
                onChanged: () {
                  isValid = _formKey.currentState?.validate() ?? false;
                  setState(() {});
                },
                key: _formKey,
                child: Container(
                  height: 380.h,
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
                            child: Container(
                              margin: const EdgeInsetsDirectional.all(10),
                              child: Text(
                                'تعديل حجز',
                                style: AppTextStyle.font18black700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ReservationDateForm(dateController),
                                16.hs,
                                Text(
                                  'الاوقات المتاحة:',
                                  style: AppTextStyle.font14black500,
                                ),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedTime,
                                  items: availableHours.isEmpty
                                      ? [
                                    const DropdownMenuItem<String>(
                                      value: null,
                                      child: Text('لا توجد أوقات متاحة'),
                                    )
                                  ]
                                      : (List<String>.from(availableHours)
                                    ..sort())
                                      .map((hour) {
                                    return DropdownMenuItem<String>(
                                      value: hour,
                                      child: Text(hour),
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
                          12.hs,
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: AppButton3(
                              title: isSubmitting
                                  ? 'جاري تعديل الحجز...'
                                  : 'تعديل حجز',
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

                                setState(() {
                                  isSubmitting = true;
                                });

                                try {
                                  await reservationCubit
                                      .updateReservations(
                                      widget.id,
                                      dateController.text,
                                      selectedTime!);

                                  Navigator.pop(context);
                                  await reservationCubit
                                      .getOneReservations(widget.id);

                                  RouterApp.pop();
                                } catch (error) {
                                  print(
                                      'Error updating reservation: $error');
                                  ErrorAppToaster.show(
                                      "خطأ في تعديل الحجز");
                                } finally {
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ).withVerticalPadding(10)
                    ],
                  ),
                ),
              ),
            ),
            if (isFetchingHours || isSubmitting)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryBlue,
                ),
              ),
          ],
        );
      },
    );
  }
}
