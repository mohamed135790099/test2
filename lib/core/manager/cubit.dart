import 'dart:io';

import 'package:dr_mohamed_salah_admin/core/manager/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitState());

  static AppCubit get(context) => BlocProvider.of(context);

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  File? _userProfileImage;

  File? get userProfileImage => _userProfileImage;

  var picker = ImagePicker();

  Future getFrontSideImage() async {
    emit(GetUserProfileImageLoading());
    await picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        _userProfileImage = File(value.path);
        emit(GetUserProfileImageSuccess());
      } else {
        emit(GetUserProfileImageError());
      }
    });
  }

  changeCurrentIndex(int v) async {
    _currentIndex = v;
    emit(ChangeIndex());
  }
}
