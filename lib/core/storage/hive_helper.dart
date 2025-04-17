import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/auth_box.dart';

/// HiveHelper is a utility class for managing local storage with Hive
/// It replaces the previous SharedPreferences-based CashHelper
class HiveHelper {
  static Box<dynamic>? _generalBox;
  static Box<AuthBox>? _authBox;
  static Box<dynamic>? _settingsBox;
  
  /// Initialize Hive and register adapters
  static Future<void> init() async {
    try {
      // Initialize Hive with path provider
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
      
      // Register adapters
      if (!Hive.isAdapterRegistered(HiveBoxTypes.authBox)) {
        Hive.registerAdapter(AuthBoxAdapter());
      }
      
      // Open boxes
      _generalBox = await Hive.openBox<dynamic>(HiveBoxNames.general);
      _authBox = await Hive.openBox<AuthBox>(HiveBoxNames.auth);
      _settingsBox = await Hive.openBox<dynamic>(HiveBoxNames.settings);
      
      // Migrate data from SharedPreferences if needed
      await _migrateFromSharedPreferences();
      
      log('Hive initialized successfully');
    } catch (e) {
      log('Error initializing Hive: $e');
      // Fallback to default paths if needed
      try {
        await Hive.initFlutter();
        
        // Register adapters
        if (!Hive.isAdapterRegistered(HiveBoxTypes.authBox)) {
          Hive.registerAdapter(AuthBoxAdapter());
        }
        
        // Open boxes
        _generalBox = await Hive.openBox<dynamic>(HiveBoxNames.general);
        _authBox = await Hive.openBox<AuthBox>(HiveBoxNames.auth);
        _settingsBox = await Hive.openBox<dynamic>(HiveBoxNames.settings);
        
        log('Hive initialized with fallback path');
      } catch (fallbackError) {
        log('Critical Hive initialization error: $fallbackError');
      }
    }
  }
  
  /// Migrate data from SharedPreferences to Hive
  static Future<void> _migrateFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if migration has already been done
      if (_generalBox?.get('migrated_from_shared_prefs') == true) {
        return;
      }
      
      // Migrate auth data
      final apiToken = prefs.getString('api_token');
      final userId = prefs.getInt('user_id');
      
      if (apiToken != null && userId != null) {
        await saveAuth(apiToken: apiToken, userId: userId);
        log('Migrated auth data from SharedPreferences');
      }
      
      // Migrate locale
      final locale = prefs.getString('locale');
      if (locale != null) {
        await _settingsBox?.put(HiveKeys.locale, locale);
      }
      
      // Mark migration as complete
      await _generalBox?.put('migrated_from_shared_prefs', true);
      
      // Optionally clear SharedPreferences data
      // Only uncomment after thorough testing
      // await prefs.clear();
      
      log('Migration from SharedPreferences completed');
    } catch (e) {
      log('Error migrating from SharedPreferences: $e');
    }
  }
  
  /// Save authentication data
  static Future<bool> saveAuth({
    required String apiToken,
    required int userId,
  }) async {
    try {
      // Create AuthBox instance
      final authBox = AuthBox.fromLogin(
        apiToken: apiToken,
        userId: userId,
      );
      
      // Save to auth box
      await _authBox?.put(HiveKeys.isLoggedIn, authBox);
      
      // For backward compatibility also save to general box
      await _generalBox?.put(HiveKeys.apiToken, apiToken);
      await _generalBox?.put(HiveKeys.userId, userId);
      
      return true;
    } catch (e) {
      log('Error saving auth data: $e');
      return false;
    }
  }
  
  /// Get authentication data
  static AuthBox? getAuth() {
    try {
      return _authBox?.get(HiveKeys.isLoggedIn);
    } catch (e) {
      log('Error getting auth data: $e');
      return null;
    }
  }
  
  /// Check if user is authenticated
  static bool isAuthenticated() {
    final auth = getAuth();
    return auth?.isAuthenticated ?? false;
  }
  
  /// Get API token
  static String? getApiToken() {
    return getAuth()?.apiToken ?? _generalBox?.get(HiveKeys.apiToken);
  }
  
  /// Get user ID
  static int? getUserId() {
    return getAuth()?.userId ?? _generalBox?.get(HiveKeys.userId);
  }
  
  /// Clear authentication data (logout)
  static Future<bool> logout() async {
    try {
      log('Logout: Clearing auth data...');
      
      // Clear auth box
      final auth = getAuth();
      if (auth != null) {
        auth.clear();
        await _authBox?.put(HiveKeys.isLoggedIn, auth);
      }
      
      // For thorough cleanup, also remove from general box
      await _generalBox?.delete(HiveKeys.apiToken);
      await _generalBox?.delete(HiveKeys.userId);
      
      // Verify data is cleared
      final apiTokenRemoved = getApiToken() == null;
      final userIdRemoved = getUserId() == null;
      
      if (!apiTokenRemoved || !userIdRemoved) {
        log('Warning: Auth data still exists after removal attempt');
        
        // Final attempt to clear data
        await _authBox?.clear();
        await _generalBox?.delete(HiveKeys.apiToken);
        await _generalBox?.delete(HiveKeys.userId);
      }
      
      log('Logout: Successfully cleared all auth data');
      return true;
    } catch (e) {
      log('Error during logout: $e');
      
      // Final fallback attempt
      try {
        await _authBox?.clear();
        await _generalBox?.delete(HiveKeys.apiToken);
        await _generalBox?.delete(HiveKeys.userId);
        log('Logout: Fallback clear succeeded');
        return true;
      } catch (fallbackError) {
        log('Critical error during fallback logout: $fallbackError');
        return false;
      }
    }
  }
  
  /// Save general data with type safety
  static Future<bool> saveData<T>({
    required String key,
    required T value,
  }) async {
    try {
      await _generalBox?.put(key, value);
      return true;
    } catch (e) {
      log('Error saving data: $e');
      return false;
    }
  }
  
  /// Get general data with type safety
  static T? getData<T>({
    required String key,
    T? defaultValue,
  }) {
    try {
      final value = _generalBox?.get(key, defaultValue: defaultValue);
      if (value != null && value is T) {
        return value;
      }
      return defaultValue;
    } catch (e) {
      log('Error getting data: $e');
      return defaultValue;
    }
  }
  
  /// Save settings data
  static Future<bool> saveSetting<T>({
    required String key,
    required T value,
  }) async {
    try {
      await _settingsBox?.put(key, value);
      return true;
    } catch (e) {
      log('Error saving setting: $e');
      return false;
    }
  }
  
  /// Get settings data
  static T? getSetting<T>({
    required String key,
    T? defaultValue,
  }) {
    try {
      final value = _settingsBox?.get(key, defaultValue: defaultValue);
      if (value != null && value is T) {
        return value;
      }
      return defaultValue;
    } catch (e) {
      log('Error getting setting: $e');
      return defaultValue;
    }
  }
  
  /// Remove data from storage
  static Future<bool> removeData({
    required String key,
  }) async {
    try {
      await _generalBox?.delete(key);
      return true;
    } catch (e) {
      log('Error removing data: $e');
      return false;
    }
  }
  
  /// Clear all data from storage
  static Future<bool> clearData() async {
    try {
      await _generalBox?.clear();
      await _authBox?.clear();
      await _settingsBox?.clear();
      return true;
    } catch (e) {
      log('Error clearing all data: $e');
      return false;
    }
  }
  
  /// Close all Hive boxes (usually on app exit)
  static Future<void> closeBoxes() async {
    await Hive.close();
  }
}

/// AuthBoxAdapter class
/// This will be automatically generated but included here for completeness
/// Run "flutter pub run build_runner build" to generate the actual adapter
class AuthBoxAdapter extends TypeAdapter<AuthBox> {
  @override
  final int typeId = HiveBoxTypes.authBox;
  
  @override
  AuthBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthBox(
      apiToken: fields[0] as String?,
      userId: fields[1] as int?,
      isLoggedIn: fields[2] as bool,
      lastLoginTime: fields[3] as DateTime?,
    );
  }
  
  @override
  void write(BinaryWriter writer, AuthBox obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.apiToken)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.isLoggedIn)
      ..writeByte(3)
      ..write(obj.lastLoginTime);
  }
  
  @override
  int get hashCode => typeId.hashCode;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

