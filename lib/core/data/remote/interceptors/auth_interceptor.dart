import 'package:dio/dio.dart';
import 'package:dr_mohamed_salah_admin/utils/cache_utils/cache_vars.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final listOfPaths = <String>[
      '/login',
      '/register',
    ];

    if (listOfPaths.contains(options.path.toString())) {
      return handler.next(options);
    }

    options.headers.addAll({'Authorization': "Bearer ${CacheVars.token}"});
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}
