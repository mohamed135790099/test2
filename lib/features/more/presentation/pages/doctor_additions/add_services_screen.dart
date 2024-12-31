import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_2.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/manager/doctor_additions_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/manager/doctor_additions_state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/service_model.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddServicesScreen extends StatefulWidget {
  const AddServicesScreen({super.key});

  @override
  State<AddServicesScreen> createState() => _AddServicesScreenState();
}

class _AddServicesScreenState extends State<AddServicesScreen> {
  final TextEditingController _servicesName = TextEditingController();
  final TextEditingController _servicesPrice = TextEditingController();

  Future<void> onRefresh() async {
    await DoctorAdditionsCubit.get(context).fetchAllServices();
  }

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await context.read<DoctorAdditionsCubit>().fetchAllServices();
  }

  void _updateTextControllers(Service service) {
    _servicesName.text = service.name ?? '';
    _servicesPrice.text = service.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorAdditionsCubit>();

    return BlocListener<DoctorAdditionsCubit, DoctorAdditionsState>(
      listener: (context, state) async {
        if (state is AddServiceSuccess ||
            state is EditServiceSuccess ||
            state is DeleteServiceSuccess) {
          _servicesName.clear();
          _servicesPrice.clear();

          await cubit.fetchAllServices();

          // Show success message
          AppToaster.show(state is AddServiceSuccess
              ? "Service added!"
              : state is EditServiceSuccess
                  ? "Service updated!"
                  : "Service deleted!");
        }
      },
      child: BlocBuilder<DoctorAdditionsCubit, DoctorAdditionsState>(
        builder: (context, state) {
          final isEditing =
              state is AddServicesScreenState && state.selectedService != null;
          final serviceToEdit = isEditing ? state.selectedService! : null;

          if (isEditing && serviceToEdit != null) {
            _updateTextControllers(serviceToEdit);
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: DefaultAppBar2(title: AppStrings.addServices),
            body: Stack(
              children: [
                // Main form content
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      AppTextField(
                        labelText: "إسم الخدمة",
                        isMultiLine: false,
                        controller: _servicesName,
                      ),
                      12.hs,
                      AppTextField(
                        labelText: "سعر الخدمة",
                        isMultiLine: false,
                        controller: _servicesPrice,
                        keyboardType: TextInputType.number,
                      ),
                      22.hs,
                      AppButton3(
                        isValid: true,
                        title: isEditing ? "تحديث الخدمة" : "إضافة الخدمة",
                        onPressed: () {
                          final name = _servicesName.text.trim();
                          final price =
                              int.tryParse(_servicesPrice.text.trim()) ?? 0;

                          if (name.isNotEmpty && price > 0) {
                            if (isEditing) {
                              cubit.updateService(
                                  serviceToEdit!.sId!, name, price);
                            } else {
                              cubit.createService(name, price);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please provide valid service name and price")),
                            );
                          }
                        },
                      ),
                      12.hs,
                      if (state is GetServiceSuccess)
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.services.length,
                            itemBuilder: (context, index) {
                              return _buildServiceCard(state.services[index]);
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                // Loading overlay
                if (state is AddServiceLoading ||
                    state is EditServiceLoading ||
                    state is DeleteServiceLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primaryBlue,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: IconButton(
            onPressed: () {
              context
                  .read<DoctorAdditionsCubit>()
                  .selectServiceForEditing(service);
            },
            icon: const Icon(
              Icons.edit,
              color: AppColor.primaryBlue,
            ),
          ),
        ),
        Expanded(
          flex: 12,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service.name ?? '',
                      style: AppTextStyle.font16black700,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${service.price} EGP',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: IconButton(
            onPressed: () {
              _deleteServices(service.sId ?? "");
            },
            icon: const Icon(
              Icons.delete,
              color: AppColor.red,
            ),
          ),
        ),
      ],
    );
  }

  void _deleteServices(String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
            title: Text('هل انت متاكد من حذف الخدمة ؟',
                style: AppTextStyle.font14primaryBlue500),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('إلغاء', style: AppTextStyle.font12black400),
              ),
              BlocBuilder<DoctorAdditionsCubit, DoctorAdditionsState>(
                builder: (context, state) {
                  if (state is DeleteServiceLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                      ),
                    );
                  } else if (state is DeleteServiceFailure) {
                    ErrorAppToaster.show(state.error);
                  }
                  return TextButton(
                    onPressed: () {
                      context
                          .read<DoctorAdditionsCubit>()
                          .deleteService(serviceId);
                      Navigator.of(context).pop();
                    },
                    child: Text('حذف', style: AppTextStyle.font12black400),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
