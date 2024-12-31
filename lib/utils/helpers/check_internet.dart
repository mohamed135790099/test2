import 'package:connectivity_plus/connectivity_plus.dart';

class CheckInternet {
  static bool isConnected(List<ConnectivityResult>? connectivityResult) {
    bool isInternet = false;
    if (connectivityResult?.contains(ConnectivityResult.mobile) ?? false) {
      isInternet = true;
    } else if (connectivityResult?.contains(ConnectivityResult.wifi) ?? false) {
      isInternet = true;
    } else if (connectivityResult?.contains(ConnectivityResult.ethernet) ??
        false) {
      isInternet = true;
    } else if (connectivityResult?.contains(ConnectivityResult.other) ??
        false) {
      isInternet = true;
    } else if (connectivityResult?.contains(ConnectivityResult.none) ?? false) {
      isInternet = false;
    } else {
      isInternet = false;
    }
    return isInternet;
  }
}
