class ApiConstant {
  static const String baseUrl = "https://test-eight-nu-20.vercel.app/api/v1/";

  ///SignIn Api
  static const String signInAdmin = "admin/signin_admin";
  static const String createAdmin = "admin/create_admin";
  static const String createUserByAdmin = "admin/create-user";
  static const String getAdminProfilePic = "admin/get-image";
  static const String uploadAdminProfilePic = "admin/upload-image";
  static const String getAdminAllUsers = "admin/get-allUsers";
  static const String getAdminOneUser = "admin/get-user/";
  static const String deleteAccount = "users/delete-acc";
  static const String editDoctorInfo = "admin/edit-doctor-info/";

  ///Reservations Api
  static const String discountValue = "reservations/apply-discount/";
  static const String getAllReservations = "reservations/get-reservations";
  static const String getLastReservations = "reservations/get-user-reservations";
  static const String reservationsPayMoney = "reservations/pay-money/";

  static const String getOneReservations = "reservations/get-one-reservation/";
  static const String getUserReservations = "admin/get-user/";
  static const String createReservations = "reservations/create";
  static const String updateReservations = "reservations/update-reservations/";
  static const String confirmReservations = "reservations/confirm-reservations/";
  static const String cancelReservations = "reservations/cancel-reservations/";
  static const String payInClinicReservations = "reservations/paid-reservations/";

  ///Chat Api
  static const String getAdminAllConversations = "chat/admin-get-all-chat";
  static const String getConversationMessages = "chat/admin-get-chat/";
  static const String sendMessage = "chat/send-message/";

  ///Articles Api
  static const String createArticle = "articles/upload";
  static const String getAllArticle = "articles/get-all-articles";
  static const String getOneArticle = "articles/get-one-article/";
  static const String editArticle = "articles/edit/";
  static const String deleteArticle = "articles/delete-article/";

  ///Medical Reports Api
  ///Analysis
  static const String createAnalysis = "medReport/upload-tahlil";
  static const String getAllAnalysis = "medReport/get-allTa7lil";
  static const String getOneAnalysis = "medReport/get-ta7lil/";
  static const String deleteAnalysis = "medReport/delete-tahlil/";

  ///Prescription
  static const String createPrescription = "medReport/upload-roshtaaa";
  static const String getAllPrescription = "medReport/get-roshta/";
  static const String getOnePrescription = "medReport/get-roshta/";
  static const String deletePrescription = "medReport/delete-roshta/";

  ///XRay
  static const String createXRay = "medReport/upload-ashe3a";
  static const String getAllXRay = "medReport/get-allAshe3a";
  static const String getOneXRay = "medReport/get-asha3a/";
  static const String deleteXRay = "medReport/delete-ashe3a/";

  ///Medicine
  static const String createMedicine = "medReport/upload-medicin";
  static const String getAllMedicine = "medReport/get-allMedicin";
  static const String getOneMedicine = "medReport/get-medicin/";
  static const String deleteMedicine = "medReport/delete-medicin/";

  /// Electronic Prescription
  static const String addPrescriptionMedicine =
      "prescriptionMedicine/create-medicine";
  static const String getAllPrescriptionMedicine =
      "prescriptionMedicine/get-medicines";
  static const String addElectronicPrescription = "prescription/add-roshta/";
  static const String updateElectronicPrescription =
      "prescription/update-roshta/";
  static const String deleteElectronicPrescription =
      "prescription/update-roshta/";
  static const String getAllElectronicPrescription =
      "prescription/get-AllPerciptions/";
  static const String getOneElectronicPrescription =
      "prescription/get-OnePerciptions/";

  /// Patient data By Doc
  static const String putPatientData = "patientHistory/update-patient-history/";
  static const String getPatientData = "patientHistory/get-patient-history";

  /// Ads endpoints
  static const String addAd = "ad/add-ad";
  static const String getAllAds = "ad/get-all-ads";
  static const String updateAd = "ad/update-ad/";
  static const String deleteAd = "ad/delete-ad/";

  /// services endpoints
  static const String addService = "services/create-service";
  static const String getAllService = "services/get-all-services";
  static const String updateService = "services/edit-service/";
  static const String deleteService = "services/delete-service/";

  /// certificates
  static const String deleteCertificate = "admin/delete-cirtificate/";

  /// Hide Schedule
  static const String hideSchedule = "schedule/hide-schedule/";

  /// addHours
  static const String addHours = "schedule/num-reservations";

  /// Add Additional Service
  static const String addAdditionalService =
      "reservations/update-reservation-details/";
}
