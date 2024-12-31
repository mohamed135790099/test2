import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/upload_image.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/details_form_field.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/title_form_field.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewMedicine extends StatefulWidget {
  final String? medicineId;

  const AddNewMedicine({super.key, this.medicineId});

  @override
  State<AddNewMedicine> createState() => _AddNewMedicineState();
}

class _AddNewMedicineState extends State<AddNewMedicine> {
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.medicineId != null) {
      context.read<ReservationCubit>().getOneMedicine(widget.medicineId!);
    }
  }

  @override
  void dispose() {
    detailsController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state is EditMedicineSuccess) {
          Navigator.pop(context);
          AppToaster.show("تم التعديل بنجاح");
        } else if (state is CreateMedicineSuccess) {
          Navigator.pop(context);
          AppToaster.show("تم الاضافة بنجاح");
        } else if (state is EditMedicineLoading ||
            state is CreateMedicineLoading) {
          setState(() {
            isSubmitting = true;
          });
        } else if (state is CreateMedicineError) {
          ErrorAppToaster.show((state).error);
          setState(() {
            isSubmitting = false;
          });
        } else if (state is EditMedicineError) {
          ErrorAppToaster.show((state).error);
          setState(() {
            isSubmitting = false;
          });
        }
      },
      child: BlocBuilder<ReservationCubit, ReservationState>(
        builder: (context, state) {
          final ReservationCubit reservationCubit =
              ReservationCubit.get(context);
          if (state is GetOneMedicineSuccess && widget.medicineId != null) {
            titleController.text =
                reservationCubit.getUserMedicine?.title ?? '';
            detailsController.text =
                reservationCubit.getUserMedicine?.terms ?? '';
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    onChanged: () {
                      if (_formKey.currentState?.validate() == true &&
                          reservationCubit.medicinesImage != null &&
                          reservationCubit.medicinesImage!.isNotEmpty) {
                        setState(() {
                          isValid = true;
                        });
                      } else {
                        setState(() {
                          isValid = false;
                        });
                      }
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.medicineId == null
                                    ? AppStrings.addMedicine
                                    : "تعديل الدواء",
                                style: AppTextStyle.font18black700,
                              ),
                              16.hs,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UploadImage(
                                    images: reservationCubit.medicinesImage,
                                    title: AppStrings.uploadFileOfMedicine,
                                    onPressed: () {
                                      reservationCubit
                                          .getMedicineImage(context);
                                    },
                                    onPressedRemove: (image) {
                                      reservationCubit
                                          .removeMedicinesImage(image);
                                    },
                                  ),
                                  16.hs,
                                  TitleFormField(
                                      titleController: titleController),
                                  16.hs,
                                  DetailsFormField(
                                      detailsController: detailsController)
                                ],
                              ).withHorizontalPadding(16),
                              22.hs,
                              AppButton3(
                                isValid: isValid && !isSubmitting,
                                title: widget.medicineId == null
                                    ? AppStrings.add
                                    : "تعديل",
                                onPressed: () async {
                                  final userId =
                                      reservationCubit.getUserDetail?.sId;

                                  if (userId == null || userId.isEmpty) {
                                    setState(() {
                                      isSubmitting = false;
                                    });
                                    AppToaster.show("Invalid User ID");
                                    return;
                                  }
                                  if (widget.medicineId == null) {
                                    await reservationCubit.createMedicine(
                                        titleController.text,
                                        detailsController.text,
                                        userId);
                                    reservationCubit.clearMedicineImage();
                                  } else {
                                    await reservationCubit.editMedicine(
                                        widget.medicineId!,
                                        titleController.text,
                                        detailsController.text);
                                    reservationCubit.clearMedicineImage();
                                  }
                                },
                              ),
                            ],
                          ).withVerticalPadding(20),
                        ],
                      ),
                    ),
                  ),
                ),
                state is CreateMedicineLoading || state is EditMedicineLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                      ))
                    : const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
