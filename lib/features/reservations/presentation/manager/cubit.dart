import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/error_app_toaster.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/models/get_all_users.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/data/models/conversations_model.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/data/models/message_history_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/service_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/create_reservations_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_all_reservations.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_one_analysis.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_one_medicine.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_one_prescription.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_one_xray.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_analysis.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_details.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_medicine.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_prescription.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_reservations.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_xray.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/last_reservation_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/one_reservation.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/repositories/reservations_repo.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/world_time_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/model/failure.dart';
import '../../../home/data/model/new_reservation_model.dart';

class ReservationCubit extends Cubit<ReservationState> {
  final ReservationsRepo _reservationsRepo;

  ReservationCubit(this._reservationsRepo) : super(ReservationInitial());

  static ReservationCubit get(context) => BlocProvider.of(context);

  Future<void> addAdditionalServices(
      String reservationId, Map<String, dynamic> services) async {
    emit(AddServiceLoading());
    try {
      final message = await _reservationsRepo.addAdditionalServices(
          reservationId, services);
      emit(AddServiceSuccess(message));
    } catch (e) {
      emit(AddServiceError(e.toString()));
    }
  }

  List<Service> services = [];

  Future<void> fetchAllServices() async {
    emit(ServiceLoading());
    try {
      services = await _reservationsRepo.getAllServices();
      emit(ServiceSuccess(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> updatePaidStatus(String id, bool isPaid) async {
    emit(EditPaidStateLoading());
    try {
      await _reservationsRepo.payInClinicReservations(id, isPaid);
      emit(EditPaidStateSuccess());
    } on DioException catch (e) {
      emit(EditPaidStateError(e.message ?? ""));
    } catch (e) {
      emit(EditPaidStateError('An unexpected error occurred'));
    }
  }

  Future<void> deletePrescription(
      String prescriptionId, String patientId) async {
    emit(DeletePrescriptionLoading());
    try {
      await _reservationsRepo.deletePrescription(prescriptionId);
      await getUserReservations(patientId);
      emit(DeletePrescriptionSuccess());
    } catch (e) {
      emit(DeletePrescriptionError(e.toString()));
    }
  }

  Future<void> deleteAnalysis(String analysisId, String patientId) async {
    emit(DeleteAnalysisLoading());
    try {
      await _reservationsRepo.deleteAnalysis(analysisId);
      await getUserReservations(patientId);
      emit(DeleteAnalysisSuccess());
    } catch (e) {
      emit(DeleteAnalysisError(e.toString()));
    }
  }

  Future<void> deleteMedicine(String medicineId, String patientId) async {
    emit(DeleteMedicineLoading());
    try {
      await _reservationsRepo.deleteMedicine(medicineId);
      await getUserReservations(patientId);
      emit(DeleteMedicineSuccess());
    } catch (e) {
      emit(DeleteMedicineError(e.toString()));
    }
  }

  Future<void> deleteXRay(String xrayId, String patientId) async {
    emit(DeleteXRayLoading());
    try {
      await _reservationsRepo.deleteXRay(xrayId);
      await getUserReservations(patientId);
      emit(DeleteXRaySuccess());
    } catch (e) {
      emit(DeleteXRayError(e.toString()));
    }
  }

  /////////////////////////////////////
  Future<void> updatePatientDetails(
      String id, String name, String phone) async {
    try {
      emit(UpdatePatientDetailsLoading());
      final response =
          await _reservationsRepo.updatePatientDetails(id, name, phone);
      if (response['success']) {
        await getUserDetails(id);
        await getAllUsers();
        emit(UpdatePatientDetailsSuccess(response['message']));
      } else {
        emit(UpdatePatientDetailsError(response['message']));
      }
    } catch (e) {
      emit(UpdatePatientDetailsError(
          'Failed to update patient details: ${e.toString()}'));
    }
  }

  List<MessageHistoryModel> allMessages = [];

  Future<void> getConversationMessages(String id) async {
    emit(GetOneConversationLoading());
    final result = await _reservationsRepo.getConversationMessages(id);
    result.fold(
      (data) {
        final allMessage = data["messages"];
        if (allMessage != null) {
          allMessages = allMessage
              .map<MessageHistoryModel>((e) => MessageHistoryModel.fromJson(e))
              .toList();
        }
        emit(GetOneConversationSuccess());
      },
      (failure) => emit(GetOneConversationError()),
    );
  }

  Future<void> sendMessage(String id, String message) async {
    emit(SendMessageLoading());
    final result = await _reservationsRepo.sendMessage(id, message);
    result.fold(
      (data) async {
        emit(SendMessageSuccess());
        await getConversationMessages(id);
      },
      (failure) => emit(SendMessageError(failure.toString())),
    );
  }

  String? _Id;
  String? _Name;

  String? get patientId => _Id;

  String? get patientUserName => _Name;

  setPickModelForId(GetAllUsers? PatientID) {
    _Id = PatientID?.sId;
    _Name = PatientID?.fullName;
    emit(GetPatientID());
  }

  /////////////////////////////////////

  Future<void> fetchHours(String date) async {
    emit(ReservationHoursLoading());
    try {
      final hours = await _reservationsRepo.getAvailableHours(date);
      if (hours.isNotEmpty) {
        emit(ReservationHoursLoaded(hours));
      } else {
        emit(ReservationHoursError("Error fetching hours"));
      }
    } catch (e) {
      print('Error fetching hours: $e');
      emit(ReservationHoursError(e.toString()));
    }
  }

  var picker = ImagePicker();

  CreateReservationsResponse? createReservationsResponse;


  Future<dynamic> createReservations(String patientId, String date, String time,
      String price, String reservType) async {
    emit(CreateReservationLoading());
    final result = await _reservationsRepo.createReservations(
        patientId, date, time, price, reservType);

    return result.fold(
          (response) async {
        createReservationsResponse = CreateReservationsResponse.fromJson(response['reservation']);
        final currentDateTime = await _worldTimeService.getCurrentDateTime();
        final formattedDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
        await fetchReservations(formattedDate,"pending");
        emit(CreateReservationSuccess());
        return true; // Indicate success
      },
          (failure) {
        String errorMessage = failure.message;
        emit(CreateReservationError(errorMessage));
        return errorMessage; // Return the error message
      },
    );
  }

///////////////////////////////////////////////////////////////////////////

  List<XFile>? _prescriptionImage;

  List<XFile>? get prescriptionImage => _prescriptionImage;

  Future<void> getPrescriptionImage(BuildContext context) async {
    emit(GetPrescriptionImageLoading());

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    _prescriptionImage ??= [];

    if (_prescriptionImage!.length >= 5) {
      ErrorAppToaster.show("من فضلك إختر حتي 5 صور فقط");
      emit(GetPrescriptionImageError());
      return;
    }

    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _prescriptionImage!.add(pickedFile);
      emit(GetPrescriptionImageSuccess());
    } else {
      emit(GetPrescriptionImageError());
    }
  }

  void removePrescriptionImage(XFile image) {
    _prescriptionImage?.remove(image);
    emit(GetPrescriptionImageSuccess());
  }

  Future<void> createPrescription(
      String title, String content, String id) async {
    emit(CreatePrescriptionLoading());

    final result = await _reservationsRepo.createPrescription(
        title, prescriptionImage, content, id);
    result.fold(
      (data) {
        getUserReservations(id);
        emit(CreatePrescriptionSuccess());
      },
      (failure) {
        print((failure.message));
        emit(CreatePrescriptionError(failure.message));
      },
    );
  }

  Future<void> editPrescription(String patientId, String prescriptionId,
      String? title, String? content) async {
    emit(EditPrescriptionLoading());
    try {
      await _reservationsRepo.updatePrescription(
          patientId, prescriptionId, title, content, _prescriptionImage);
      emit(EditPrescriptionSuccess());
      await getOnePrescription(prescriptionId);
    } catch (e) {
      print("Error during edit: ${e.toString()}");
      emit(EditPrescriptionError(e.toString()));
    }
  }

  void clearPrescriptionImage() {
    _prescriptionImage = [];
    emit(PrescriptionImageCleared());
  }

  ////////////////////////////////////////////////////////////////////
  List<XFile>? _xRayImage;

  List<XFile>? _xrayPdfFile;

  List<XFile>? get xPdfFile => _xrayPdfFile;

  List<XFile>? get xRayImage => _xRayImage;

  Future<void> createXRay(String title, String content, String userId) async {
    emit(CreateXRayLoading());

    final result = await _reservationsRepo.createXRay(
        title, content, _xrayPdfFile, _xRayImage, userId);

    result.fold(
      (data) async {
        emit(CreateXRaySuccess());
        _xrayPdfFile?.clear();
        await getUserReservations(userId);
      },
      (failure) {
        emit(CreateXRayError(failure.message));
        print(failure.message);
      },
    );
  }

  Future<void> editXRay(
      String patientId, String xrayId, String? title, String? content) async {
    emit(EditXRayLoading());
    try {
      await _reservationsRepo.updateXRay(
          xrayId, title, content, _xrayPdfFile, _xRayImage);
      emit(EditXRaySuccess());
      await getOneXRay(xrayId);
    } catch (e) {
      print("Error during edit: ${e.toString()}");
      emit(EditXRayError(e.toString()));
    }
  }

  Future<void> getXRayImage(BuildContext context) async {
    emit(GetPrescriptionImageLoading());

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickXRayImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickXRayImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickXRayImage(ImageSource source) async {
    final picker = ImagePicker();

    _xRayImage ??= [];

    if (_xRayImage!.length >= 5) {
      ErrorAppToaster.show("من فضلك إختر حتي 5 صور فقط");
      emit(GetXRayImageError());
      return;
    }

    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _xRayImage!.add(pickedFile);
      emit(GetXRayImageSuccess());
    } else {
      emit(GetXRayImageError());
    }
  }

  Future<void> getXrayPdfFile() async {
    emit(GetXPdfFileLoading());

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      _xrayPdfFile = result.files.map((file) => XFile(file.path!)).toList();
      AppToaster.show("تم رفع الملف بنجاح");
      emit(GetXPdfFileSuccess());
    } else {
      emit(GetXPdfFileError());
    }
  }

  void removeXRayImage(XFile image) {
    _xRayImage?.remove(image);
    emit(GetXRayImageSuccess());
  }

  void clearXRayImage() {
    _xRayImage = null;
    emit(XRayImageCleared());
  }

///////////////////////////////////////////////////////////////////////

  List<XFile>? _analysisImage;

  List<XFile>? get analysisImage => _analysisImage;

  set analysisImage(List<XFile>? value) {
    _analysisImage = value;
  }

  List<XFile>? _analysisPdfFile;

  List<XFile>? get analysisPdfFile => _analysisPdfFile;

  Future<void> createAnalysis(String title, String content, String id) async {
    emit(CreateAnalysisLoading());

    final result = await _reservationsRepo.createAnalysis(
        title, content, _analysisPdfFile, _analysisImage, id);

    result.fold(
      (data) async {
        emit(CreateAnalysisSuccess());
        _analysisPdfFile?.clear();
        await getUserReservations(id);
      },
      (failure) {
        emit(CreateAnalysisError(failure.message));
        print(failure.message);
      },
    );
  }

  Future<void> editAnalysis(
      String analysisId, String? title, String? content) async {
    emit(EditAnalysisLoading());
    try {
      await _reservationsRepo.updateAnalysis(
          analysisId, title, content, _analysisPdfFile, _analysisImage);
      emit(EditAnalysisSuccess());
      await getOneAnalysis(analysisId);
    } catch (e) {
      print("Error during edit: ${e.toString()}");
      emit(EditAnalysisError(e.toString()));
    }
  }

  Future<void> getAnalysisPdfFile() async {
    emit(GetAnalysisPdfFileLoading());

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      _analysisPdfFile = result.files.map((file) => XFile(file.path!)).toList();
      AppToaster.show("تم رفع الملف بنجاح");
      emit(GetAnalysisPdfFileSuccess());
    } else {
      emit(GetAnalysisPdfFileError());
    }
  }

  Future<void> getAnalysisImage(BuildContext context) async {
    emit(GetAnalysisImageLoading());

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickAnalysisImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickAnalysisImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAnalysisImage(ImageSource source) async {
    final picker = ImagePicker();

    _analysisImage ??= [];

    if (_analysisImage!.length >= 5) {
      ErrorAppToaster.show("من فضلك إختر حتي 5 صور فقط");
      emit(GetAnalysisImageLoading());
      return;
    }

    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _analysisImage!.add(pickedFile);
      emit(GetAnalysisImageSuccess());
    } else {
      emit(GetAnalysisImageError());
    }
  }

  void removeAnalysisImage(XFile image) {
    _analysisImage?.remove(image);
    emit(GetAnalysisImageSuccess());
  }

  void clearAnalysisImage() {
    _analysisImage = null;
    emit(AnalysisImageCleared());
  }

  ///////////////////////////////////////////////////////////////
  List<XFile>? _medicinesImage;

  List<XFile>? get medicinesImage => _medicinesImage;

  void removeMedicinesImage(XFile image) {
    _medicinesImage?.remove(image);
    emit(GetMedicinesImageSuccess());
  }

  Future<void> getMedicineImage(BuildContext context) async {
    emit(GetPrescriptionImageLoading());

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickMedicineImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickMedicineImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMedicineImage(ImageSource source) async {
    final picker = ImagePicker();

    _medicinesImage ??= [];

    if (_medicinesImage!.length >= 5) {
      ErrorAppToaster.show("من فضلك إختر حتي 5 صور فقط");
      emit(GetPrescriptionImageError());
      return;
    }

    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _medicinesImage!.add(pickedFile);
      emit(GetPrescriptionImageSuccess());
    } else {
      emit(GetPrescriptionImageError());
    }
  }

  Future<void> createMedicine(String title, String content, String id) async {
    emit(CreateMedicineLoading());

    final result = await _reservationsRepo.createMedicine(
        title, medicinesImage, content, id);
    result.fold(
      (data) {
        getUserReservations(id);
        emit(CreateMedicineSuccess());
      },
      (failure) {
        print((failure.message));
        emit(CreateMedicineError(failure.message));
      },
    );
  }

  Future<void> editMedicine(
      String medicineId, String? title, String? content) async {
    emit(EditMedicineLoading());
    try {
      if (_medicinesImage != null) {
        await _reservationsRepo.updateMedicine(
            medicineId, title, content, _medicinesImage);
      } else {
        emit(EditMedicineError("No image selected"));
        return;
      }
      emit(EditMedicineSuccess());
      await getOneMedicine(medicineId);
    } catch (e) {
      print("Error during edit: ${e.toString()}");
      emit(EditMedicineError(e.toString()));
    }
  }

  void clearMedicineImage() {
    _medicinesImage = null;
    emit(MedicineImageCleared());
  }

  ////////////////////////////////////////////////////////////////////////////
  Future<void> createUserByAdmin(
      String userName, String phone, String gender) async {
    emit(CreateUserByAdminLoading());

    final result =
        await _reservationsRepo.createUserByAdmin(userName, phone, gender);

    result.fold((response) async {
      AppToaster.show("User created successfully");
      await getAllUsers();
      emit(CreateUserByAdminSuccess());
      RouterApp.pushNamedAndRemoveUntil(RouteName.mainScreen);
    }, (failure) {
      ErrorAppToaster.show("Error: ${failure.message}");
      emit(CreateUserByAdminError(failure));
    });
  }

  List<ConversationsModel> allConversations = [];

  Future<void> getAdminAllConversations() async {
    emit(GetAllConversationLoading());
    final result = await _reservationsRepo.getAdminAllConversations();
    result.fold(
      (l) async {
        final allChat = l["conversations"];
        if (allChat != null) {
          allConversations = allChat
              .map<ConversationsModel>((e) => ConversationsModel.fromJson(e))
              .toList();
        }
        emit(GetAllConversationSuccess());
      },
      (r) => emit(GetAllConversationError()),
    );
  }

  List<GetAllReservations> allReservations = [];

  Future<void> getAllReservations() async {
    emit(GetAllReservationsLoading());

    final result = await _reservationsRepo.getAllReservations();
    result.fold(
      (l) async {
        final allReservation = l["reservations"];
        if (allReservation != null) {
          allReservations = allReservation
              .map<GetAllReservations>((e) => GetAllReservations.fromJson(e))
              .toList();
        }

        emit(GetAllReservationsSuccess());
      },
      (r) => emit(GetAllReservationsError()),
    );
  }

  OneReservation? oneReservations;

  Future<void> getOneReservations(String id) async {
    emit(GetOneReservationsLoading());
    final result = await _reservationsRepo.getOneReservations(id);
    result.fold(
      (l) async {
        oneReservations = OneReservation.fromJson(l["reservation"]);
        emit(GetOneReservationsSuccess());
      },
      (r) => emit(GetOneReservationsError()),
    );
  }

  /// New Fun For get last reservation
  List<Reservation> lastReservations = [];

  Future<void> getLastUserReservations(String id, String date) async {
    emit(GetLastReservationsLoading());

    final result = await _reservationsRepo.getUserLastReservations(id, date);

    result.fold(
      (data) {
        final reservations = data.reservations ?? [];
        emit(GetLastReservationsSuccess(reservations));
      },
      (error) {
        emit(GetLastReservationsError(error));
      },
    );
  }

  ///////////////////////////////////////
  DateTime? reservationSelectedDate;

  void setDateReservation(DateTime date) {
    reservationSelectedDate = date;
    getReservationsByDate(date);
  }

  Future<void> getReservationsByDate(DateTime date) async {
    emit(GetReservationsByDateLoading());
    final result = await _reservationsRepo.getAllReservations();
    result.fold(
      (l) async {
        final allReservation = l["reservations"];
        if (allReservation != null) {
          allReservations = allReservation
              .map<GetAllReservations>((e) => GetAllReservations.fromJson(e))
              .toList();
          emit(GetReservationsByDateSuccess());
        }
      },
      (r) => emit(GetReservationsByDateError()),
    );
  }

  ////////////////////////////////////////////
  GetOneAnalysis? getUserAnalysis;

  Future<void> getOneAnalysis(String id) async {
    emit(GetOneAnalysisLoading());
    final result = await _reservationsRepo.getOneAnalysis(id);
    result.fold(
      (l) async {
        getUserAnalysis = GetOneAnalysis.fromJson(l["Ta7lil"]);
        emit(GetOneAnalysisSuccess());
      },
      (r) => emit(GetOneAnalysisError()),
    );
  }

  GetOnePrescription? getUserPrescription;

  Future<void> getOnePrescription(String id) async {
    emit(GetOnePrescriptionLoading());
    final result = await _reservationsRepo.getOnePrescription(id);
    result.fold(
      (l) async {
        getUserPrescription = GetOnePrescription.fromJson(l["roshta"]);
        emit(GetOnePrescriptionSuccess());
      },
      (r) => emit(GetOnePrescriptionError()),
    );
  }

  GetOneMedicine? getUserMedicine;

  Future<void> getOneMedicine(String id) async {
    emit(GetOneMedicineLoading());
    final result = await _reservationsRepo.getOneMedicine(id);
    result.fold(
      (l) async {
        getUserMedicine = GetOneMedicine.fromJson(l["Medicin"]);
        emit(GetOneMedicineSuccess());
      },
      (r) => emit(GetOneMedicineError()),
    );
  }

  GetOneXRay? getUserXRay;

  Future<void> getOneXRay(String id) async {
    emit(GetOneXRayLoading());
    final result = await _reservationsRepo.getOneXRay(id);
    result.fold(
      (l) async {
        getUserXRay = GetOneXRay.fromJson(l["Ashe3a"]);
        emit(GetOneXRaySuccess());
      },
      (r) => emit(GetOneXRayError()),
    );
  }

  UserModel? getUserDetail;

  Future<void> getUserDetails(String id) async {
    emit(GetUserDetailsLoading());
    final result = await _reservationsRepo.getUserDetails(id);
    result.fold(
      (l) async {
        if (l.containsKey("users")) {
          getUserDetail = UserModel.fromJson(l["users"]);
          emit(GetUserDetailsSuccess());
        } else {
          emit(GetUserDetailsError());
          print("Error: 'users' key not found in API response");
        }
      },
      (r) {
        emit(GetUserDetailsError());
        print("Error: $r"); // Print the error if the API call fails
      },
    );
  }

  Future<void> cancelReservations(String id) async {
    emit(CancelReservationsLoading());
    final result = await _reservationsRepo.cancelReservations(id);
    result.fold(
      (l) async {
        emit(CancelReservationsSuccess());
      },
      (r) => emit(CancelReservationsError()),
    );
  }

  Future<void> confirmReservations(String id) async {
    emit(ConfirmReservationsLoading());
    final result = await _reservationsRepo.confirmReservations(id);
    result.fold(
      (l) async {
        getAllReservations();
        emit(ConfirmReservationsSuccess());
      },
      (r) => emit(ConfirmReservationsError()),
    );
  }

  Future<void> getAllUserReservationsWithoutCanceled() async {
    emit(GetAllReservationsLoading());
    final result = await _reservationsRepo.getAllReservations();
    result.fold(
      (data) async {
        final reservations = data["reservations"] as List<dynamic>?;
        if (reservations != null) {
          allReservations = reservations
              .map<GetAllReservations>((e) => GetAllReservations.fromJson(e))
              .where((reservation) => reservation.status != "canceled")
              .toList();
        }
        emit(GetAllReservationsSuccess());
        return reservations;
      },
      (failure) => emit(GetAllReservationsError()),
    );
  }

  //////////////////////////////////////////////////////////////////////////////////

  final WorldTimeService _worldTimeService = WorldTimeService();
  DateTime initialDate = DateTime.now();

  Future<DateTime> getIntialDate() async {
    var initialDate = await _worldTimeService.getCurrentDateTime();
    return initialDate;
  }

  Future<void> updateReservations(String id, String date, String time) async {
    emit(GetOneReservationsLoading());

    final result = await _reservationsRepo.updateReservations(date, time, id);
    result.fold(
      (l) async {
        if (l is String) {
          AppToaster.show(l);
          emit(GetOneReservationsError());
        } else {
          emit(GetOneReservationsSuccess());
          await getAllUserReservationsWithoutCanceled();
          AppToaster.show("تم تأجيل الحجز");
          RouterApp.pushNamed(RouteName.reservationDetailsScreen);
        }
      },
      (r) {
        AppToaster.show("An error occurred."); // General error message
        emit(GetOneReservationsError());
      },
    );
  }

  ///////////////////////////////////////////////////////////////////////////////////

  List<Reservations>  allTodayReservations=[];
  List<Reservations> todayOriginalReservations = []; // Backup for the original list




  List<GetUserReservations>? userReservations = [];
  List<GetUserMedicine> userMedicines = [];
  List<GetUserAnalysis> userAnalysis = [];
  List<GetUserPrescription> userPrescriptions = [];
  List<GetUserXRay> userXRays = [];

  Future<void> getUserReservations(String id) async {
    emit(GetUserReservationsLoading());
    final result = await _reservationsRepo.getUserReservations(id);
    result.fold(
      (l) async {
        final userReservation = l["users"]["reservs"];
        final userMedicine = l["users"]["medicin"];
        final userPrescription = l["users"]["roshta"];
        final userXRay = l["users"]["asheaa"];
        final userAnalysises = l["users"]["tahalil"];

        if (userReservation != null) {
          userReservations = userReservation
              .map<GetUserReservations>((e) => GetUserReservations.fromJson(e))
              .toList();
        }
        if (userMedicine != null) {
          userMedicines = userMedicine
              .map<GetUserMedicine>((e) => GetUserMedicine.fromJson(e))
              .toList();
        }
        if (userPrescription != null) {
          userPrescriptions = userPrescription
              .map<GetUserPrescription>((e) => GetUserPrescription.fromJson(e))
              .toList();
        }
        if (userXRay != null) {
          userXRays = userXRay
              .map<GetUserXRay>((e) => GetUserXRay.fromJson(e))
              .toList();
        }
        if (userAnalysises != null) {
          userAnalysis = userAnalysises
              .map<GetUserAnalysis>((e) => GetUserAnalysis.fromJson(e))
              .toList();
        }
        emit(GetUserReservationsSuccess());
      },
      (r) => emit(GetUserReservationsError()),
    );
  }

  List<GetAllUsers> patientName = [];
  String? _patientNames;

  String? get patientNames => _patientNames;

  setPickModel(GetAllUsers? patientNames) {
    _patientNames = patientNames?.fullName;
    emit(GetPatientName());
  }

  String? _typeName;
  String? _price;

  String? get typeName => _typeName;

  String? get price => _price;

  void setReservationType(String? typeName) {
    _typeName = typeName;
    emit(GetReservationTypeState(typeName));
  }

  void setReservationPrice(String? price) {
    _price = price;
    emit(GetReservationPriceState(price));
  }

  String? _selectedDate;

  String? get selectedDate => _selectedDate;

  setDate(dynamic selectedDate) {
    _selectedDate = selectedDate;
    emit(GetPatientName());
  }

  DateTimeRange? _selectedDateRange;

  DateTimeRange? get selectedDateRange => _selectedDateRange;

  void setDateRange(DateTime startDate, DateTime endDate) {
    _selectedDateRange = DateTimeRange(start: startDate, end: endDate);
    emit(GetPatientName());
  }

  DateTime? _selectedDates;

  DateTime? get selectedDates => _selectedDates;

  setDateSearch(DateTime selectedDates) {
    _selectedDates = selectedDates;
    DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'en');
    String DateTime = dateFormat.format(selectedDates);
    print(DateTime);
    emit(GetPatientName());
  }

  DateTime? _selectedYear;

  DateTime? get selectedYear => _selectedYear;

  void setYear(DateTime selectedYear) {
    _selectedYear = selectedYear;
    DateFormat arabicDateFormat = DateFormat('dd/MM/yyyy', 'ar');
    String arabicDateTime = arabicDateFormat.format(_selectedYear!);
    print(arabicDateTime);
    emit(GetPatientName());
  }

  DateTime? _selectedMonth;

  DateTime? get selectedMonth => _selectedMonth;

  void setMonth(DateTime selectedMonth) {
    _selectedMonth = selectedMonth;
    DateFormat arabicDateFormat = DateFormat('dd/MM/yyyy', 'ar');
    String arabicDateTime = arabicDateFormat.format(_selectedMonth!);
    print(arabicDateTime);
    emit(GetPatientName());
  }

  List<GetAllUsers> allUsers = [];

  Future<void> getAllUsers() async {
    emit(GetAllUserLoading());
    final result = await _reservationsRepo.getAllUsers();
    result.fold((l) async {
      final allUser = l["users"];
      print("allUser: $allUser");
      if (allUser != null) {
        allUsers =
            allUser.map<GetAllUsers>((e) => GetAllUsers.fromJson(e)).toList();
      }

      emit(GetAllUserSuccess());
    }, (r) => emit(GetAllUserError()));
  }

  Future<void> getAllUsersName() async {
    emit(GetAllUserNamesLoading());
    final result = await _reservationsRepo.getAllUsers();
    result.fold((l) async {
      final allUser = l["users"];
      print(allUser);
      if (allUser != null) {
        patientName = [];
        patientName =
            allUser.map<GetAllUsers>((e) => GetAllUsers.fromJson(e)).toList();
      }

      emit(GetAllUserNamesSuccess());
    }, (r) => emit(GetAllUserNamesError()));
  }

  DateTime? selectedFilteredDate = DateTime.now();

  Future<void> updateSelectedDate(DateTime date) async {
    selectedFilteredDate = date;
    emit(SelectedDateChanged());
  }



  Future<Either<ReservationModel, Failure>> reservationsApplyDiscount(String id, double discount) async {
    try {
      final result = await _reservationsRepo.reservationsApplyDiscount(id, discount);

      return result.fold(
            (reservation) {
          return Left(reservation);
        },
            (failure) {
          return Right(failure);
        },
      );
    } catch (e) {
      log('Error: $e');
      return Right(Failure('An unexpected error occurred: $e'));
    }
  }

// ReservationCubit

  Future<Either<ReservationModel, Failure>> amountPaid(String id, double amount) async {
    try {
      final result = await _reservationsRepo.amountPaid(id, amount);

      return result.fold(
            (reservation) {
          return Left(reservation);
        },
            (failure) {
          return Right(failure);
        },
      );
    } catch (e) {
      log('Error: $e');
      return Right(Failure('An unexpected error occurred: $e'));
    }
  }



  Future<void> fetchReservations(String date, String status, {String? searchQuery}) async {
    emit(FilteredReservationLoadingState());

    final result = await _reservationsRepo.getReservationsByDateAndStatus(date, status);
    result.fold(
          (reservations) async {
        if (reservations != null) {
          todayOriginalReservations = List.from(reservations);
          allTodayReservations = List.from(todayOriginalReservations); // Copy the data
        }

        // Apply search logic if a query is provided
        if (searchQuery != null && searchQuery.isNotEmpty) {
          allTodayReservations = todayOriginalReservations.where((reservation) {
            final name = reservation.user?.fullName?.toLowerCase() ?? '';
            final phoneNumber = reservation.user?.phoneNumber?.toLowerCase() ?? '';
            return name.contains(searchQuery.toLowerCase()) || phoneNumber.contains(searchQuery.toLowerCase());
          }).toList();
        } else {
          // Restore the original list if no search query is provided
          allTodayReservations = List.from(todayOriginalReservations);
        }

        emit(FilteredReservationSuccessState(allTodayReservations));
      },
          (error) {
        emit(FilteredReservationErrorState(error));
      },
    );
  }

  List<Reservations> endedReservations = []; // Backup for the original list

  Future<void> fetchReservationsByStatuses(
      String date, List<String> statuses) async {
    emit(EndedReservationLoadingState());
    final result = await _reservationsRepo.getReservationsByDateAndStatuses(date, statuses);
    result.fold(
          (reservations) {
        endedReservations= reservations;
        emit(EndedReservationSuccessState(reservations));
      },
          (error) => emit(EndedReservationErrorState(error)),
    );
  }
}
