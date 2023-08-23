import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

const CHANNEL_ID_BDT = 'de.jepfa.bdt.notifications';


// stolen from https://github.com/iloveteajay/flutter_local_notification/https://github.com/iloveteajay/flutter_local_notification/
class LocalNotificationService {

  static final LocalNotificationService _notificationService = LocalNotificationService._internal();

  static List<Function(String receiverKey, bool isAppLaunch, String payload)> _notificationClickedHandler = [];
  static List<Function(int id, String? channelId)> _activeNotificationHandler = [];

  factory LocalNotificationService() {
    return _notificationService;
  }

  LocalNotificationService._internal();
  
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void addNotificationClickedHandler(Function(String receiverKey, bool isAppLaunch, String payload) handler) {
    _notificationClickedHandler.add(handler);
  }

  void removeNotificationClickedHandler(Function(String receiverKey, bool isAppLaunch, String payload) handler) {
    _notificationClickedHandler.remove(handler);
  }

  void addActiveNotificationHandler(Function(int id, String? channelId) handler) {
    _activeNotificationHandler.add(handler);
  }

  void removeActiveNotificationHandler(Function(int id, String? channelId) handler) {
    _activeNotificationHandler.remove(handler);
  }


  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_bdt_bnw');


    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        macOS: null);

    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          final payload = response.payload;
          if (payload != null) {
            if (_notificationClickedHandler.isNotEmpty) {
              _handlePayload(false, payload);
            }
          }
        });
  }

  Future<void> showNotification(String receiverKey, int id, String title, String message, String channelId, bool keepAsProgress, bool ongoing, int? progress, String payload, [Color? color]) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title, 
      message,
      NotificationDetails(android: _createAndroidNotificationDetails(color, channelId, keepAsProgress, ongoing, progress)),
      payload: receiverKey + '-' + payload,
    );
  }

  Future<void> scheduleNotification(String receiverKey, int id, String title, message, Duration duration, String channelId, [Color? color]) async {
    final when = tz.TZDateTime.now(tz.local).add(duration);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        message,
        when.subtract(Duration(seconds: when.second)), // trunc seconds
        NotificationDetails(android: _createAndroidNotificationDetails(color, channelId, false, false, null)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: receiverKey + '-' + id.toString());
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  void handleAppLaunchNotification() {
    _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails()
        .then((notification) {
          final payload = notification?.notificationResponse?.payload;
          if (payload != null) {
            _handlePayload(true, payload);
          }
    });

    _flutterLocalNotificationsPlugin.pendingNotificationRequests().then((pendingNotifications) {
      pendingNotifications.forEach((element) {debugPrint('pending notification: ${element.id} ${element.title} ${element.payload}');});
    });

    AndroidFlutterLocalNotificationsPlugin? nativePlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation();
    nativePlugin?.getActiveNotifications().then((activeNotifications) {
      activeNotifications.forEach((element) {
         final id = element.id;
         if (id != null) _handleActiveNotification(id, element.channelId);
      });

    });
  }

  void _handlePayload(bool isAppLaunch, String payload) {
    debugPrint('_handlePayload=$payload $isAppLaunch');

    var index = payload.indexOf('-');
    if (index != -1) {
      final receiverKey = payload.substring(0, index);
      final actualPayload = payload.substring(index + 1);
      _notificationClickedHandler.forEach((h) => h.call(receiverKey, isAppLaunch, actualPayload));
    }
  }
  
  void _handleActiveNotification(int id, String? channelId) {
    debugPrint('active notification: $id $channelId');
    _activeNotificationHandler.forEach((h) => h.call(id, channelId));
  }


  AndroidNotificationDetails _createAndroidNotificationDetails(Color? color, String channelId, bool keepAsProgress, bool ongoing, int? progress) {
    return AndroidNotificationDetails(
      channelId,
      APP_NAME,
      channelDescription: 'Timer points',
      color: color,
      playSound: false,
      vibrationPattern: null,
      enableVibration: false,
      usesChronometer: false,
      indeterminate: keepAsProgress && progress == null,
      showProgress: keepAsProgress,
      progress: progress??0,
      maxProgress: 100,
      autoCancel: false,
      icon: null, //TODO have TaskGroup Icons would be an option
      ongoing: ongoing,
      priority: Priority.high,
      importance: Importance.high,
    );
  }
}

