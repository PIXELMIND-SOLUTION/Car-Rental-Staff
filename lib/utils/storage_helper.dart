import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _userIdKey = 'userId';
  static const String _userName = 'userName';
  static const String _mobile = 'mobile';
  static const String _profileImage = 'profileImage';

  static Future<void> saveUserId(
      String userId, String userName, String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userName, userName);
    await prefs.setString(_mobile, mobile);
  }

  static Future<void> updateProfileImage(
    String userId,
    String userName, 
    String mobile,
    String profileImage,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userName, userName);
    await prefs.setString(_mobile, mobile);
    await prefs.setString(_profileImage, profileImage);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

    static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImage);
  }

  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userName);
    await prefs.remove(_mobile);
    await prefs.remove(_profileImage);

  }
}
