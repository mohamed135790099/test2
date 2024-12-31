import 'dart:io';

import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_2.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_1.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/models/doctor_info_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/about_doctor_screen.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/add_social_links_dialog.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/birthdate_calendar.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class AddDoctorInfo extends StatefulWidget {
  final String? doctorInfoId;
  final DoctorInfoModel? doctorInfo;

  const AddDoctorInfo({super.key, this.doctorInfoId, this.doctorInfo});

  @override
  _AddDoctorInfoState createState() => _AddDoctorInfoState();
}

class _AddDoctorInfoState extends State<AddDoctorInfo> {
  late List<File> _images = [];
  late TextEditingController fullNameController;
  late TextEditingController birthDateController;
  late TextEditingController countryController;
  late TextEditingController basicQualificationController;
  late TextEditingController graduateStudiesController;
  late TextEditingController branchesController;
  String? _facebookLink;
  String? _instagramLink;
  String? _youtubeLink;
  String? _twitterLink;
  bool isUploading = false;
  bool enable = false;

  @override
  void initState() {
    super.initState();

    fullNameController =
        TextEditingController(text: widget.doctorInfo?.name ?? '');
    birthDateController =
        TextEditingController(text: widget.doctorInfo?.dateOfBirth ?? '');
    countryController =
        TextEditingController(text: widget.doctorInfo?.country ?? '');
    basicQualificationController =
        TextEditingController(text: widget.doctorInfo?.title ?? '');
    graduateStudiesController =
        TextEditingController(text: widget.doctorInfo?.study ?? '');
    branchesController =
        TextEditingController(text: widget.doctorInfo?.branches ?? '');
    _facebookLink = widget.doctorInfo?.facebookLink;
    _instagramLink = widget.doctorInfo?.instagramLink;
    _youtubeLink = widget.doctorInfo?.youtubeLink;
    _twitterLink = widget.doctorInfo?.twitterLink;

    if (widget.doctorInfo?.images != null) {
      _images = widget.doctorInfo!.images
          .map((imagePath) => File(imagePath))
          .toList();
    }

    enable = _images.isNotEmpty;

    fullNameController.addListener(_onFullNameChanged);
  }

  void _onFullNameChanged() {
    setState(() {
      enable = fullNameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    fullNameController.removeListener(_onFullNameChanged);
    fullNameController.dispose();
    birthDateController.dispose();
    countryController.dispose();
    basicQualificationController.dispose();
    graduateStudiesController.dispose();
    branchesController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    List<XFile>? pickedFiles;

    try {
      isUploading = true;
      pickedFiles = await picker.pickMultiImage();
    } catch (e) {
      print('Error picking images: $e');
      return;
    }

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      List<File> compressedImages = [];

      for (XFile xfile in pickedFiles) {
        try {
          File file = File(xfile.path);
          File compressedImage = await compressImage(file);
          compressedImages.add(compressedImage);
        } catch (e) {
          print('Error compressing image: $e');
        }
      }

      setState(() {
        _images.addAll(compressedImages);
        enable = _images.isNotEmpty;
      });
    } else {
      setState(() {
        enable = false;
      });
    }

    isUploading = false;
  }

  Future<File> compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes)!;

      final compressedImage = img.encodeJpg(image, quality: 70);
      final compressedFile = await file.writeAsBytes(compressedImage);
      enable = true;
      isUploading = false;
      return compressedFile;
    } catch (e) {
      print('Error during image compression: $e');
      rethrow;
    }
  }

  List<File> getLocalImages() {
    return _images.where((image) => image.existsSync()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar2(
        title: widget.doctorInfoId == null
            ? AppStrings.addMyInfo
            : AppStrings.updateInfo,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  AppTextField(
                    validator: ValidationForm.detailsValidator,
                    keyboardType: TextInputType.text,
                    radius: 8.r,
                    labelText: "إسم الطبيب رباعي",
                    hintText: "برجاء إدخال الإسم رباعي",
                    controller: fullNameController,
                  ),
                  12.hs,
                  AppTextField(
                    validator: ValidationForm.userNameValidator,
                    keyboardType: TextInputType.text,
                    radius: 8.r,
                    labelText: "بلد المنشأ",
                    hintText: "برجاء إدخال البلد المنشأ",
                    controller: countryController,
                  ),
                  12.hs,
                  BirthdateCalendar(
                    birthDateController,
                    addressText: "تاريخ الميلاد",
                    onDateSelected: onDateSelected,
                  ),
                  12.hs,
                  AppTextField(
                    validator: ValidationForm.detailsValidator,
                    keyboardType: TextInputType.text,
                    radius: 8.r,
                    labelText: "المؤهل الاساسي",
                    hintText: "برجاء إدخال المؤهل الاساسي",
                    controller: basicQualificationController,
                  ),
                  12.hs,
                  AppTextField(
                    validator: ValidationForm.detailsValidator,
                    keyboardType: TextInputType.text,
                    radius: 8.r,
                    isMultiLine: true,
                    labelText: "الدراسات العليا",
                    hintText: "برجاء إدخال الدراسات العليا المتحضرة",
                    controller: graduateStudiesController,
                  ),
                  12.hs,
                  AppTextField(
                    validator: ValidationForm.detailsValidator,
                    keyboardType: TextInputType.text,
                    radius: 8.r,
                    labelText: "الفروع الخاصة",
                    hintText: "برجاء إدخال الفروع الخاصة بالطبيب",
                    controller: branchesController,
                    isMultiLine: true,
                  ),
                  18.hs,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppButton1(
                        width: 150.w,
                        title: "إضافة الشهادات المرفقة",
                        onPressed: _pickImages,
                      ),
                      AppButton1(
                        title: "إضافة مواقع التواصل الاجتماعي",
                        width: 150.w,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext context) =>
                                AddSocialLinksBottomSheet(
                              onSave: (facebook, instagram, twitter, youtube) {
                                _facebookLink = facebook;
                                _instagramLink = instagram;
                                _twitterLink = twitter;
                                _youtubeLink = youtube;
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  20.hs,
                  _images.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.all(16.h),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.h,
                              mainAxisSpacing: 8.h,
                            ),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              final imagePath = _images[index].path;
                              bool isNetworkImage =
                                  Uri.tryParse(imagePath)?.hasAbsolutePath ??
                                      false;
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                          color: Colors.grey, width: 2.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: isNetworkImage
                                          ? Image.network(
                                              imagePath,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.file(
                                                  _images[index],
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            )
                                          : Image.file(
                                              _images[index],
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  // Positioned delete icon
                                  Positioned(
                                    top: 4.h,
                                    right: 4.h,
                                    child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isUploading = true;
                                        });

                                        String imageUrl = _images[index].path;
                                        await context
                                            .read<MoreCubit>()
                                            .deleteCertificate(
                                                widget.doctorInfoId ?? "",
                                                imageUrl);

                                        setState(() {
                                          _images.removeAt(index);
                                          isUploading = false;
                                          enable = true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.7),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(4.w),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 20.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Container(),
                  if (isUploading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                      ),
                    ),
                  // Show a loader while uploading
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsetsDirectional.all(22.h),
              child: BlocConsumer<MoreCubit, MoreState>(
                listener: (context, state) {
                  if (state is DoctorInfoSuccess ||
                      state is AddDoctorInfoSuccess) {
                    AppToaster.show(widget.doctorInfoId == null
                        ? 'تم إضافة معلومات الطبيب بنجاح'
                        : 'تم تعديل معلومات الطبيب بنجاح');
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutDoctorScreen()));
                  } else if (state is DoctorInfoError) {
                    ErrorAppToaster.show((state).error);
                  } else if (state is AddDoctorInfoFailure) {
                    ErrorAppToaster.show((state).error);
                  } else if (state is DoctorInfoLoading ||
                      state is AddDoctorInfoLoading) {
                    const Center(
                        child: CircularProgressIndicator(
                      color: AppColor.primaryBlue,
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is DoctorInfoLoading ||
                      state is AddDoctorInfoLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                      ),
                    );
                  } else {
                    return AppButton3(
                      isValid: enable,
                      title: widget.doctorInfoId == null
                          ? "إضافة المعلومات"
                          : "تعديل المعلومات",
                      onPressed: () async {
                        if (widget.doctorInfoId == null) {
                          List<File> localImages = getLocalImages();
                          await context.read<MoreCubit>().addDoctorInfo(
                              fullName: fullNameController.text,
                              birthDate: birthDateController.text,
                              country: countryController.text,
                              basicQualification:
                                  basicQualificationController.text,
                              graduateStudies: graduateStudiesController.text,
                              branches: branchesController.text,
                              facebookLink: _facebookLink,
                              instagramLink: _instagramLink,
                              twitterLink: _twitterLink,
                              youtubeLink: _youtubeLink,
                              images: localImages);
                          Navigator.pop(context);
                        } else {
                          List<File> localImages = getLocalImages();
                          List<String> existingImages =
                              widget.doctorInfo?.images ?? [];
                          List<File> filesToUpload = List.from(localImages);
                          for (String imagePath in existingImages) {
                            if (imagePath.startsWith('/')) {
                              File file = File(imagePath);
                              if (!filesToUpload
                                  .any((f) => f.path == file.path)) {
                                filesToUpload.add(file);
                              }
                            }
                          }
                          await context.read<MoreCubit>().editDoctorInfo(
                                infoId: widget.doctorInfoId!,
                                name: fullNameController.text,
                                dateOfBirth: birthDateController.text,
                                country: countryController.text,
                                title: basicQualificationController.text,
                                study: graduateStudiesController.text,
                                branches: branchesController.text,
                                facebookLink: _facebookLink,
                                instagramLink: _instagramLink,
                                twitterLink: _twitterLink,
                                youtubeLink: _youtubeLink,
                                images: filesToUpload,
                              );
                          Navigator.pop(context);
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onDateSelected() {
    setState(() {});
  }
}
