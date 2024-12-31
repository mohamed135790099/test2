import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/models/create_admin_response.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/models/get_all_users.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/models/sign_in_response_model.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/repositories/sign_in_repo.dart';
import 'package:dr_mohamed_salah_admin/features/auth/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:dr_mohamed_salah_admin/utils/cache_utils/cach_saving.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInRepo _signInRepo;

  AuthCubit(this._signInRepo) : super(InitState());

  static AuthCubit get(context) => BlocProvider.of(context);
  XFile? _profileImage;

  XFile? get profileImage => _profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    emit(GetProfileImageLoading());
    await picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        _profileImage = XFile(value.path);
        print(profileImage.toString());
        emit(GetProfileImageSuccess());
      } else {
        emit(GetProfileImageError());
      }
    });
  }

  SignInResponse? signInResponse;

  Future<bool> signInAdmin(String userName, String password) async {
    emit(SignInLoading());

    final result = await _signInRepo.signInAdmin(userName, password);

    return result.fold(
      (successData) {
        final token = successData['token'];
        CacheSave.saveToken(token);
        AppToaster.show("Login Success");
        RouterApp.pushNamedAndRemoveUntil(RouteName.mainScreen);
        emit(SignInSuccess(token));
        return true;
      },
      (failure) {
        emit(SignInError());
        return false;
      },
    );
  }

  CreateAdminResponse? createAdminResponse;

  Future<void> createAdmin(String userName, String password) async {
    emit(CreateAdminLoading());
    final result = await _signInRepo.createAdmin(userName, password);
    result.fold((l) async {
      createAdminResponse = CreateAdminResponse.fromJson(l);
      AppToaster.show("Admin created please signin");
      emit(CreateAdminSuccess());
    }, (r) => emit(CreateAdminError()));
  }

  List<GetAllUsers> allUsers = [];

  Future<void> getAllUsers() async {
    emit(CreateAdminLoading());
    final result = await _signInRepo.getAllUsers();
    result.fold((l) async {
      final allUser = l["users"];
      if (allUser != null) {
        allUsers =
            allUser.map<GetAllUsers>((e) => GetAllUsers.fromJson(e)).toList();
      }

      emit(CreateAdminSuccess());
    }, (r) => emit(CreateAdminError()));
  }
}
