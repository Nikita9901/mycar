import 'dart:io';

import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kNotificationId = 42;
const _kChannelId = 'mycar_trip_v2'; // новый ID — сбрасывает старый канал с низким importance
const _kStopActionId = 'stop_trip';

/// Ключ для передачи сигнала «остановить» из фонового изолята в основной.
const kTripStopRequestedKey = 'trip_stop_requested';

typedef OnStopAction = void Function();

class TripNotificationService {
  TripNotificationService._();
  static final TripNotificationService instance = TripNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  OnStopAction? _onStop;

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: iOS),
      onDidReceiveNotificationResponse: _onResponse,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundResponse,
    );

    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      // Подавляем канал geolocator — создаём его с min importance ДО того,
      // как geolocator создаст его сам. Это убирает дублирующее уведомление.
      const geolocatorChannel = AndroidNotificationChannel(
        'geolocator_background_channel',
        'GPS (фон)',
        importance: Importance.min,
        playSound: false,
        enableVibration: false,
        showBadge: false,
      );
      await androidPlugin?.createNotificationChannel(geolocatorChannel);

      // Основной канал для нашего уведомления о поездке.
      // defaultImportance — показывает иконку в строке состояния, без звука.
      const tripChannel = AndroidNotificationChannel(
        _kChannelId,
        'Активная поездка',
        description: 'Показывает информацию о текущей поездке',
        importance: Importance.defaultImportance,
        playSound: false,
        enableVibration: false,
        showBadge: false,
      );
      await androidPlugin?.createNotificationChannel(tripChannel);

      // Запрашиваем разрешение на уведомления (обязательно для Android 13+)
      await androidPlugin?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await iosPlugin?.requestPermissions(alert: true, badge: false, sound: false);
    }
  }

  void registerStopCallback(OnStopAction cb) => _onStop = cb;

  /// Проверяет флаг «остановить», выставленный из фонового изолята.
  Future<bool> checkAndClearStopRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final requested = prefs.getBool(kTripStopRequestedKey) ?? false;
    if (requested) await prefs.remove(kTripStopRequestedKey);
    return requested;
  }

  /// Показывает / обновляет уведомление о текущей поездке.
  Future<void> show({
    required String distance,
    required String duration,
    required double speedKmh,
  }) async {
    final speedStr = '${speedKmh.round()} км/ч';
    final details = AndroidNotificationDetails(
      _kChannelId,
      'Активная поездка',
      channelDescription: 'Показывает информацию о текущей поездке',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ongoing: true,
      autoCancel: false,
      playSound: false,
      enableVibration: false,
      onlyAlertOnce: true,
      icon: '@mipmap/ic_launcher',
      color: const Color.fromARGB(0xFF, 0x34, 0xC7, 0x59),
      styleInformation: BigTextStyleInformation(
        'Расстояние: $distance   Скорость: $speedStr\nВремя: $duration',
        contentTitle: 'Поездка записывается',
        htmlFormatBigText: false,
        htmlFormatContentTitle: false,
      ),
      actions: const [
        AndroidNotificationAction(
          _kStopActionId,
          'Завершить поездку',
          cancelNotification: false,
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    await _plugin.show(
      _kNotificationId,
      'Поездка записывается',
      '$distance  $duration  $speedStr',
      NotificationDetails(android: details, iOS: iosDetails),
    );
  }

  Future<void> cancel() => _plugin.cancel(_kNotificationId);

  void _onResponse(NotificationResponse response) {
    if (response.actionId == _kStopActionId) {
      _onStop?.call();
    }
  }
}

@pragma('vm:entry-point')
void _onBackgroundResponse(NotificationResponse response) async {
  if (response.actionId == _kStopActionId) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kTripStopRequestedKey, true);
  }
}
