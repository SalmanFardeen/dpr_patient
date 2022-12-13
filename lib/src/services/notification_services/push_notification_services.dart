import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/services/notification_services/awesome_local_notification_service.dart';
import 'package:dpr_patient/src/services/notification_services/local_notification_service.dart';
import 'package:dpr_patient/src/services/shared_preference_services/shared_prefs_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationServices {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // set up firebase push notification settings
  static void setUpFirebase() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LogDebugger.instance.i(message.toMap());
      if(message.notification?.title == 'Incoming Call') {
        Map<String, String> map = message.data['image'] != null
            ? {
                "room_id": message.data['room_id'],
                "image": message.data['image'],
                "name": message.data['name'],
                "other_id": message.data['other_id'],
                "is_video": message.data['is_video']
              }
            : {
                "room_id": message.data['room_id'],
                "name": message.data['name'],
                "other_id": message.data['other_id'],
                "is_video": message.data['is_video']
              };
        AwesomeNotificationService().showNotification(
            message.notification?.title ?? '',
            message.notification?.body ?? '',
            map);
      } else {
        _handleForegroundNotification(
        message.notification?.title ?? 'Unknown',
        message.notification?.body ?? 'Unknown',
      );
      }
    });
  }

  // set up firebase cloud messaging token
  static void getFirebaseCloudMessagingToken() async {
   /** check if your user is logged in or not
    if user logged in and your token was saved then it will get, either it will generate a new token **/

    String? deviceToken = SharedPrefsServices.getStringData('device_token');
    if (deviceToken == null || deviceToken == '') {
      _firebaseMessaging.getToken().then((token) {
        LogDebugger.instance.i("_firebaseMessaging.getToken : $token");
        _saveFCMTokenToPrefs(token!);
      });
    } else {
      // store you token where it needs
    }
  }

  // save fcm token to shared prefs if not available
  static Future<void> _saveFCMTokenToPrefs(String deviceToken) async {
      SharedPrefsServices.setStringData('device_token', deviceToken);
  }

  static void _handleForegroundNotification(String title, String body) async {
    await LocalNotificationService().showNotification(title, body);
  }

  static Future<void> subscribeTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
