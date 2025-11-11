import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService instance = SettingsService._init();
  SharedPreferences? _prefs;

  SettingsService._init();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('SettingsService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Theme preferences
  Future<void> setDarkMode(bool enabled) async {
    await prefs.setBool('dark_mode', enabled);
  }

  bool getDarkMode() {
    return prefs.getBool('dark_mode') ?? false;
  }

  // Notification preferences
  Future<void> setNotificationsEnabled(bool enabled) async {
    await prefs.setBool('notifications_enabled', enabled);
  }

  bool getNotificationsEnabled() {
    return prefs.getBool('notifications_enabled') ?? true;
  }

  Future<void> setReminderTime(String time) async {
    await prefs.setString('reminder_time', time);
  }

  String? getReminderTime() {
    return prefs.getString('reminder_time');
  }

  // Measurement preferences
  Future<void> setPreferredJoint(String joint) async {
    await prefs.setString('preferred_joint', joint);
  }

  String? getPreferredJoint() {
    return prefs.getString('preferred_joint');
  }

  Future<void> setMeasurementUnit(String unit) async {
    await prefs.setString('measurement_unit', unit);
  }

  String getMeasurementUnit() {
    return prefs.getString('measurement_unit') ?? 'degrees';
  }

  // Onboarding
  Future<void> setOnboardingCompleted(bool completed) async {
    await prefs.setBool('onboarding_completed', completed);
  }

  bool getOnboardingCompleted() {
    return prefs.getBool('onboarding_completed') ?? false;
  }

  // Sync preferences
  Future<void> setAutoSyncEnabled(bool enabled) async {
    await prefs.setBool('auto_sync_enabled', enabled);
  }

  bool getAutoSyncEnabled() {
    return prefs.getBool('auto_sync_enabled') ?? true;
  }

  Future<void> setLastSyncTime(DateTime time) async {
    await prefs.setString('last_sync_time', time.toIso8601String());
  }

  DateTime? getLastSyncTime() {
    final timeStr = prefs.getString('last_sync_time');
    return timeStr != null ? DateTime.parse(timeStr) : null;
  }

  // Clear all settings
  Future<void> clearAll() async {
    await prefs.clear();
  }
}
