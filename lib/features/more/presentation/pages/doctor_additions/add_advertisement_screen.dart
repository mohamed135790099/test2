import 'dart:io';

import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/manager/doctor_additions_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/manager/doctor_additions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddAdvertisementScreen extends StatefulWidget {
  const AddAdvertisementScreen({super.key});

  @override
  State<AddAdvertisementScreen> createState() => _AddAdvertisementScreenState();
}

class _AddAdvertisementScreenState extends State<AddAdvertisementScreen> {
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

  bool isValid = true;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    DoctorAdditionsCubit.get(context).getAllAds();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColor.primaryBlue,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.primaryBlue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.fill)
                      : const Center(child: Text('اضغط لاختيار صورة الإعلان')),
                ),
              ),
              SizedBox(height: 16.h),
              AppTextField(
                  controller: _linkController, labelText: 'رابط الاعلان'),
              SizedBox(height: 16.h),
              AppTextField(
                  controller: _periodController, labelText: 'مدة الاعلان'),
              SizedBox(height: 16.h),
              BlocConsumer<DoctorAdditionsCubit, DoctorAdditionsState>(
                listener: (context, state) {
                  if (state is UploadSuccessState) {
                    AppToaster.show("Ads Uploaded successfully");
                    _linkController.text = "";
                    _periodController.text = "";

                    setState(() {
                      _imageFile = null;
                    });
                  } else if (state is UploadErrorState) {
                    ErrorAppToaster.show(state.error);
                  }
                },
                builder: (context, state) {
                  DoctorAdditionsCubit cubit =
                      DoctorAdditionsCubit.get(context);
                  if (state is UploadLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                      ),
                    );
                  }
                  if (state is AdsSuccessState) {
                    isValid = state.ads.isEmpty ? true : false;
                  }
                  return AppButton3(
                      isValid: isValid,
                      title: "رفع الاعلان",
                      onPressed: () {
                        final link = _linkController.text.trim();
                        int period = int.parse(_periodController.text);
                        if (_imageFile != null) {
                          cubit.uploadAdsData(link, _imageFile, period);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ادخل جميع الحقول'),
                            ),
                          );
                        }
                      });
                },
              ),
              SizedBox(height: 16.h),
              const Divider(color: AppColor.primaryBlue, thickness: 2),
              SizedBox(height: 16.h),
              Container(
                  padding: const EdgeInsetsDirectional.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlueTransparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "ملاحظة: يرجي حذف الاعلان المتاح قبل رفع اعلان جديد",
                    style: AppTextStyle.font14primaryBlue500,
                  )),
              SizedBox(height: 20.h),
              BlocBuilder<DoctorAdditionsCubit, DoctorAdditionsState>(
                builder: (context, state) {
                  if (state is AdsLoadingState || state is DeleteAdLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                      ),
                    );
                  } else if (state is DeleteAdError) {
                    ErrorAppToaster.show(state.error);
                  } else if (state is AdsErrorState) {
                    ErrorAppToaster.show(state.error);
                  } else if (state is AdsSuccessState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.ads.length,
                      itemBuilder: (context, index) {
                        final ad = state.ads[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    ad['image'],
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ad['link'],
                                        style: const TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        " عدد المشاهدات :${int.tryParse(ad['count'].toString()) ?? 0}",
                                        style: AppTextStyle.font16black400,
                                        overflow: TextOverflow.visible,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _onDeleteAd(context, ad['_id']);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is AdsErrorState) {
                    return Center(child: Text(state.error));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDeleteAd(BuildContext context, String adId) async {
    await context.read<DoctorAdditionsCubit>().deleteAd(adId);
    setState(() {});
  }

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    await DoctorAdditionsCubit.get(context).getAllAds();
  }
}
