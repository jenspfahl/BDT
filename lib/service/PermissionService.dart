import 'package:permission_handler/permission_handler.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/foundation.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();

  factory PermissionService() {
    return _instance;
  }

  PermissionService._internal();

  /// Check and request SCHEDULE_EXACT_ALARM permission
  /// Returns true if permission is granted
  Future<bool> requestScheduleExactAlarmPermission() async {
    try {
      final status = await Permission.scheduleExactAlarm.request();
      debugPrint('scheduleExactAlarm permission status: $status');
      return status.isGranted;
    } catch (e) {
      debugPrint('Error requesting scheduleExactAlarm permission: $e');
      return false;
    }
  }

  /// Check current SCHEDULE_EXACT_ALARM permission status
  Future<bool> isScheduleExactAlarmGranted() async {
    try {
      final status = await Permission.scheduleExactAlarm.status;
      return status.isGranted;
    } catch (e) {
      debugPrint('Error checking scheduleExactAlarm permission: $e');
      return false;
    }
  }

  /// Check and request POST_NOTIFICATIONS permission
  /// Returns true if permission is granted
  Future<bool> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();
      debugPrint('notification permission status: $status');
      return status.isGranted;
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Check if battery optimization is disabled for the app
  /// Returns true if app is whitelisted from battery optimization
  Future<bool> isBatteryOptimizationDisabled() async {
    try {
      final isDisabled = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
      debugPrint('Battery optimization disabled: $isDisabled');
      return isDisabled == true;
    } catch (e) {
      debugPrint('Error checking battery optimization: $e');
      return false;
    }
  }

  /// Show battery optimization settings
  Future<void> openBatteryOptimizationSettings() async {
    try {
      await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    } catch (e) {
      debugPrint('Error opening battery optimization settings: $e');
    }
  }

  /// Validate all required permissions for timer operation on Android 12+
  /// Returns a list of missing requirements
  Future<List<String>> validateTimerPermissions() async {
    final missing = <String>[];

    // Check exact alarm permission
    final exactAlarmGranted = await isScheduleExactAlarmGranted();
    if (!exactAlarmGranted) {
      missing.add('SCHEDULE_EXACT_ALARM permission not granted');
    }

    // Check battery optimization
    final batteryOptDisabled = await isBatteryOptimizationDisabled();
    if (!batteryOptDisabled) {
      missing.add('Battery optimization not disabled');
    }

    return missing;
  }

  /// Request all required permissions for timer operation
  /// Shows user dialogs as needed
  /// Returns true if all permissions are granted
  Future<bool> requestAllTimerPermissions() async {
    // Request exact alarm permission
    final exactAlarmGranted = await requestScheduleExactAlarmPermission();
    
    if (!exactAlarmGranted) {
      debugPrint('⚠️ SCHEDULE_EXACT_ALARM permission was not granted');
    }

    // Check battery optimization
    final batteryOptDisabled = await isBatteryOptimizationDisabled();
    if (!batteryOptDisabled) {
      debugPrint('⚠️ Battery optimization is still enabled');
      // User may need to manually disable this
      await openBatteryOptimizationSettings();
    }

    // Verify all permissions are now satisfied
    final missing = await validateTimerPermissions();
    return missing.isEmpty;
  }
}
