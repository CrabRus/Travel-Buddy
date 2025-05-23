import 'package:shared_preferences/shared_preferences.dart';

class IndexStorageService {
  static const String _key = 'last_place_index';

  // Получить последний индекс (если нет — вернуть 0)
  static Future<int> getLastIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  // Сохранить новый индекс
  static Future<void> setLastIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, index);
  }
}