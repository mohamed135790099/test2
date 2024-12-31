import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/data/local/cache_helper.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/about_doctor_screen.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/add_doctor_info.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/all_filtered_receipts.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/booking_times_screen.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/doctor_addition_screen.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/profile/more_buttons_item.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/profile/more_picture_item.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/cache_utils/cache_vars.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String doctorName = "لا يوجد إسم للطبيب حاليا";
  bool isLoadDoctorInfo = false;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  void _fetchImage() async {
    await context.read<MoreCubit>().fetchDoctorInfo();
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      context.read<MoreCubit>().fetchDoctorInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(
      builder: (context, state) {
        if (!isLoadDoctorInfo) {
          if (state is FetchDoctorInfoLoaded && state.doctorInfo.isNotEmpty) {
            doctorName = state.doctorInfo.last.name;
            isLoadDoctorInfo = true;
          }
        }
        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: _refreshData,
          child: Stack(
            children: [
              Scaffold(
                body: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    MorePictureItem(doctorName: doctorName),
                    30.hs,
                    MoreButtonsItem(
                      icon: Assets.svgPen,
                      title: AppStrings.articles,
                      onPressed: () {
                        MoreCubit.get(context).getAllArticle().then((onValue) {
                          RouterApp.pushNamed(RouteName.articleScreen);
                        });
                      },
                    ),
                    12.hs,
                    MoreButtonsItem(
                      icon: Assets.svgCalendar,
                      title: "مواعيد استقبال الحجوزات",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookingTimesScreen()));
                      },
                    ),
                    12.hs,
                    MoreButtonsItem(
                      icon: Assets.svgDetails,
                      title: AppStrings.moneys,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllFilteredReceipts()));
                      },
                    ),
                    12.hs,
                    MoreButtonsItem(
                      icon: Assets.svgPen,
                      title: AppStrings.aboutDoctor,
                      onPressed: () async {
                        final moreCubit = MoreCubit.get(context);

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        await moreCubit.fetchDoctorInfo();
                        Navigator.of(context).pop();

                        if (moreCubit.state is FetchDoctorInfoLoaded) {
                          final doctorInfo =
                              (moreCubit.state as FetchDoctorInfoLoaded)
                                  .doctorInfo;

                          if (doctorInfo.isEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddDoctorInfo(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutDoctorScreen(),
                              ),
                            );
                          }
                        } else if (moreCubit.state is FetchDoctorInfoFailure) {
                          final errorMessage =
                              (moreCubit.state as FetchDoctorInfoFailure).error;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    12.hs,
                    MoreButtonsItem(
                      icon: Assets.doctorAdditions,
                      title: AppStrings.doctorAdditions,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DoctorAdditionScreen()));
                      },
                    ),
                    12.hs,
                    MoreButtonsItem(
                      title: AppStrings.signOut,
                      icon: Assets.svgLogout,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('تسجيل الخروج'),
                            content:
                                const Text('هل انت متأكد من تسجيل الخروج ؟'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('إلغاء',
                                    style: AppTextStyle.font14red500),
                              ),
                              TextButton(
                                onPressed: () async {
                                  CacheHelper.clearData(
                                          key: CacheVars.token ?? "")
                                      .then((value) =>
                                          RouterApp.pushNamedAndRemoveUntil(
                                              RouteName.loginScreen));
                                },
                                child: Text('تسجيل خروج',
                                    style: AppTextStyle.font14primaryBlue500),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              state is GetAllArticlesLoading || state is MoreImageFetchLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: AppColor.primaryBlue,
                    ))
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}
