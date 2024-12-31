import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/manager/states.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/patient_history.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientHistoryDetails extends StatefulWidget {
  final String patientId;

  PatientHistoryDetails({super.key, required this.patientId});

  @override
  State<PatientHistoryDetails> createState() => _PatientHistoryDetailsState();
}

class _PatientHistoryDetailsState extends State<PatientHistoryDetails> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aeradShakWaController = TextEditingController();

  final TextEditingController _shakWaOnTimeController = TextEditingController();

  final TextEditingController _shakWaPastTimeController =
      TextEditingController();

  final TextEditingController _periodController = TextEditingController();

  final TextEditingController _contraceptivesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await context.read<PatientDetailsCubit>().getPatientData(widget.patientId);
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientDetailsCubit, PatientHistoryState>(
      builder: (context, state) {
        return Builder(
          builder: (context) {
            if (state is PatientHistoryLoading) {
              return Column(
                children: [
                  SizedBox(height: 300.h),
                  const Center(
                      child: CircularProgressIndicator(
                    color: AppColor.primaryBlue,
                  )),
                ],
              );
            } else if (state is PatientHistoryLoaded) {
              _populateFields(state.patientHistory);
              return _buildForm(context);
            } else if (state is PatientHistoryUpdated) {
              return Column(
                children: [
                  SizedBox(height: 300.h),
                  AppToaster.show(state.message),
                ],
              );
            } else if (state is PatientHistoryError) {
              return ErrorAppToaster.show(state.message);
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  void _populateFields(PatientHistory patientHistory) {
    _codeController.text = patientHistory.code ?? '';
    _nameController.text = patientHistory.name ?? '';
    _phoneController.text = patientHistory.phone ?? '';
    _ageController.text = patientHistory.age?.toString() ?? '';
    _aeradShakWaController.text = patientHistory.aeradShakWa ?? '';
    _shakWaOnTimeController.text = patientHistory.shakWaOnTime ?? '';
    _shakWaPastTimeController.text = patientHistory.shakWaPastTime ?? '';
    _periodController.text = patientHistory.period ?? '';
    _contraceptivesController.text = patientHistory.contraceptives ?? '';
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: 600.h,
          child: ListView(
            children: [
              AppTextField(
                  controller: _codeController, labelText: AppStrings.code),
              SizedBox(height: 12.h),
              Container(
                margin: EdgeInsetsDirectional.only(start: 12.w),
                child: Text(
                  AppStrings.name,
                  style: AppTextStyle.font14black500,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(
                    color: AppColor.grey7,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                child: Text(
                  _nameController.text,
                  style: AppTextStyle.font16black400,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                margin: EdgeInsetsDirectional.only(start: 12.w),
                child: Text(
                  AppStrings.phoneNumber,
                  style: AppTextStyle.font14black500,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(
                    color: AppColor.grey7,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                child: Text(
                  _phoneController.text.substring(1),
                  style: AppTextStyle.font16black400,
                ),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _ageController,
                labelText: AppStrings.age,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                  controller: _aeradShakWaController,
                  labelText: AppStrings.aeradShakWa),
              SizedBox(height: 12.h),
              AppTextField(
                  controller: _shakWaOnTimeController,
                  labelText: AppStrings.shakwaOnTime),
              SizedBox(height: 12.h),
              AppTextField(
                  controller: _shakWaPastTimeController,
                  labelText: AppStrings.shakwaPastTime),
              // SizedBox(height: 12.h),
              // AppTextField(
              //     controller: _periodController, labelText: AppStrings.period),
              // SizedBox(height: 12.h),
              // AppTextField(
              //     controller: _contraceptivesController,
              //     labelText: AppStrings.contraceptives),
              SizedBox(height: 20.h),
              AppButton3(
                isValid: true,
                title: AppStrings.update,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final patientHistory = PatientHistory(
                      code: _codeController.text,
                      name: _nameController.text,
                      age: int.tryParse(_ageController.text),
                      aeradShakWa: _aeradShakWaController.text,
                      shakWaOnTime: _shakWaOnTimeController.text,
                      shakWaPastTime: _shakWaPastTimeController.text,
                      period: _periodController.text,
                      contraceptives: _contraceptivesController.text,
                    );

                    context
                        .read<PatientDetailsCubit>()
                        .updatePatientHistory(widget.patientId, patientHistory);
                  }
                },
              ),
              SizedBox(height: 120.h)
            ],
          ),
        ),
      ),
    );
  }
}
