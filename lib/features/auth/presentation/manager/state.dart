abstract class AuthState {}

class InitState extends AuthState {}

class SignInLoading extends AuthState {}

class SignInSuccess extends AuthState {
  String token;

  SignInSuccess(this.token);
}

class SignInError extends AuthState {
  String? error;

  SignInError({this.error});
}

class CreateAdminLoading extends AuthState {}

class CreateAdminSuccess extends AuthState {}

class CreateAdminError extends AuthState {}

class GetProfileImageLoading extends AuthState {}

class GetProfileImageSuccess extends AuthState {}

class GetProfileImageError extends AuthState {}
