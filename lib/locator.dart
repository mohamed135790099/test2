import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/repositories/sign_in_repo.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/repositories/more_repo.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/repositories/electronic_prescription_repo.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/repositories/reservations_repo.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static init() {
    sl.registerLazySingleton(() => Connectivity());
    sl.registerLazySingleton<SignInRepo>(() => SignInRepo());
    sl.registerLazySingleton<ReservationsRepo>(() => ReservationsRepo());
    sl.registerLazySingleton<MoreRepo>(() => MoreRepo());
    sl.registerLazySingleton<ElectronicPrescriptionRepo>(
        () => ElectronicPrescriptionRepo());
  }
}
