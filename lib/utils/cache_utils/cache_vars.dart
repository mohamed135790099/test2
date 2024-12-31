import 'package:dr_mohamed_salah_admin/core/data/local/cache_helper.dart';
import 'package:dr_mohamed_salah_admin/utils/cache_utils/pref_keys.dart';

class CacheVars {
  static String? get userId => CacheHelper.getData(key: PrefKeys.userId);

  static String? get token => CacheHelper.getData(key: PrefKeys.token);
}
