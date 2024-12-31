import 'package:dr_mohamed_salah_admin/features/reservations/data/repositories/reservations_repo.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/manager/states.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/patient_history.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientDetailsCubit extends Cubit<PatientHistoryState> {
  final ReservationsRepo _reservationsRepo;

  PatientDetailsCubit(this._reservationsRepo) : super(PatientHistoryInitial());

  static PatientDetailsCubit get(context) => BlocProvider.of(context);

  Future<void> getPatientData(String patientId) async {
    emit(PatientHistoryLoading());

    final result = await _reservationsRepo.getPatientData(patientId);
    result.fold(
      (data) {
        final patientHistory = PatientHistory.fromJson(data['patientHistory']);
        emit(PatientHistoryLoaded(patientHistory));
      },
      (failure) {
        emit(PatientHistoryError(failure.message));
      },
    );
  }

  Future<void> updatePatientHistory(
      String patientId, PatientHistory patientHistory) async {
    emit(PatientHistoryLoading());

    final result =
        await _reservationsRepo.putPatientData(patientId, patientHistory);
    result.fold(
      (data) async {
        emit(PatientHistoryUpdated(data['message']));
        await getPatientData(patientId);
      },
      (failure) {
        emit(PatientHistoryError(failure.message));
      },
    );
  }
}
