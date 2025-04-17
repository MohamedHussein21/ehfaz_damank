import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putData({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences!.setBool(key, value);
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences!.remove(key);
  }

  /// Clears specific authentication-related data from SharedPreferences
  /// Returns true if operation was successful, false otherwise
  static Future<bool> clearAuthData() async {
    try {
      init();
      await removeData(key: 'api_token');
      await removeData(key: 'user_id');
      await sharedPreferences!.clear();
      return true;
    } catch (e) {
      print('Error clearing auth data: $e');
      return false;
    }
  }

  /// Clears all data from SharedPreferences
  /// Returns true if operation was successful, false otherwise
  static Future<bool> clearData() async {
    try {
      await sharedPreferences!.clear();
      return true;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }

  /// Performs a complete logout by clearing all user-related data
  /// Returns true if logout was successful, false otherwise
  static Future<bool> logout() async {
    try {
      // Step 1: Clear specific auth keys first
      print('Logout: Clearing auth-specific data...');
      await removeData(key: 'api_token');
      await removeData(key: 'user_id');

      // Step 2: Verify that the auth token is actually gone
      final apiTokenRemoved = sharedPreferences!.getString('api_token') == null;
      final userIdRemoved = sharedPreferences!.getInt('user_id') == null;

      if (!apiTokenRemoved || !userIdRemoved) {
        print('Warning: Auth data still exists after removal attempt');
        // If verification fails, try harder to remove them with direct calls
        if (!apiTokenRemoved) {
          await sharedPreferences!.remove('api_token');
        }
        if (!userIdRemoved) {
          await sharedPreferences!.remove('user_id');
        }
      }

      // Step 3: Clear all remaining data as a safety measure
      print('Logout: Clearing all remaining data...');
      await sharedPreferences!.clear();

      // Step 4: Final verification
      final keysRemaining = sharedPreferences!.getKeys();
      if (keysRemaining.isNotEmpty) {
        print(
            'Warning: ${keysRemaining.length} keys remain after logout: $keysRemaining');
        // Try one more time with a different approach
        await Future.forEach(keysRemaining, (String key) async {
          await sharedPreferences!.remove(key);
        });
      }

      print('Logout: Successfully cleared all user data');
      return true;
    } catch (e) {
      print('Error during logout: $e');
      // Try one last attempt with a simple clear
      try {
        await sharedPreferences!.clear();
        print('Logout: Fallback clear succeeded');
        return true;
      } catch (fallbackError) {
        print('Critical error during fallback logout: $fallbackError');
        return false;
      }
    }
  }
}
