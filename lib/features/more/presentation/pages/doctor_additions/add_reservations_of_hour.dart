import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/manager/doctor_additions_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/manager/doctor_additions_state.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddReservationsOfHour extends StatefulWidget {
  const AddReservationsOfHour({super.key});

  @override
  State<AddReservationsOfHour> createState() => _AddReservationsOfHourState();
}

class _AddReservationsOfHourState extends State<AddReservationsOfHour> {
  final TextEditingController _hourNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorAdditionsCubit, DoctorAdditionsState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            Padding(
              padding: EdgeInsetsDirectional.all(12.h),
              child: ListView(
                children: [
                  50.hs,
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 22),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlueTransparent2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        "إضافة عدد الحجوزات المتاحة بالساعة بالنسبة للطبيب",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  90.hs,
                  AppTextField(
                    labelText: "عدد الحجوزات بالساعة",
                    isMultiLine: false,
                    controller: _hourNumber,
                    keyboardType: TextInputType.number,
                  ),
                  50.hs,
                  AppButton3(
                    isValid: true,
                    title: "إضافة عدد  الساعات",
                    onPressed: () async {
                      int num = int.parse(_hourNumber.text);
                      await context
                          .read<DoctorAdditionsCubit>()
                          .addHoursOfReservation(num);
                    },
                  )
                ],
              ),
            ),
            if (state is AddReservationsOfHourLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryBlue,
                ),
              ),
          ]),
        );
      },
    );
  }
}
