import 'package:dr_mohamed_salah_admin/core/widgets/components/toggle_tabs.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_certificates.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/info_doctor_details.dart';
import 'package:flutter/material.dart';

class AboutDoctorToggle extends StatefulWidget {
  const AboutDoctorToggle({super.key});

  @override
  State<AboutDoctorToggle> createState() => _AboutDoctorToggleState();
}

class _AboutDoctorToggleState extends State<AboutDoctorToggle> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleTabs(
          isHome: true,
          tabs: const ["المعلومات", "الشهادات"],
          currentIndex: _currentIndex,
          onIndexChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        _currentIndex == 0
            ? const InfoDoctorDetails()
            : const DoctorCertificates(),
      ],
    );
  }
}
