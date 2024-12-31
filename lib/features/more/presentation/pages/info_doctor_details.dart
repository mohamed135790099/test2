import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/models/doctor_info_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoDoctorDetails extends StatefulWidget {
  const InfoDoctorDetails({super.key});

  @override
  State<InfoDoctorDetails> createState() => _InfoDoctorDetailsState();
}

class _InfoDoctorDetailsState extends State<InfoDoctorDetails> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(
      builder: (context, state) {
        if (state is FetchDoctorInfoLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColor.primaryBlue,
          ));
        } else if (state is FetchDoctorInfoLoaded) {
          if (state.doctorInfo.isEmpty) {
            return const Center(
                child: Text("لا توجد معلومات متاحة عن الطبيب حاليا"));
          }
          final doctor = state.doctorInfo.last;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              color: AppColor.grey7,
              padding: const EdgeInsetsDirectional.all(10),
              height: 620.h,
              child: ListView(
                children: [
                  if (doctor.name != "")
                    _buildInfoCard(AppStrings.doctorName, doctor.name),
                  10.hs,
                  if (doctor.dateOfBirth != "")
                    _buildInfoCard(
                        AppStrings.doctorBirthday, doctor.dateOfBirth),
                  10.hs,
                  if (doctor.country != "")
                    _buildInfoCard(AppStrings.doctorCountry, doctor.country),
                  10.hs,
                  if (doctor.title != "")
                    _buildInfoCard(
                        AppStrings.doctorBasicQualification, doctor.title),
                  10.hs,
                  if (doctor.study != "")
                    _buildInfoCard(
                        AppStrings.doctorGraduateStudies, doctor.study),
                  10.hs,
                  if (doctor.branches != "")
                    _buildInfoCard(AppStrings.doctorBranches, doctor.branches),
                  30.hs,
                    _buildSocialLinks(doctor),
                  100.hs
                ],
              ),
            ),
          );
        } else if (state is AddDoctorInfoFailure) {
          return Center(
              child: Text("Failed to load doctor info: ${state.error}"));
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsetsDirectional.all(10),
              child: Text(
                title,
                style: AppTextStyle.font12black400,
              ),
            ),
          ),
          10.ws,
          const Expanded(
              flex: 1,
              child: VerticalDivider(color: AppColor.grey, thickness: 2)),
          10.ws,
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsetsDirectional.all(12),
              child: Text(
                value,
                style: AppTextStyle.font14black500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks(DoctorInfoModel doctor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (doctor.facebookLink != "")
          InkWell(
            onTap: () async => await _launchUrl(doctor.facebookLink!),
            child: const AppImageView(
              svgPath: Assets.facebook,
            ),
          ),
        if (doctor.instagramLink != "")
          InkWell(
            onTap: () async => await _launchUrl(doctor.instagramLink!),
            child: const AppImageView(
              svgPath: Assets.instagram,
            ),
          ),
        if (doctor.twitterLink != "")
          InkWell(
            onTap: () async => await _launchUrl(doctor.twitterLink!),
            child: const AppImageView(
              svgPath: Assets.twitter,
            ),
          ),
        if (doctor.youtubeLink != "")
          InkWell(
            onTap: () async => await _launchUrl(doctor.youtubeLink!),
            child: const AppImageView(
              svgPath: Assets.youtube,
            ),
          ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}
