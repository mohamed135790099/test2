import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_2.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/about_doctor_toggle.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/add_doctor_info.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutDoctorScreen extends StatefulWidget {
  const AboutDoctorScreen({super.key});

  @override
  State<AboutDoctorScreen> createState() => _AboutDoctorScreenState();
}

class _AboutDoctorScreenState extends State<AboutDoctorScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoreCubit>().fetchDoctorInfo();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColor.primaryBlue,
      backgroundColor: AppColor.white,
      onRefresh: _onRefresh,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: DefaultAppBar2(
          title: AppStrings.aboutDoctor,
        ),
        body: Stack(
          children: [
            const AboutDoctorToggle(),
            Positioned(
              bottom: 22.h,
              right: 15.h,
              left: 15.h,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: AppButton3(
                  title: 'تعديل المعلومات',
                  isValid: true,
                  onPressed: () async {
                    final doctorInfo =
                        context.read<MoreCubit>().state is FetchDoctorInfoLoaded
                            ? (context.read<MoreCubit>().state
                                    as FetchDoctorInfoLoaded)
                                .doctorInfo
                                .last
                            : null;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDoctorInfo(
                          doctorInfoId: doctorInfo?.id,
                          doctorInfo: doctorInfo,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await MoreCubit.get(context).fetchDoctorInfo();
    setState(() {});
  }
}
