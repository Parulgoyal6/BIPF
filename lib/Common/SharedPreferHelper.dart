
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferHelper{

  static Future<bool> getIsLoginValue(){
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      return prefs.getBool('isLoggedIn') ?? false;
    });
  }

  static Future<bool> setIsloginValue(bool value){
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      return prefs.setBool('isLoggedIn',value) ;
    });
  }
  static Future<String> getPrefString(String key, [String? s]) {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      return prefs.getString(key) ?? "";
    });
  }

  static Future<void> setPrefString(String key, String value) async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setString(key, value);
    });
  }
  static Future<int> getPrefInt(String key, [int defaultValue = 0]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? defaultValue;
  }

  static Future<void> setPrefInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
  static Future<bool> setIsPrecValue(bool value){
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      return prefs.setBool('qq',value) ;
    });
  }


  static Future<String> getpref(String key, [String? s]) {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      return prefs.getString(key) ?? "";
    });
  }

}