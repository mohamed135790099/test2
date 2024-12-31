import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/elec_prescription_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/elec_prescription_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadElectricPrescription extends StatefulWidget {
  final String patientId;

  const UploadElectricPrescription({super.key, required this.patientId});

  @override
  State<UploadElectricPrescription> createState() =>
      _UploadElectricPrescriptionState();
}

class _UploadElectricPrescriptionState
    extends State<UploadElectricPrescription> {
  final List<Map<String, dynamic>> _prescriptions = [];
  String? _selectedMedicine;
  final TextEditingController _timesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ElectronicPrescriptionCubit>().getAllMedicines();
  }

  void _addNewMedicine() {
    final TextEditingController newMedicineController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
            title: const Text('إضافة دواء جديد'),
            content: TextField(
              controller: newMedicineController,
              decoration:
                  const InputDecoration(hintText: 'Enter medicine name'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: AppTextStyle.font16primaryBlue600),
              ),
              BlocBuilder<ElectronicPrescriptionCubit,
                  ElectronicPrescriptionStates>(
                builder: (context, state) {
                  if (state is PrescriptionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                      ),
                    );
                  } else if (state is PrescriptionError) {
                    ErrorAppToaster.show(state.error);
                  }

                  return TextButton(
                    onPressed: () {
                      final newMedicine = newMedicineController.text.trim();
                      if (newMedicine.isNotEmpty) {
                        context
                            .read<ElectronicPrescriptionCubit>()
                            .createMedicine(newMedicine);
                        Navigator.of(context).pop();
                      }
                    },
                    child:
                        Text('Add', style: AppTextStyle.font16primaryBlue600),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _uploadFullPrescription() {
    if (_prescriptions.isEmpty) {
      ErrorAppToaster.show('No prescriptions added');
      return;
    }

    final formattedPrescriptions = _prescriptions.map((prescription) {
      return {
        'medicin': prescription['medicin'],
        'dosage': prescription['dosage'],
        'food': prescription['food'],
        'details': prescription['details']
      };
    }).toList();

    context.read<ElectronicPrescriptionCubit>().uploadPrescription(
          widget.patientId,
          formattedPrescriptions,
        );
  }

  String? _selectedFoodTiming;

  void _addPrescription() {
    if (_selectedMedicine != null && _timesController.text.isNotEmpty) {
      setState(() {
        _prescriptions.add({
          'medicin': _selectedMedicine!,
          'dosage': int.tryParse(_timesController.text) ?? 1,
          'food': _selectedFoodTiming == 'قبل الأكل'
              ? 'before'
              : _selectedFoodTiming == 'بعد الأكل'
                  ? 'after'
                  : _selectedFoodTiming == 'أخرى'
                      ? "other"
                      : "",
          'details': _notesController.text
        });
        _selectedMedicine = null;
        _timesController.clear();
        _notesController.clear();
        _selectedFoodTiming = null;
      });
    } else {
      ErrorAppToaster.show('Please enter medicine name and dosage.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                decoration: BoxDecoration(
                  color: const Color(0x14008E0E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "إضافة روشتة إليكترونية",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.height * .72,
              child: ListView(
                children: [
                  AppButton3(
                    onPressed: _addNewMedicine,
                    title: 'إضافة دواء جديد',
                    isValid: true,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ElectronicPrescriptionCubit,
                      ElectronicPrescriptionStates>(
                    builder: (context, state) {
                      if (state is GetAllMedicinesLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryBlue,
                          ),
                        );
                      }

                      if (state is GetAllMedicinesErrorState) {
                        return Center(
                          child: Text(
                            'Error fetching medicines: ${state.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (state is GetAllMedicinesSuccessState) {
                        final medicines = state.medicines
                            .map((e) => {'id': e['_id'], 'title': e['title']})
                            .toList();

                        if (medicines.isEmpty) {
                          return const Center(
                            child: Text('No medicines available'),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedMedicine,
                              hint: const Text('إختر إسم الدواء '),
                              items: medicines.map((medicine) {
                                return DropdownMenuItem<String>(
                                  value: medicine['id'],
                                  child: Text(medicine['title']!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMedicine = value;
                                });
                              },
                            ),
                            const SizedBox(height: 4),
                            AppTextField(
                              keyboardType: TextInputType.number,
                              controller: _timesController,
                              hintText: 'عدد المرات',
                              inputFormatter: [
                                RangeTextInputFormatter(),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text('الوقت :'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio<String>(
                                  value: 'قبل الأكل',
                                  groupValue: _selectedFoodTiming,
                                  activeColor: AppColor.primaryBlue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedFoodTiming = value;
                                    });
                                  },
                                ),
                                const Text('قبل الأكل'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio<String>(
                                  value: 'بعد الأكل',
                                  groupValue: _selectedFoodTiming,
                                  activeColor: AppColor.primaryBlue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedFoodTiming = value;
                                    });
                                  },
                                ),
                                const Text('بعد الأكل'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio<String>(
                                  value: 'أخرى',
                                  groupValue: _selectedFoodTiming,
                                  activeColor: AppColor.primaryBlue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedFoodTiming = value;
                                    });
                                  },
                                ),
                                const Text('أخرى'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('ملاحظات أخري (إختياري) :'),
                            AppTextField(
                              isMultiLine: true,
                              controller: _notesController,
                            ),
                            const SizedBox(height: 12),
                            AppButton3(
                              onPressed: _addPrescription,
                              title: 'إضافة الجرعة',
                              isValid: true,
                            ),
                          ],
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                  Container(
                      margin: const EdgeInsetsDirectional.all(4),
                      child: const Text('الجرعات المضافة')),
                  Container(
                    padding: const EdgeInsetsDirectional.all(10),
                    margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(width: 2, color: AppColor.primaryBlue)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _prescriptions.length,
                      itemBuilder: (context, index) {
                        final prescription = _prescriptions[index];
                        return Card(
                          child: ListTile(
                            title: Text(prescription['medicin']),
                            subtitle: Text(
                                'Times: ${prescription['dosage']} - ${prescription['food']}\n ${prescription['details']}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<ElectronicPrescriptionCubit,
                ElectronicPrescriptionStates>(
              builder: (context, state) {
                if (state is PrescriptionLoading) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColor.primaryBlue),
                  );
                }
                if (state is PrescriptionSuccess) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.of(context).pop();
                  });
                  return const Center(
                    child: Text(
                      'تم رفع الروشتة بنجاح',
                      style: TextStyle(color: AppColor.primaryBlue),
                    ),
                  );
                }
                if (state is PrescriptionError) {
                  print("Error uploading prescription: ${state.error}");
                  return Center(
                    child: Text(
                      'Error uploading prescription: ${state.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return AppButton3(
                  onPressed: _uploadFullPrescription,
                  title: 'رفع الروشتة بالكامل',
                  isValid: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final int? value = int.tryParse(newValue.text);
    if (value == null || value < 1 || value > 10) {
      return oldValue;
    }
    return newValue;
  }
}
