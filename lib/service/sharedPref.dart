import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String key = "logged userID";
  static Future<void> setLoggedUserID(String userID) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(key);
    pref.setString(key, userID);
  }

  static Future<String> getLoggedUserID() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  static Future<void> removeLoggedUserID() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }
}
