import 'dart:io';

import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/repositories/more_repo.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/manager/doctor_additions_state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/service_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorAdditionsCubit extends Cubit<DoctorAdditionsState> {
  final MoreRepo _moreRepo;

  DoctorAdditionsCubit(this._moreRepo) : super(InitState());

  static DoctorAdditionsCubit get(context) => BlocProvider.of(context);

  Future<void> uploadAdsData(String? link, File? image, int? period) async {
    emit(UploadLoadingState());

    try {
      await _moreRepo.uploadAdsData(link, image, period);
      await getAllAds();
      emit(UploadSuccessState());
    } catch (e) {
      print('Error during data upload: $e');
      emit(UploadErrorState(e.toString()));
    }
  }

  Future<void> getAllAds() async {
    emit(AdsLoadingState());
    try {
      final ads = await _moreRepo.fetchAllAds();
      emit(AdsSuccessState(ads));
    } catch (error) {
      emit(AdsErrorState(error.toString()));
    }
  }

  Future<void> deleteAd(String adId) async {
    emit(DeleteAdLoading());
    try {
      await _moreRepo.deleteAd(adId);
      await getAllAds();
      emit(DeleteAdSuccess());
    } catch (e) {
      emit(DeleteAdError(e.toString()));
    }
  }

  /// services functions
  Future<void> createService(String name, int price) async {
    emit(AddServiceLoading());
    try {
      await _moreRepo.createService(name, price);
      await fetchAllServices();
      emit(AddServiceSuccess('Service created successfully!'));
    } catch (e) {
      emit(AddServiceFailure('Failed to create service: $e'));
    }
  }

  Future<void> fetchAllServices() async {
    emit(GetServiceLoading());
    try {
      final services = await _moreRepo.getAllServices();
      emit(GetServiceSuccess(services));
    } catch (e) {
      emit(GetServiceError(e.toString()));
    }
  }

  Future<void> deleteService(String serviceId) async {
    emit(DeleteServiceLoading());
    try {
      await _moreRepo.deleteService(serviceId);
      await fetchAllServices();
      emit(DeleteServiceSuccess("service deleted successfully"));
    } catch (e) {
      emit(DeleteServiceFailure(e.toString()));
    }
  }

  void selectServiceForEditing(Service service) {
    emit(AddServicesScreenState(selectedService: service));
  }

  void clearSelectedService() {
    emit(AddServicesScreenState());
  }

  Future<void> updateService(String serviceId, String name, int price) async {
    emit(EditServiceLoading());
    try {
      await _moreRepo.editService(name, price, serviceId);
      await fetchAllServices();
      emit(EditServiceSuccess());
      clearSelectedService();
    } catch (e) {
      emit(EditServiceError(e.toString()));
    }
  }

  /// Hours Of Reservation
  Future<void> addHoursOfReservation(int numOfHours) async {
    emit(AddReservationsOfHourLoading());
    try {
      await _moreRepo.addHours(numOfHours);
      emit(AddReservationsOfHourSuccess());
      AppToaster.show("تم تحديد عدد بالساعة الحجوزات بنجاح");
    } catch (e) {
      ErrorAppToaster.show(e.toString());
      emit(AddReservationsOfHourError('Failed to add hours: $e'));
    }
  }
}
