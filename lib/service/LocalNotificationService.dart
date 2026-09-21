import 'package:bdt/ui/BDTScaffold.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../main.dart';

const CHANNEL_ID_BDT_SIGNALS = 'bdt_signals';
const CHANNEL_ID_BDT_FGS = 'bdt_foreground_notification';


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
      const AndroidInitializationSettings('@drawable/ic_bdt_bnw');


    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        macOS: null);

    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin.initialize(settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          final payload = response.payload;
          if (payload != null) {
            if (_notificationClickedHandler.isNotEmpty) {
              _handlePayload(false, payload);
            }
          }
        });
  }

  Future<void> showNotification(
      String receiverKey,
      int id,
      String title,
      String message,
      String channelId,
      String channelName,
      String channelDescription,
      bool keepAsProgress,
      bool ongoing,
      int? progress,
      String payload,
      Color? color) async {
    await _flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: message,
      notificationDetails: NotificationDetails(
          android: _createAndroidNotificationDetails(color, channelId, channelName, channelDescription, keepAsProgress, ongoing, progress)),
      payload: receiverKey + '-' + payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
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


  AndroidNotificationDetails _createAndroidNotificationDetails(
      Color? color,
      String channelId,
      String channelName,
      String channelDescription,
      bool keepAsProgress,
      bool ongoing,
      int? progress) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      color: color,
      playSound: false,
      vibrationPattern: null,
      enableVibration: false,
      usesChronometer: false,
      indeterminate: keepAsProgress && progress == null,
      showProgress: keepAsProgress,
      progress: progress??0,
      maxProgress: MAX_SLICE,
      autoCancel: false,
      ongoing: ongoing,
      priority: Priority.high,
      importance: Importance.high,
    );
  }

}

