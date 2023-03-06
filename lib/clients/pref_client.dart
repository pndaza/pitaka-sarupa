import 'package:shared_preferences/shared_preferences.dart';

const _keyIsInitialized = 'is_initialized';
const _defaultIsInitialized = false;

const _keyDatabaseVersion = 'database_version';
const _defaultDatabaseVersion = 0;

class PrefClient {
  PrefClient._();
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static bool get isInitialized =>
      instance.getBool(_keyIsInitialized) ?? _defaultIsInitialized;
  static set isInitialized(bool value) =>
      instance.setBool(_keyIsInitialized, value);

  static int get databaseVerion =>
      instance.getInt(_keyDatabaseVersion) ?? _defaultDatabaseVersion;
  static set databaseVerion(int value) =>
      instance.setInt(_keyDatabaseVersion, value);
}
