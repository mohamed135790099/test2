import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dr_mohamed_salah_admin/core/data/local/cache_helper.dart';
import 'package:dr_mohamed_salah_admin/core/data/model/failure.dart';
import 'package:dr_mohamed_salah_admin/core/data/model/response_model.dart';
import 'package:dr_mohamed_salah_admin/core/data/remote/dio_helper.dart';
import 'package:dr_mohamed_salah_admin/features/home/data/model/reservations.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/service_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/last_reservation_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/patient_history.dart';
import 'package:dr_mohamed_salah_admin/utils/api_utils/api_constant.dart';
import 'package:image_picker/image_picker.dart';

import '../../../home/data/model/new_reservation_model.dart';
import '../models/get_user_details.dart';

class ReservationsRepo {
  final Dio _dio = Dio();

  ReservationsRepo() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    await _setToken();
  }

  Future<void> _setToken() async {
    final String? accessToken = await CacheHelper.getToken();
    if (accessToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      print('Token set: $accessToken'); // Debug line
    } else {
      print('No access token found'); // Debug line
    }
  }

  Future<String> addAdditionalServices(String reservationId, Map<String, dynamic> services) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.patch(
        '${ApiConstant.baseUrl}${ApiConstant.addAdditionalService}$reservationId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          "addtionalService": services,
        },
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception("Failed to add additional services: $e");
    }
  }

  Future<void> deleteAnalysis(String analysisId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.delete(
        '${ApiConstant.baseUrl}${ApiConstant.deleteAnalysis}$analysisId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        print('Failed to delete article: ${response.statusMessage}');
        throw Exception('Failed to delete article: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  Future<void> deletePrescription(String prescriptionId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.delete(
        '${ApiConstant.baseUrl}${ApiConstant.deletePrescription}$prescriptionId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        print('Failed to delete article: ${response.statusMessage}');
        throw Exception('Failed to delete article: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  Future<void> deleteMedicine(String medicineId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.delete(
        '${ApiConstant.baseUrl}${ApiConstant.deleteMedicine}$medicineId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        print('Failed to delete article: ${response.statusMessage}');
        throw Exception('Failed to delete article: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  Future<void> deleteXRay(String xrayId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.delete(
        '${ApiConstant.baseUrl}${ApiConstant.deleteXRay}$xrayId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        print('Failed to delete article: ${response.statusMessage}');
        throw Exception('Failed to delete article: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<List<String>> getAvailableHours(String date) async {
    try {
      print(date);
      await _setToken();
      final response = await _dio.get(
        '${ApiConstant.baseUrl}schedule/get-all-schedule',
        queryParameters: {'date': date},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final List schedules = data['schedules'] as List<dynamic>;
          List<String> availableHours = [];

          for (var schedule in schedules) {
            final scheduleDate = schedule['date'] as String;
            if (scheduleDate == date) {
              final times = schedule['times'] as List<dynamic>;

              availableHours.addAll(
                times
                    .map((time) =>
                        (time as Map<String, dynamic>)['time'].toString())
                    .toList(),
              );
            }
          }
          return availableHours;
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 401) {
        return getAvailableHours(date);
      } else {
        throw Exception(
            'Failed to load available hours. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching available hours: $e');
      throw Exception('Failed to load available hours: $e');
    }
  }

  Future<Map<String, dynamic>> updatePatientDetails(
      String id, String name, String phone) async {
    try {
      final response = await _dio.put(
        '${ApiConstant.baseUrl}admin/update-user/$id',
        data: {
          'fullName': name,
          'phone': phone,
        },
      );
      return {
        'success': true,
        'message':
            response.data['message'] ?? 'Patient details updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update patient details: ${e.toString()}',
      };
    }
  }

  Future<Either<Map<String, dynamic>, Failure>> getConversationMessages(
      String id) async {
    try {
      final response = await DioHelper.get(
        endPoint: ApiConstant.getConversationMessages + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel.data);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> sendMessage(
      String id, String message) async {
    try {
      final String? token = await CacheHelper.getToken();

      Response response = await _dio.post(
        "${ApiConstant.baseUrl}${ApiConstant.sendMessage}$id",
        data: {
          "message": message,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  //////////////////////////////////////////////////////////////

  Future<Either<dynamic, Failure>> getAllUsers() async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getAdminAllUsers,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> createReservations(String userId,
      String date, String time, String price, String reservType) async {
    try {
      ResponseModel response = await DioHelper.post(
        endPoint: ApiConstant.createReservations,
        data: {
          "userId": userId,
          "date": date,
          "time": time,
          "price": price,
          "reserv_type": reservType,
        },
      );
      return Left(response.data);
    } on DioException catch (dioError) {
      if (dioError.response?.statusCode == 400) {
        final errorData = dioError.response?.data;
        return Left({
          "statusCode": 400,
          "message": errorData['message'] ?? 'Invalid request data',
        });
      } else {
        return const Right(Failure('An unexpected error occurred'));
      }
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }

  /////////////////////////////////////////////////////////////
  Future<Either<dynamic, Failure>> createPrescription(
      String title, List<XFile>? images, String? content, String userId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }
      if (content == null) {
        return const Right(Failure('Content cannot be null'));
      }

      List<MultipartFile> multipartFiles = [];
      if (images != null) {
        for (XFile image in images) {
          final file =
              await MultipartFile.fromFile(image.path, filename: image.name);
          multipartFiles.add(file);
        }
      }

      FormData formData = FormData.fromMap({
        "title": title,
        "image": multipartFiles,
        "terms": content,
        "id": userId
      });

      Response response = await _dio.post(
        "${ApiConstant.baseUrl}medReport/upload-roshtaaa",
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(response.data);
      } else {
        return Right(Failure(
            'Error: ${response.statusCode} - ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Right(Failure(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'));
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return const Right(Failure('Receive timeout'));
      } else {
        return Right(Failure(e.message ?? "Error in creating XRay"));
      }
    } catch (e) {
      return Right(Failure('Unknown error: $e'));
    }
  }

  Future<Either<dynamic, Failure>> updatePrescription(
      String userId,
      String prescriptionId,
      String? title,
      String? content,
      List<XFile>? images) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }
      if (content == null) {
        return const Right(Failure('Content cannot be null'));
      }

      List<MultipartFile> multipartFiles = [];
      if (images != null) {
        for (XFile image in images) {
          final file =
              await MultipartFile.fromFile(image.path, filename: image.name);
          multipartFiles.add(file);
        }
      }

      FormData formData = FormData.fromMap({
        "title": title,
        "image": multipartFiles,
        "terms": content,
        "id": userId
      });

      Response response = await _dio.put(
        "${ApiConstant.baseUrl}medReport/edit-roshta/$prescriptionId",
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(response.data);
      } else {
        return Right(Failure(
            'Error: ${response.statusCode} - ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Right(Failure(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'));
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return const Right(Failure('Receive timeout'));
      } else {
        return Right(Failure(e.message ?? "Error in updating prescription"));
      }
    } catch (e) {
      return Right(Failure('Unknown error: $e'));
    }
  }

///////////////////////////////////////////////////////////////

  Future<Either<dynamic, Failure>> createXRay(String title, String? content,
      List<XFile>? pdfFiles, List<XFile>? images, String id) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        print('Error: User token not found');
        return const Right(Failure('User token not found'));
      }

      if (content == null) {
        print('Error: Content cannot be null');
        return const Right(Failure('Content cannot be null'));
      }

      // Handle image files
      List<MultipartFile> multipartFiles = [];
      if (images != null) {
        for (XFile image in images) {
          try {
            final file = await MultipartFile.fromFile(image.path);
            multipartFiles.add(file);
          } catch (e) {
            print('Error creating MultipartFile for image: $e');
            return Right(Failure('Error creating MultipartFile for image: $e'));
          }
        }
      }
      // Handle PDF files
      List<MultipartFile> pdfMultipartFiles = [];
      if (pdfFiles != null && pdfFiles.isNotEmpty) {
        for (XFile pdfFile in pdfFiles) {
          try {
            final file = await MultipartFile.fromFile(pdfFile.path);
            pdfMultipartFiles.add(file);
          } catch (e) {
            print('Error creating MultipartFile for PDF: $e');
            return Right(Failure('Error creating MultipartFile for PDF: $e'));
          }
        }
      }

      // Construct FormData
      FormData formData = FormData.fromMap({
        "title": title,
        "image": multipartFiles,
        "terms": content,
        "id": id,
        if (pdfMultipartFiles.isNotEmpty) "pdf": pdfMultipartFiles,
      });

      Response response = await Dio().post(
        "${ApiConstant.baseUrl}${ApiConstant.createXRay}",
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) =>
              status! < 500 || status == 401 || status == 403,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['message'] == 'ashe3a uploaded successfully') {
          return Left(responseData);
        } else {
          print('Unexpected response message: ${responseData['message']}');
          return Right(Failure(
              'Unexpected response message: ${responseData['message']}'));
        }
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
        return Right(Failure(
            'Error: ${response.statusCode} - ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('DioException Response Status Code: ${e.response?.statusCode}');
        print(
            'DioException Response Status Message: ${e.response?.statusMessage}');
        print('DioException Response Data: ${e.response?.data}');
        return Right(Failure(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'));
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('DioException Receive timeout');
        return const Right(Failure('Receive timeout'));
      } else {
        print('DioException Message: ${e.message}');
        return Right(Failure(e.message ?? "Error in creating XRay"));
      }
    } catch (e) {
      print('Unknown Error: $e');
      return Right(Failure('Unknown error: $e'));
    }
  }

  Future<Either<dynamic, Failure>> updateXRay(
    String xRayId,
    String? title,
    String? content,
    List<XFile>? pdfFiles,
    List<XFile>? images,
  ) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }

      if (content == null) {
        return const Right(Failure('Content cannot be null'));
      }

      // Handle image files
      List<MultipartFile> multipartFiles = [];
      if (images != null) {
        for (XFile image in images) {
          final file =
              await MultipartFile.fromFile(image.path, filename: image.name);
          multipartFiles.add(file);
        }
      }

      // Handle PDF files
      List<MultipartFile> pdfMultipartFiles = [];
      if (pdfFiles != null && pdfFiles.isNotEmpty) {
        for (XFile pdfFile in pdfFiles) {
          final file = await MultipartFile.fromFile(pdfFile.path,
              filename: pdfFile.name);
          pdfMultipartFiles.add(file);
        }
      }

      // Construct FormData
      FormData formData = FormData.fromMap({
        "title": title,
        "image": multipartFiles,
        "terms": content,
        if (pdfMultipartFiles.isNotEmpty) "pdf": pdfMultipartFiles,
      });

      Response response = await _dio.put(
        "${ApiConstant.baseUrl}medReport/edit-ashe3a/$xRayId",
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(response.data);
      } else {
        return Right(Failure(
            'Error: ${response.statusCode} - ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Right(Failure(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'));
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return const Right(Failure('Receive timeout'));
      } else {
        return Right(Failure(e.message ?? "Error in updating XRay"));
      }
    } catch (e) {
      return Right(Failure('Unknown error: $e'));
    }
  }

  ////////////////////////////////////////////////////////////////

  Future<Either<dynamic, Failure>> createAnalysis(String title, String? content,
      List<XFile>? pdfFiles, List<XFile>? images, String userId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        print('Error: User token not found');
        return const Right(Failure('User token not found'));
      }

      if (content == null) {
        print('Error: Content cannot be null');
        return const Right(Failure('Content cannot be null'));
      }

      // Handle image files
      List<MultipartFile> multipartFiles = [];
      if (images != null) {
        for (XFile image in images) {
          try {
            final file = await MultipartFile.fromFile(image.path);
            multipartFiles.add(file);
          } catch (e) {
            print('Error creating MultipartFile for image: $e');
            return Right(Failure('Error creating MultipartFile for image: $e'));
          }
        }
      }
      // Handle PDF files
      List<MultipartFile> pdfMultipartFiles = [];
      if (pdfFiles != null && pdfFiles.isNotEmpty) {
        for (XFile pdfFile in pdfFiles) {
          try {
            final file = await MultipartFile.fromFile(pdfFile.path);
            pdfMultipartFiles.add(file);
          } catch (e) {
            print('Error creating MultipartFile for PDF: $e');
            return Right(Failure('Error creating MultipartFile for PDF: $e'));
          }
        }
      }

      FormData formData = FormData.fromMap({
        "title": title,
        "image": multipartFiles,
        "terms": content,
        "id": userId,
        if (pdfMultipartFiles.isNotEmpty) "pdf": pdfMultipartFiles,
      });

      Response response = await Dio().post(
        "${ApiConstant.baseUrl}${ApiConstant.createAnalysis}",
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) =>
              status! < 500 || status == 401 || status == 403,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['message'] == 'ta7lil uploaded successfully') {
          return Left(responseData);
        } else {
          return Right(Failure(
              'Unexpected response message: ${responseData['message']}'));
        }
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
        return Right(Failure(
            'Error: ${response.statusCode} - ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('DioException Response Status Code: ${e.response?.statusCode}');
        print(
            'DioException Response Status Message: ${e.response?.statusMessage}');
        print('DioException Response Data: ${e.response?.data}');
        return Right(Failure(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'));
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('DioException Receive timeout');
        return const Right(Failure('Receive timeout'));
      } else {
        print('DioException Message: ${e.message}');
        return Right(Failure(e.message ?? "Error in creating XRay"));
      }
    } catch (e) {
      print('Unknown Error: $e');
      return Right(Failure('Unknown error: $e'));
    }
  }

  Future<Either<dynamic, Failure>> updateAnalysis(
    String analysisId,
    String? title,
    String? content,
    List<XFile>? pdfFiles,
    List<XFile>? images,
  ) async {
    try {
      final String? token = await CacheHelper.getToken();

      if (token == null) {
        return const Right(Failure('User token not found'));
      }

      List<MultipartFile> imageFiles = [];
      if (images != null && images.isNotEmpty) {
        for (XFile image in images) {
          print("Image path: ${image.path}");
          final file =
              await MultipartFile.fromFile(image.path, filename: image.name);
          imageFiles.add(file);
        }
      }

      List<MultipartFile> pdfFilesList = [];
      if (pdfFiles != null && pdfFiles.isNotEmpty) {
        for (XFile pdfFile in pdfFiles) {
          print("PDF path: ${pdfFile.path}");
          final file = await MultipartFile.fromFile(pdfFile.path,
              filename: pdfFile.name);
          pdfFilesList.add(file);
        }
      }

      FormData formData = FormData.fromMap({
        "title": title,
        "terms": content,
        if (imageFiles.isNotEmpty) "image": imageFiles,
        if (pdfFilesList.isNotEmpty) "pdf": pdfFilesList,
      });

      print("FormData content: ${formData.fields}");
      print("Files attached: ${formData.files}");

      final response = await _dio.put(
        '${ApiConstant.baseUrl}medReport/edit-tahlil/$analysisId',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Response data: ${response.data}");
        if (response.data['message'] == 'ta7lel updated') {
          return Left(response.data);
        } else {
          print("Unexpected response structure: ${response.data}");
          return const Right(Failure('Update failed with unexpected response'));
        }
      } else {
        print("Error response: ${response.data}");
        return Right(Failure(
            'Error: ${response.statusCode} - ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      // Improved error logging
      if (e.response != null) {
        print("Dio Error: ${e.response?.data}");
        return Right(Failure(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'));
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return const Right(Failure('Receive timeout'));
      } else {
        return Right(Failure(e.message ?? "Error in updating analysis"));
      }
    } catch (e) {
      print("Unknown error: $e");
      return Right(Failure('Unknown error: $e'));
    }
  }

  ////////////////////////////////////////////////////////////
  Future<Either<dynamic, Failure>> createMedicine(
      String title, List<XFile>? images, String? content, String userId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }
      if (content == null) {
        return const Right(Failure('Content cannot be null'));
      }

      List<MultipartFile> multipartFiles = [];
      if (images != null) {
        for (XFile image in images) {
          final file = await MultipartFile.fromFile(image.path);
          multipartFiles.add(file);
        }
      }

      FormData formData = FormData.fromMap({
        "title": title,
        "image": multipartFiles,
        "terms": content,
        "id": userId
      });

      Response response = await _dio.post(
        "${ApiConstant.baseUrl}${ApiConstant.createMedicine}",
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(response.data);
      } else {
        return Right(Failure(
            'Error: ${response.statusCode} - ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Right(Failure(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'));
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return const Right(Failure('Receive timeout'));
      } else {
        return Right(Failure(e.message ?? "Error in creating XRay"));
      }
    } catch (e) {
      return Right(Failure('Unknown error: $e'));
    }
  }

  Future<Either<dynamic, Failure>> updateMedicine(String medicineId,
      String? title, String? content, List<XFile>? images) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }
      if (content == null) {
        return const Right(Failure('Content cannot be null'));
      }

      List<MultipartFile> multipartFiles = [];
      if (images != null) {
        for (XFile image in images) {
          final file =
              await MultipartFile.fromFile(image.path, filename: image.name);
          multipartFiles.add(file);
        }
      }

      FormData formData = FormData.fromMap({
        "title": title,
        "image": multipartFiles,
        "terms": content,
      });

      Response response = await _dio.put(
        "${ApiConstant.baseUrl}medReport/edit-medicin/$medicineId",
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(response.data);
      } else {
        return Right(Failure(
            'Error: ${response.statusCode} - ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Right(Failure(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'));
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return const Right(Failure('Receive timeout'));
      } else {
        return Right(Failure(e.message ?? "Error in updating prescription"));
      }
    } catch (e) {
      return Right(Failure('Unknown error: $e'));
    }
  }

  /////////////////////////////////////////////////////////////////////

  Future<Either<dynamic, Failure>> getOneAnalysis(String id) async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getOneAnalysis + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getOnePrescription(String id) async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getOnePrescription + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getOneMedicine(String id) async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getOneMedicine + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getOneXRay(String id) async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getOneXRay + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> createUserByAdmin(
      String userName, String phone, String gender) async {
    try {
      ResponseModel response = await DioHelper.post(
          endPoint: ApiConstant.createUserByAdmin,
          data: {"fullName": userName, "phone": phone, "gender": gender});

      if (response.message == 'already exist') {
        return const Right(Failure("Phone number already exists"));
      }

      return Left(response.data);
    } on DioException catch (e) {
      return Right(Failure(e.message ?? "Error Occurred"));
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }

  Future<Either<dynamic, Failure>> payInClinicReservations(
      String id, bool isPaid) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }
      Response response = await _dio.put(
        "${ApiConstant.baseUrl}${ApiConstant.payInClinicReservations}$id",
        data: {"paid": isPaid},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print(response.data.toString());
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> updateReservations(
      String date, String time, String id) async {
    try {
      ResponseModel response = await DioHelper.put(
        endPoint: ApiConstant.updateReservations + id,
        data: {
          "date": date,
          "time": time,
        },
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      final errorMessage = responseModel.message ?? 'Unknown error occurred';
      return Left(errorMessage);
    } on Failure catch (failure) {
      return Right(failure); // Generic failure handling
    }
  }

  Future<Either<dynamic, Failure>> cancelReservations(String id) async {
    try {
      ResponseModel response = await DioHelper.put(
        endPoint: ApiConstant.cancelReservations + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> confirmReservations(String id) async {
    try {
      ResponseModel response = await DioHelper.put(
        endPoint: ApiConstant.confirmReservations + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getAdminAllConversations() async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getAdminAllConversations,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getAllReservations() async {
    try {
      ResponseModel response = await DioHelper.get(endPoint: ApiConstant.getAllReservations,);
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }



  /// New Fun For get last reservation
  Future<Either<LastReservationModel, String>> getUserLastReservations(
      String id, String date) async {
    try {
      final String? token = await CacheHelper.getToken();
      final response = await _dio.get(
        "${ApiConstant.baseUrl}${ApiConstant.getLastReservations}",
        queryParameters: {"date[lt]": date},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "userId": id,
        },
      );
      if (response.statusCode == 200) {
        final lastReservationData =
            LastReservationModel.fromJson(response.data);
        return Left(lastReservationData);
      } else {
        return Right("Failed to fetch data: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      return Right("DioError: ${e.message}");
    } catch (e) {
      return Right("Unexpected error: $e");
    }
  }

  Future<Either<dynamic, Failure>> getUserReservations(String id) async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getUserReservations + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getUserDetails(String id) async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getAdminOneUser + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getOneReservations(String id) async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getOneReservations + id,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> putPatientData(
      String id, PatientHistory patientHistory) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }

      ResponseModel response = await DioHelper.patch(
        token: token,
        endPoint: ApiConstant.putPatientData + id,
        data: patientHistory.toJson(),
      );

      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getPatientData(String patientId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }
      ResponseModel response = await DioHelper.get(
          token: token,
          endPoint: ApiConstant.getPatientData,
          data: {"patientId": patientId});
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<List<Service>> getAllServices() async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }

      final response = await _dio.get(
        '${ApiConstant.baseUrl}${ApiConstant.getAllService}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> serviceList = response.data['services'];
        final List<Service> services = serviceList
            .map((serviceData) => Service.fromJson(serviceData))
            .toList();
        return services;
      } else {
        throw Exception("Services data not found");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<Either<ReservationModel, Failure>> reservationsApplyDiscount(String id, double discount) async {
    try {
      // Log request details for debugging
      print("Request URL: ${ApiConstant.baseUrl}${ApiConstant.discountValue}$id");
      print("Request Body: {'discount': $discount}");

      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }

      print("Authorization Token: $token");

      Response response = await _dio.patch(
        "${ApiConstant.baseUrl}${ApiConstant.discountValue}$id",
        data: {"discount": discount},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      // Check if response data is in expected format
      if (response.data != null && response.data is Map<String, dynamic>) {
        try {
          // Parse the response data into ReservationModel
          ReservationModel reservation = ReservationModel.fromJson(response.data);
          return Left(reservation);
        } catch (e) {
          // Handle parsing errors
          return Right(Failure('Error parsing response: $e'));
        }
      } else {
        return const Right(Failure('Invalid response format'));
      }
    } on DioException catch (e) {
      // Handle Dio specific exceptions with additional error information
      String errorMessage = e.message ?? "An error occurred";
      if (e.response != null) {
        // Log detailed error response
        print("Dio Error Response: ${e.response?.statusCode}, ${e.response?.data}");
        errorMessage = 'DioException: ${e.response?.data ?? e.message}';
      }
      return Right(Failure(errorMessage));
    } catch (e) {
      // Catch any other unexpected errors
      return Right(Failure('An unexpected error occurred'));
    }
  }


  Future<Either<ReservationModel, Failure>> amountPaid(String id, double amount) async {
    try {
      print("Request URL: ${ApiConstant.baseUrl}${ApiConstant.discountValue}$id");
      print("Request Body: {'amount': $amount}");

      final String? token = await CacheHelper.getToken();
      if (token == null) {
        return const Right(Failure('User token not found'));
      }
      print("Authorization Token: $token");

      Response response = await _dio.patch(
        "${ApiConstant.baseUrl}${ApiConstant.reservationsPayMoney}$id",
        data: {"amount": amount},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.data != null && response.data is Map<String, dynamic>) {
        try {
          ReservationModel reservation = ReservationModel.fromJson(response.data);
          return Left(reservation);
        } catch (e) {
          return Right(Failure('Error parsing response: $e'));
        }
      } else {
        return const Right(Failure('Invalid response format'));
      }
    } on DioException catch (e) {
      String errorMessage = e.message ?? "An error occurred";
      if (e.response != null) {
        print("Dio Error Response: ${e.response?.statusCode}, ${e.response?.data}");
        errorMessage = 'DioException: ${e.response?.data ?? e.message}';
      }
      return Right(Failure(errorMessage));
    } catch (e) {
      return Right(Failure('An unexpected error occurred'));
    }
  }



  Future<Either<List<Reservations>, String>> getReservationsByDateAndStatuses(
      String date, List<String> statuses) async {
    try {
      final String? token = await CacheHelper.getToken();
      final queryParams = {
        "date": date,
        "status": statuses,
      };
      const String url = "${ApiConstant.baseUrl}${ApiConstant.getAllReservations}";
      final response = await _dio.get(
        url,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final reservationsData = (response.data['reservations'] as List)
            .map((e) => Reservations.fromJson(e))
            .toList();
        return Left(reservationsData);
      } else {
        return Right("Failed to fetch data: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      return Right("DioError: ${e.message}");
    } catch (e) {
      return Right("Unexpected error: $e");
    }
  }

  Future<Either<List<Reservations>, String>> getReservationsByDateAndStatus(
      String date, String status) async {
    try {
      final String? token = await CacheHelper.getToken();

      const String url = "${ApiConstant.baseUrl}${ApiConstant.getAllReservations}";

      final response = await _dio.get(
        url,
        queryParameters: {"date": date, "status": status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final reservationsData = (response.data['reservations'] as List)
            .map((e) => Reservations.fromJson(e))
            .toList();
        return Left(reservationsData);
      } else {

        return Right("Failed to fetch data: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      return Right("DioError: ${e.message}");
    } catch (e) {
      return Right("Unexpected error: $e");
    }
  }
}
