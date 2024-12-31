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

class AddNewXRay extends StatefulWidget {
  final String? xrayId;

  const AddNewXRay({super.key, this.xrayId});

  @override
  State<AddNewXRay> createState() => _AddNewXRayState();
}

class _AddNewXRayState extends State<AddNewXRay> {
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.xrayId != null) {
      context.read<ReservationCubit>().getOneXRay(widget.xrayId!);
    }
    titleController.text =
        context.read<ReservationCubit>().getUserXRay?.title ?? '';
    detailsController.text =
        context.read<ReservationCubit>().getUserXRay?.terms ?? '';
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
        if (state is EditXRaySuccess) {
          Navigator.pop(context);
          AppToaster.show("تم التعديل بنجاح");
        } else if (state is CreateXRaySuccess) {
          Navigator.pop(context);
          AppToaster.show("تم الإضافة بنجاح");
        } else if (state is CreateXRayLoading || state is EditXRayLoading) {
          setState(() {
            isSubmitting = true;
          });
          AppToaster.show("برجاء الإنتظار يتم تحميل الملف",duration: 4000);

        } else if (state is CreateXRayError) {
          ErrorAppToaster.show((state).error);
          setState(() {
            isSubmitting = false;
          });
        } else if (state is EditXRayError) {
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
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Form(
                    onChanged: () {
                      if (_formKey.currentState?.validate() == true &&
                              reservationCubit.xRayImage != null ||
                          reservationCubit.xPdfFile != null) {
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
                      margin: const EdgeInsetsDirectional.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: AppColor.white,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.xrayId == null
                                    ? AppStrings.addXRay
                                    : "تعديل الاشعة",
                                style: AppTextStyle.font18black700,
                              ),
                              16.hs,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UploadImage(
                                    images: reservationCubit.xRayImage,
                                    title: AppStrings.uploadImagesOfXRay,
                                    onPressed: () async {
                                      await context
                                          .read<ReservationCubit>()
                                          .getXRayImage(context);
                                    },
                                    onPressedRemove: (image) {
                                      reservationCubit.removeXRayImage(image);
                                    },
                                  ),
                                  UploadImage(
                                    title: AppStrings.uploadFilesOfXRay,
                                    onPressed: () async {
                                      await reservationCubit.getXrayPdfFile();
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
                                title: widget.xrayId == null
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

                                  if (widget.xrayId == null) {
                                    await reservationCubit.createXRay(
                                        titleController.text,
                                        detailsController.text,
                                        userId);
                                    reservationCubit.clearXRayImage();
                                  } else {
                                    await reservationCubit.editXRay(
                                        userId,
                                        widget.xrayId!,
                                        titleController.text,
                                        detailsController.text);
                                    reservationCubit.clearXRayImage();
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
