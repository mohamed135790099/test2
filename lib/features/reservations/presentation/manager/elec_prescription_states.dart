import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_electronic_prescription.dart';

class ElectronicPrescriptionStates {}

class InitialState extends ElectronicPrescriptionStates {}

class CreatePrescriptionMedicineLoadingState
    extends ElectronicPrescriptionStates {}

class CreatePrescriptionMedicineSuccessState
    extends ElectronicPrescriptionStates {
  final Map<String, dynamic> response;

  CreatePrescriptionMedicineSuccessState(this.response);
}

class CreatePrescriptionMedicineErrorState
    extends ElectronicPrescriptionStates {
  final String error;

  CreatePrescriptionMedicineErrorState(this.error);
}

class GetAllMedicinesLoadingState extends ElectronicPrescriptionStates {}

class GetAllMedicinesSuccessState extends ElectronicPrescriptionStates {
  final List<Map<String, dynamic>> medicines;

  GetAllMedicinesSuccessState(this.medicines);
}

class GetAllMedicinesErrorState extends ElectronicPrescriptionStates {
  final String error;

  GetAllMedicinesErrorState(this.error);
}

class PrescriptionLoading extends ElectronicPrescriptionStates {}

class PrescriptionSuccess extends ElectronicPrescriptionStates {
  final Map<String, dynamic> data;

  PrescriptionSuccess(this.data);
}

class PrescriptionError extends ElectronicPrescriptionStates {
  final String error;

  PrescriptionError(this.error);
}

class PrescriptionLoadingState extends ElectronicPrescriptionStates {}

class PrescriptionSuccessState extends ElectronicPrescriptionStates {
  final List<GetUserElectronicPrescription> prescriptions;

  PrescriptionSuccessState(this.prescriptions);

  @override
  List<Object?> get props => [prescriptions];
}

class PrescriptionErrorState extends ElectronicPrescriptionStates {
  final String error;

  PrescriptionErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class ElectronicPrescriptionLoading extends ElectronicPrescriptionStates {}

class ElectronicPrescriptionSuccess extends ElectronicPrescriptionStates {}

class ElectronicPrescriptionError extends ElectronicPrescriptionStates {}
