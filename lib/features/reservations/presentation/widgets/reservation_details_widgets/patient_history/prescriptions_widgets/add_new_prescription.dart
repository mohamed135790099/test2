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

class AddNewPrescription extends StatefulWidget {
  final String? prescriptionId;

  const AddNewPrescription({super.key, this.prescriptionId});

  @override
  State<AddNewPrescription> createState() => _AddNewPrescriptionState();
}

class _AddNewPrescriptionState extends State<AddNewPrescription> {
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.prescriptionId != null) {
      context
          .read<ReservationCubit>()
          .getOnePrescription(widget.prescriptionId!);
    }
    titleController.text =
        context.read<ReservationCubit>().getUserAnalysis?.title ?? '';
    detailsController.text =
        context.read<ReservationCubit>().getUserAnalysis?.terms ?? '';
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
        if (state is EditPrescriptionSuccess) {
          Navigator.pop(context);
          AppToaster.show("تم التعديل بنجاح");
        } else if (state is CreatePrescriptionSuccess) {
          Navigator.pop(context);
          AppToaster.show("تم الاضافة بنجاح");
        } else if (state is EditPrescriptionLoading ||
            state is CreatePrescriptionLoading) {
          setState(() {
            isSubmitting = true;
          });
          AppToaster.show("برجاء الإنتظار يتم تحميل الملف",duration: 4000);

        } else if (state is CreatePrescriptionError) {
          ErrorAppToaster.show((state).error);
          setState(() {
            isSubmitting = false;
          });
        } else if (state is EditPrescriptionError) {
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
          if (state is GetOnePrescriptionSuccess &&
              widget.prescriptionId != null) {
            titleController.text =
                reservationCubit.getUserPrescription?.title ?? '';
            detailsController.text =
                reservationCubit.getUserPrescription?.terms ?? '';
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
                          reservationCubit.prescriptionImage != null &&
                          reservationCubit.prescriptionImage!.isNotEmpty) {
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
                                widget.prescriptionId == null
                                    ? AppStrings.addPrescriptions
                                    : "تعديل الروشتة",
                                style: AppTextStyle.font18black700,
                              ),
                              16.hs,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UploadImage(
                                    images: reservationCubit.prescriptionImage,
                                    title: AppStrings.uploadFileOfPrescription,
                                    onPressed: () {
                                      reservationCubit
                                          .getPrescriptionImage(context);
                                    },
                                    onPressedRemove: (image) {
                                      reservationCubit
                                          .removePrescriptionImage(image);
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
                                isValid: isValid || !isSubmitting,
                                title: widget.prescriptionId == null
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
                                  if (widget.prescriptionId == null) {
                                    await reservationCubit.createPrescription(
                                        titleController.text,
                                        detailsController.text,
                                        userId);
                                    reservationCubit.clearPrescriptionImage();
                                  } else {
                                    await reservationCubit.editPrescription(
                                        userId,
                                        widget.prescriptionId!,
                                        titleController.text,
                                        detailsController.text);
                                    reservationCubit.clearPrescriptionImage();
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
                state is CreatePrescriptionLoading ||
                        state is EditPrescriptionLoading
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
