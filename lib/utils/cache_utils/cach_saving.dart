import 'package:dr_mohamed_salah_admin/core/data/local/cache_helper.dart';
import 'package:dr_mohamed_salah_admin/utils/cache_utils/pref_keys.dart';

class CacheSave {
  static saveUserId(id) async =>
      await CacheHelper.saveData(key: PrefKeys.userId, value: id);

  static saveToken(token) async =>
      await CacheHelper.saveData(key: PrefKeys.token, value: token);
}
