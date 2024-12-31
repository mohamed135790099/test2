import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/get_data_loading_widget.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/name_form_field.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/phone_form_field.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePatientDetails extends StatefulWidget {
  final String patientId;

  const UpdatePatientDetails({super.key, required this.patientId});

  @override
  State<UpdatePatientDetails> createState() => _UpdatePatientDetailsState();
}

class _UpdatePatientDetailsState extends State<UpdatePatientDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ReservationCubit>();
    final patientDetails = cubit.getUserDetail;
    if (patientDetails != null) {
      nameController.text = patientDetails.fullName ?? '';
      phoneController.text = patientDetails.phone?.substring(1) ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state is UpdatePatientDetailsSuccess) {
          AppToaster.show("تم التحديث بنجاح");
          Navigator.pop(context);
        } else if (state is UpdatePatientDetailsError) {
          ErrorAppToaster.show(state.message);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
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
                    color: AppColor.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.editPatientDetails,
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
                        22.hs,
                        AppButton3(
                          isValid: isValid,
                          title: AppStrings.update,
                          onPressed: isValid
                              ? () {
                                  context
                                      .read<ReservationCubit>()
                                      .updatePatientDetails(
                                        widget.patientId,
                                        nameController.text,
                                        "2${phoneController.text}",
                                      );
                                  Navigator.pop(context);
                                }
                              : null,
                        ),
                      ],
                    ).withVerticalPadding(20),
                  ),
                ),
              ),
            ),
            if (state is UpdatePatientDetailsLoading)
              const Center(child: GetDataLoadingWidget()),
          ],
        );
      },
    );
  }
}
