import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<bool> getLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }

  static Future<String> getAuth0Token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth0Token');
  }

  static setAuth0Token(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth0Token', value);
  }

  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static setToken(String accessToken, [String refreshToken]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
    if (refreshToken != null) {
      prefs.setString('refreshToken', refreshToken);
    }
  }

  static Future<bool> hasOnboarded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarded') ?? false;
  }

  static setOnboarded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarded', true);
  }
}
