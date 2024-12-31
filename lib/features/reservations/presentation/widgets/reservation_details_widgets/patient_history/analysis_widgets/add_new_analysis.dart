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

class AddNewAnalysis extends StatefulWidget {
  final String? analysisId;

  const AddNewAnalysis({super.key, this.analysisId});

  @override
  State<AddNewAnalysis> createState() => _AddNewAnalysisState();
}

class _AddNewAnalysisState extends State<AddNewAnalysis> {
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.analysisId != null) {
      context.read<ReservationCubit>().getOneAnalysis(widget.analysisId!);
      titleController.text =
          context.read<ReservationCubit>().getUserAnalysis?.title ?? '';
      detailsController.text =
          context.read<ReservationCubit>().getUserAnalysis?.terms ?? '';
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
        if (state is EditAnalysisSuccess) {
          Navigator.pop(context);
          AppToaster.show("تم التعديل بنجاح");
        } else if (state is CreateAnalysisSuccess) {
          Navigator.pop(context);
          AppToaster.show("تم الإضافة بنجاح");
        } else if (state is CreateAnalysisLoading ||
            state is EditAnalysisLoading) {
          setState(() {
            isSubmitting = true;
          });
          AppToaster.show("برجاء الإنتظار يتم تحميل الملف",duration: 4000);
        } else if (state is CreateAnalysisError) {
          ErrorAppToaster.show((state).error);
          setState(() {
            isSubmitting = false;
          });
        } else if (state is EditAnalysisError) {
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


          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    onChanged: () {
                      if (_formKey.currentState?.validate() == true ||
                          reservationCubit.analysisImage != null ||
                          reservationCubit.analysisPdfFile != null ||
                          titleController.text.isNotEmpty ||
                          detailsController.text.isNotEmpty) {
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
                        color: AppColor.white,
                      ),
                      child: ListView(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.analysisId == null
                                    ? AppStrings.addAnalysis
                                    : "تعديل التحليل",
                                style: AppTextStyle.font18black700,
                              ),
                              16.hs,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UploadImage(
                                    images: reservationCubit.analysisImage,
                                    title: AppStrings.uploadImagesOfXRay,
                                    onPressed: () async {
                                      await context
                                          .read<ReservationCubit>()
                                          .getAnalysisImage(context);
                                    },
                                    onPressedRemove: (image) {
                                      reservationCubit
                                          .removeAnalysisImage(image);
                                    },
                                  ),
                                  UploadImage(
                                    title: AppStrings.uploadFileOfAnalysis,
                                    onPressed: () async {
                                      await reservationCubit
                                          .getAnalysisPdfFile();
                                    },
                                    onPressedRemove: (file) {},
                                  ),
                                  16.hs,
                                  TitleFormField(
                                      titleController: titleController),
                                  16.hs,
                                  DetailsFormField(
                                      detailsController: detailsController),
                                ],
                              ).withHorizontalPadding(16),
                              22.hs,
                              AppButton3(
                                isValid: isValid || !isSubmitting,
                                title: widget.analysisId == null
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

                                  if (widget.analysisId == null) {
                                    await reservationCubit.createAnalysis(
                                        titleController.text,
                                        detailsController.text,
                                        userId);
                                    reservationCubit.clearAnalysisImage();
                                  } else {
                                    await reservationCubit.editAnalysis(
                                        widget.analysisId!,
                                        titleController.text,
                                        detailsController.text);
                                    reservationCubit.clearAnalysisImage();
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
                if (isSubmitting)
                  const Center(
                      child: CircularProgressIndicator(
                    color: AppColor.primaryBlue,
                  )),
              ],
            ),
          );
        },
      ),
    );
  }
}
