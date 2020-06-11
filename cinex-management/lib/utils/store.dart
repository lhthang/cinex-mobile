import 'package:shared_preferences/shared_preferences.dart';

class Store {
  Future<bool> save(String saveKey, String saveValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = saveKey;
    final value = saveValue;
    return prefs.setString(key, value);
  }

  Future<String> get(String saveKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(saveKey) ?? "";
  }

  Future<bool> clear(String key) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<bool> clearAll() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
