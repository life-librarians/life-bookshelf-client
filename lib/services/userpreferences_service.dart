import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;
  static const _userTokenKey = 'user_token';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserToken(String userToken) async {
    await _preferences.setString(_userTokenKey, userToken);
  }

  static String getUserToken() {
    return _preferences.getString(_userTokenKey) ?? '';
  }
}