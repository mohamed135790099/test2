import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/search_form_field.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/models/get_all_users.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/pages/patients_details_screen.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/widgets/patients_card.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientsList extends StatefulWidget {
  const PatientsList({super.key});

  @override
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ReservationCubit>().getAllUsers();
  }

  void _onPatientTap(String patientId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryBlue,
        ),
      ),
    );

    context.read<ReservationCubit>().getUserDetails(patientId).then((_) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PatientsDetailsScreen(initialId: patientId),
        ),
      );
    }).catchError((_) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في تحميل بيانات المريض'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchFormField(
          hintText: AppStrings.searchByPatientNameOrNumber, // Updated hint
          searchController: searchController,
          onChanged: (value) {
            setState(() {});
          },
        ),
        BlocBuilder<ReservationCubit, ReservationState>(
          builder: (context, state) {
            final List<GetAllUsers> allUsers =
                ReservationCubit.get(context).allUsers;
            final List<GetAllUsers> filteredUsers = allUsers.where((user) {
              final String userName = user.fullName?.toLowerCase() ?? "";
              final String phoneNumber = user.phone ?? "not available number";
              final String searchTerm = searchController.text.toLowerCase();

              return userName.contains(searchTerm) ||
                  phoneNumber.contains(searchTerm);
            }).toList();

            return SizedBox(
              height: 500.h,
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 30.h, top: 20.h),
                shrinkWrap: true,
                itemBuilder: (context, index) => PatientsCard(
                  allUsers: filteredUsers,
                  index: index,
                  onTap: () => _onPatientTap(filteredUsers[index].sId ?? ''),
                ),
                separatorBuilder: (context, index) => 12.hs,
                itemCount: filteredUsers.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
