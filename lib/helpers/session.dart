import 'package:shared_preferences/shared_preferences.dart';

class Session {
  Future<bool> setSession(key, val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, val);
  }

  Future<String?> getSession(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> hasSession(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> removeSession(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveUserId(String userId) async {
    await setSession("userId", userId);
  }

  Future<String?> getUserId() async {
    return await getSession("userId");
  }

  Future<String?> getToken() async {
    return await getSession("token");
  }

  Future<void> saveToken(String token) async {
    await setSession("token", token);
  }
}
