import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_2.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_prescription.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/elec_prescription_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/prescriptions_widgets/add_new_prescription.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/prescriptions_widgets/prescriptions_card.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrescriptionsList extends StatefulWidget {
  final String patientId;

  const PrescriptionsList({super.key, required this.patientId});

  @override
  State<PrescriptionsList> createState() => _PrescriptionsListState();
}

class _PrescriptionsListState extends State<PrescriptionsList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await context
        .read<ReservationCubit>()
        .getUserReservations(widget.patientId);
    if (!mounted) return;
    await context.read<ReservationCubit>().getUserDetails(widget.patientId);
    String? userId = context.read<ReservationCubit>().getUserDetail?.sId;
    if (userId != null && userId.isNotEmpty) {
      await context
          .read<ElectronicPrescriptionCubit>()
          .getElectronicPrescriptions(userId);
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.all(4),
      height: 500,
      child: Column(
        children: [
          Row(
            children: [
              _buildTabButton('روشتة عادية', 1),
              // _buildTabButton('روشتة إليكترونية', 0),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// code Of Electronic Prescription
                // BlocBuilder<ElectronicPrescriptionCubit,
                //     ElectronicPrescriptionStates>(
                //   builder: (context, state) {
                //     if (state is PrescriptionLoadingState) {
                //       return const Center(
                //           child: CircularProgressIndicator(
                //         color: AppColor.primaryBlue,
                //       ));
                //     } else if (state is PrescriptionSuccessState) {
                //       final electronicPrescriptions = state.prescriptions;
                //
                //       return Column(children: [
                //         Expanded(
                //           child: Column(
                //             children: [
                //               SizedBox(
                //                 height: 400.h,
                //                 child: ListView.separated(
                //                   padding:
                //                       EdgeInsets.only(bottom: 50.h, top: 20.h),
                //                   shrinkWrap: true,
                //                   itemBuilder: (context, index) =>
                //                       ElectronicPrescriptionsCard(
                //                     userElectronicPrescription:
                //                         electronicPrescriptions,
                //                     index: index,
                //                   ),
                //                   separatorBuilder: (context, index) => 12.hs,
                //                   itemCount: electronicPrescriptions.length,
                //                 ),
                //               ),
                //               AppButton2(
                //                 title: AppStrings.uploadElectricPrescription,
                //                 onPressed: () {
                //                   Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) =>
                //                               UploadElectricPrescription(
                //                                   patientId:
                //                                       widget.patientId)));
                //                 },
                //               ),
                //             ],
                //           ),
                //         )
                //       ]);
                //     } else if (state is PrescriptionErrorState) {
                //       return Center(child: Text(state.error));
                //     }
                //     return Container();
                //   },
                // ),

                // Regular Prescription Tab
                BlocBuilder<ReservationCubit, ReservationState>(
                  builder: (context, state) {
                    final List<GetUserPrescription> userPrescription =
                        ReservationCubit.get(context).userPrescriptions;

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 50.h, top: 20.h),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => PrescriptionsCard(
                              userPrescription: userPrescription,
                              index: index,
                            ),
                            separatorBuilder: (context, index) => 12.hs,
                            itemCount: userPrescription.length,
                          ),
                        ),
                        AppButton2(
                          title: AppStrings.addPrescriptions,
                          onPressed: () {
                            showModalBottomSheet(
                              isDismissible: false,
                              context: context,
                              builder: (context) => const AddNewPrescription(),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabSelected(index),
        child: Container(
          decoration: BoxDecoration(
              color: isSelected ? Colors.grey : Colors.white,
              borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
