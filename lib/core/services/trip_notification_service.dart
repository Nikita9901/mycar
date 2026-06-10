import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _kNotificationId = 42;
const _kChannelId = 'mycar_trip';
const _kStopActionId = 'stop_trip';

/// Callback вызывается когда пользователь нажимает «Остановить» в уведомлении.
/// Должен быть зарегистрирован до старта поездки.
typedef OnStopAction = void Function();

class TripNotificationService {
  TripNotificationService._();
  static final TripNotificationService instance = TripNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  OnStopAction? _onStop;

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: _onResponse,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundResponse,
    );
  }

  void registerStopCallback(OnStopAction cb) => _onStop = cb;

  /// Показывает / обновляет уведомление о текущей поездке.
  Future<void> show({
    required String distance,
    required String duration,
    required double speedKmh,
  }) async {
    final details = AndroidNotificationDetails(
      _kChannelId,
      'Поездка',
      channelDescription: 'Запись пробега',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showProgress: false,
      icon: '@mipmap/ic_launcher',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        '$distance · ${speedKmh.round()} км/ч',
        contentTitle: 'MyCar — запись поездки',
        summaryText: duration,
      ),
      actions: const [
        AndroidNotificationAction(
          _kStopActionId,
          'Остановить',
          cancelNotification: true,
          showsUserInterface: true,
        ),
      ],
    );

    await _plugin.show(
      _kNotificationId,
      'MyCar — запись поездки',
      '$distance · $duration · ${speedKmh.round()} км/ч',
      NotificationDetails(android: details),
    );
  }

  Future<void> cancel() => _plugin.cancel(_kNotificationId);

  void _onResponse(NotificationResponse response) {
    if (response.actionId == _kStopActionId) {
      _onStop?.call();
    }
  }
}

// Top-level callback для фонового изолята
@pragma('vm:entry-point')
void _onBackgroundResponse(NotificationResponse response) {
  // В фоне нельзя вызвать Flutter-код напрямую — пользователь увидит
  // что уведомление исчезло (cancelNotification: true) и при открытии
  // приложения поездка будет остановлена через флаг.
}
