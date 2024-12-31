import 'package:dr_mohamed_salah_admin/features/reservations/data/models/electronic_prescription_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_electronic_prescription.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/repositories/electronic_prescription_repo.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/elec_prescription_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ElectronicPrescriptionCubit extends Cubit<ElectronicPrescriptionStates> {
  final ElectronicPrescriptionRepo _repo;

  ElectronicPrescriptionCubit(this._repo) : super(InitialState());

  static ElectronicPrescriptionCubit get(context) => BlocProvider.of(context);

  Future<void> createMedicine(String title) async {
    emit(CreatePrescriptionMedicineLoadingState());

    try {
      final response = await _repo.createMedicine(title);
      emit(CreatePrescriptionMedicineSuccessState(response));
      await getAllMedicines();
    } catch (error) {
      emit(CreatePrescriptionMedicineErrorState(error.toString()));
    }
  }

  Future<void> getAllMedicines() async {
    emit(GetAllMedicinesLoadingState());

    try {
      final medicines = await _repo.getAllMedicines();
      emit(GetAllMedicinesSuccessState(medicines));
    } catch (error) {
      emit(GetAllMedicinesErrorState(error.toString()));
    }
  }

  Future<void> uploadPrescription(
      String? patientId, List<Map<String, dynamic>>? roshta) async {
    emit(PrescriptionLoading());

    try {
      if (patientId == null || roshta == null) {
        throw Exception('Invalid input: patientId or roshta is null');
      }
      final response = await _repo.uploadPrescription(patientId, roshta);
      if (response != null) {
        emit(PrescriptionSuccess(response));
      } else {
        throw Exception('Failed to upload prescription');
      }
    } catch (error) {
      emit(PrescriptionError(error.toString()));
    }
  }

  Future<void> getElectronicPrescriptions(String patientId) async {
    emit(PrescriptionLoadingState());
    try {
      final List<GetUserElectronicPrescription> prescriptions =
          await _repo.fetchElectronicPrescriptions(patientId);
      emit(PrescriptionSuccessState(prescriptions));
    } catch (error) {
      emit(PrescriptionErrorState(error.toString()));
    }
  }

  ElectronicPrescription? getUserElectronicPrescription;

  Future<ElectronicPrescription?> getElectronicPrescriptionById(
      String id) async {
    emit(ElectronicPrescriptionLoading());
    final result = await _repo.getElectronicPrescriptionById(id);
    return result.fold(
      (failure) {
        emit(ElectronicPrescriptionError());
        return null;
      },
      (prescription) {
        getUserElectronicPrescription = prescription;
        emit(ElectronicPrescriptionSuccess());
        return prescription;
      },
    );
  }
}
