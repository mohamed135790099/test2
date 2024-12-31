import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_2.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/add_reservations_of_hour.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/add_services_screen.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/profile/more_buttons_item.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';

class DoctorAdditionScreen extends StatefulWidget {
  const DoctorAdditionScreen({super.key});

  @override
  State<DoctorAdditionScreen> createState() => _DoctorAdditionScreenState();
}

class _DoctorAdditionScreenState extends State<DoctorAdditionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar2(title: AppStrings.doctorAdditions),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // MoreButtonsItem(
            //   icon: Assets.svgDetails,
            //   title: AppStrings.addAds,
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const AddAdvertisementScreen()));
            //   },
            // ),
            12.hs,
            MoreButtonsItem(
              icon: Assets.svgDetails,
              title: AppStrings.addServices,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddServicesScreen()));
              },
            ),
            12.hs,
            MoreButtonsItem(
              icon: Assets.svgDetails,
              title: AppStrings.addResOfHour,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddReservationsOfHour()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
