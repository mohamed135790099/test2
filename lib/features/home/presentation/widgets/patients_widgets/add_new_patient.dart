import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/data/local/cache_helper.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/get_data_loading_widget.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/name_form_field.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/phone_form_field.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewPatient extends StatefulWidget {
  const AddNewPatient({super.key});

  @override
  State<AddNewPatient> createState() => _AddNewPatientState();
}

class _AddNewPatientState extends State<AddNewPatient> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  String? _selectedGender;
  final CacheHelper _cacheHelper = CacheHelper();

  void _handleGenderChange(String? value) {
    setState(() {
      _selectedGender = value;
    });
    if (value != null) {
      _cacheHelper.saveGender(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.addNewPatient,
                          style: AppTextStyle.font18black700,
                        ),
                        26.hs,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NameFormField(nameController: nameController),
                            16.hs,
                            PhoneFormField(phoneController: phoneController),
                          ],
                        ).withHorizontalPadding(16),
                        12.hs,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: const Text("ذكر"),
                              leading: Radio<String>(
                                value: 'male',
                                groupValue: _selectedGender,
                                onChanged: _handleGenderChange,
                                activeColor: Colors.blue,
                                // Color when selected
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue;
                                  }
                                  return Colors.grey;
                                }),
                              ),
                            ),
                            ListTile(
                              title: const Text("أنثي"),
                              leading: Radio<String>(
                                value: 'female',
                                groupValue: _selectedGender,
                                onChanged: _handleGenderChange,
                                activeColor: Colors.pink,
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.pink;
                                  }
                                  return Colors.grey;
                                }),
                              ),
                            ),
                          ],
                        ),
                        22.hs,
                        AppButton3(
                          isValid: isValid,
                          title: AppStrings.add,
                          onPressed: () {
                            reservationCubit.createUserByAdmin(
                                nameController.text,
                                "2${phoneController.text}",
                                _selectedGender ?? "");
                          },
                        )
                      ],
                    ).withVerticalPadding(20),
                  ),
                ),
              ),
            ),
            state is CreateUserByAdminLoading
                ? const Center(child: GetDataLoadingWidget())
                : const SizedBox()
          ],
        );
      },
    );
  }
}
