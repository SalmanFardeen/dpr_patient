import 'package:awesome_notifications/awesome_notifications.dart';

class AwesomeNotificationService {
  static AwesomeNotificationService _awesomeNotificationService = AwesomeNotificationService._internal();

  AwesomeNotificationService._internal();

  factory AwesomeNotificationService() {
    return _awesomeNotificationService;
  }

  final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();

  Future<void> init() async {
    await _awesomeNotifications.initialize(
        null,
        [            // notification icon
          NotificationChannel(
            channelGroupKey: 'basic_test',
            channelKey: 'basic',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            channelShowBadge: true,
            importance: NotificationImportance.High,
            enableVibration: true,
            playSound: true
          ),

        ]
    );
  }

  showNotification(String title, String body, Map<String, String> data) {
    _awesomeNotifications.createNotification(
        content: NotificationContent( //simgple notification
          id: 123,
          channelKey: 'basic', //set configuration wuth key "basic"
          title: title,
          body: body,
          payload: data,
          autoDismissible: false,
        ),

        actionButtons: [
          NotificationActionButton(
            key: "decline",
            label: "Decline",
          ),

          NotificationActionButton(
            key: "accept",
            label: "Accept",
          )
        ]
    );
  }
}