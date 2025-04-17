import 'package:hive/hive.dart';

/// TypeId for different Hive box types
class HiveBoxTypes {
  static const int authBox = 0;
  static const int settingsBox = 1;
}

/// Box names for different Hive boxes
class HiveBoxNames {
  static const String auth = 'auth_box';
  static const String settings = 'settings_box';
  static const String general = 'general_box';
}

/// Key names used in Hive boxes for consistency
class HiveKeys {
  // Auth related keys
  static const String apiToken = 'api_token';
  static const String userId = 'user_id';
  static const String isLoggedIn = 'is_logged_in';

  // Settings related keys
  static const String locale = 'locale';
  static const String theme = 'theme';
  static const String notifications = 'notifications';
}

/// Auth data stored in Hive
/// This class is used to store authentication-related data
@HiveType(typeId: HiveBoxTypes.authBox)
class AuthBox {
  @HiveField(0)
  String? apiToken;

  @HiveField(1)
  int? userId;

  @HiveField(2)
  bool isLoggedIn;

  @HiveField(3)
  DateTime? lastLoginTime;

  AuthBox({
    this.apiToken,
    this.userId,
    this.isLoggedIn = false,
    this.lastLoginTime,
  });

  /// Check if the user is authenticated
  bool get isAuthenticated => apiToken != null && userId != null && isLoggedIn;

  /// Clear auth data
  void clear() {
    apiToken = null;
    userId = null;
    isLoggedIn = false;
    lastLoginTime = null;
  }

  /// Create AuthBox from new login
  static AuthBox fromLogin({required String apiToken, required int userId}) {
    return AuthBox(
      apiToken: apiToken,
      userId: userId,
      isLoggedIn: true,
      lastLoginTime: DateTime.now(),
    );
  }
}
