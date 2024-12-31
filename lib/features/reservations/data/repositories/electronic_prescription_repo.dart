import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dr_mohamed_salah_admin/core/data/local/cache_helper.dart';
import 'package:dr_mohamed_salah_admin/core/data/model/failure.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/electronic_prescription_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_electronic_prescription.dart';
import 'package:dr_mohamed_salah_admin/utils/api_utils/api_constant.dart';

class ElectronicPrescriptionRepo {
  final Dio _dio = Dio();

  ElectronicPrescriptionRepo() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    await _setToken();
  }

  Future<void> _setToken() async {
    final String? accessToken = await CacheHelper.getToken();
    if (accessToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      print('Token set: $accessToken');
    } else {
      print('No access token found');
    }
  }

  Future<Map<String, dynamic>> createMedicine(String title) async {
    const String url =
        '${ApiConstant.baseUrl}${ApiConstant.addPrescriptionMedicine}';
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.post(
        url,
        data: {"title": title},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 201 && response.data['status'] == 'success') {
        return response.data;
      } else {
        throw Exception('Failed to create medicine');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.data}');
      throw Exception('Error creating medicine: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllMedicines() async {
    const String url =
        '${ApiConstant.baseUrl}${ApiConstant.getAllPrescriptionMedicine}';

    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(response.data['medicin']);
      } else {
        throw Exception('Failed to get medicines');
      }
    } on DioError catch (e) {
      print('Error: ${e.response?.data}');
      throw Exception('Error fetching medicines: ${e.message}');
    }
  }

  Future<Map<String, dynamic>?> uploadPrescription(
      String? patientId, List<Map<String, dynamic>>? roshta) async {
    if (patientId == null || roshta == null) {
      throw Exception('Invalid input: patientId or roshta is null');
    }

    String url =
        '${ApiConstant.baseUrl}${ApiConstant.addElectronicPrescription}$patientId';

    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw Exception('Admin token not found');
      }

      final response = await _dio.post(
        url,
        data: {"roshta": roshta},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Check for response data and success message
      if (response.statusCode == 200 &&
          response.data?['message'] == 'success') {
        return response.data;
      } else {
        throw Exception('Failed to upload prescription');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.data}');
      throw Exception('Error uploading prescription: ${e.message}');
    }
  }

  Future<List<GetUserElectronicPrescription>> fetchElectronicPrescriptions(
      String patientId) async {
    final String apiUrl =
        "${ApiConstant.baseUrl}${ApiConstant.getAllElectronicPrescription}$patientId";

    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }

      final response = await _dio.get(
        apiUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 &&
          response.data['elecPrescription'] != null) {
        final List electronicPrescriptionList =
            response.data['elecPrescription'];
        return electronicPrescriptionList
            .map((json) => GetUserElectronicPrescription.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load prescriptions');
      }
    } catch (e) {
      throw Exception('Error fetching prescriptions: $e');
    }
  }

  Future<Either<Failure, ElectronicPrescription>> getElectronicPrescriptionById(
      String id) async {
    final String apiUrl =
        '${ApiConstant.baseUrl}${ApiConstant.getOneElectronicPrescription}$id';

    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Left(Failure('Admin token not found'));
      }

      final response = await _dio.get(
        apiUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 &&
          response.data['message'] == 'perciptions founded') {
        final prescription =
            ElectronicPrescription.fromJson(response.data['elecPrescription']);
        return Right(prescription);
      } else {
        return const Left(Failure('Failed to load prescription'));
      }
    } catch (e) {
      return Left(Failure('Error fetching prescription: $e'));
    }
  }
}
