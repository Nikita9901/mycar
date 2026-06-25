import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── SharedPreferences ключи ────────────────────────────────────────────────
// (должны совпадать с BluetoothAutoTripService + BluetoothReceiver.kt)
const _keyAutoTripEnabled    = 'flutter.bt_auto_trip_enabled';
const _keyTripStartRequested = 'flutter.bt_trip_start_requested';
const _keyTripStopRequested  = 'flutter.bt_trip_stop_requested';

// Ключи для передачи результата фоновой поездки в основной изолят
const bgTripPendingKey          = 'flutter.bg_trip_pending';
const bgTripDistanceKmKey       = 'flutter.bg_trip_distance_km';
const bgTripDurationSecondsKey  = 'flutter.bg_trip_duration_seconds';
const bgTripStartTimeKey        = 'flutter.bg_trip_start_time';

// ─── Уведомление ─────────────────────────────────────────────────────────────
const _notifChannelId   = 'bg_trip_channel';
const _notifChannelName = 'Фоновая поездка';
const _notifId          = 891;

// ─── GPS константы ───────────────────────────────────────────────────────────
const _minAccuracyMeters             = 50.0;
const _minDistanceBetweenPointsMeters = 5.0;

// ─── Инициализация сервиса ────────────────────────────────────────────────────

Future<void> initializeTripBackgroundService() async {
  final service = FlutterBackgroundService();

  // Создаём канал уведомлений (нужно до configure на Android 8+)
  final notif = FlutterLocalNotificationsPlugin();
  const channel = AndroidNotificationChannel(
    _notifChannelId,
    _notifChannelName,
    importance: Importance.low,
    enableVibration: false,
    playSound: false,
  );
  await notif
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: _onBackgroundServiceStart,
      autoStart: true,
      isForegroundMode: false,
      notificationChannelId: _notifChannelId,
      initialNotificationTitle: 'DriveMind',
      initialNotificationContent: 'Ожидание подключения к автомобилю',
      foregroundServiceNotificationId: _notifId,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(autoStart: false),
  );
}

// ─── Точка входа фонового изолята ────────────────────────────────────────────

@pragma('vm:entry-point')
void _onBackgroundServiceStart(ServiceInstance service) async {
  // Состояние трекинга
  StreamSubscription<Position>? _posSub;
  Timer? _elapsedTimer;
  double _distanceMeters = 0;
  int _elapsedSeconds = 0;
  Position? _lastPosition;
  DateTime _startTime = DateTime.now();
  bool _tracking = false;

  final notifPlugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await notifPlugin.initialize(const InitializationSettings(android: androidInit));

  // ── Вспомогательные функции ──────────────────────────────────────────────

  void _showNotif(String title, String body) {
    notifPlugin.show(
      _notifId,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _notifChannelId,
          _notifChannelName,
          channelShowBadge: false,
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
        ),
      ),
    );
  }

  Future<void> _startTracking() async {
    if (_tracking) return;
    _tracking = true;
    _distanceMeters = 0;
    _elapsedSeconds = 0;
    _lastPosition = null;
    _startTime = DateTime.now();

    if (service is AndroidServiceInstance) {
      await (service as AndroidServiceInstance).setAsForegroundService();
    }
    _showNotif('Поездка начата', '0 км • 0:00');

    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      final km = (_distanceMeters / 1000).toStringAsFixed(2);
      final min = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
      final sec = (_elapsedSeconds % 60).toString().padLeft(2, '0');
      _showNotif('Поездка идёт', '$km км • $min:$sec');
    });

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    _posSub = Geolocator.getPositionStream(locationSettings: settings)
        .listen((pos) {
      if (pos.accuracy > _minAccuracyMeters) return;
      if (_lastPosition != null) {
        final d = _haversine(
          _lastPosition!.latitude, _lastPosition!.longitude,
          pos.latitude, pos.longitude,
        );
        if (d >= _minDistanceBetweenPointsMeters) {
          _distanceMeters += d;
          _lastPosition = pos;
        }
      } else {
        _lastPosition = pos;
      }
    });
  }

  Future<void> _stopTracking() async {
    if (!_tracking) return;
    _tracking = false;

    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    await _posSub?.cancel();
    _posSub = null;

    notifPlugin.cancel(_notifId);
    if (service is AndroidServiceInstance) {
      await (service as AndroidServiceInstance).setAsBackgroundService();
    }

    // Сохраняем результат в SharedPreferences для основного изолята
    if (_distanceMeters > 0) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(bgTripPendingKey, true);
      await prefs.setDouble(bgTripDistanceKmKey, _distanceMeters / 1000);
      await prefs.setInt(bgTripDurationSecondsKey, _elapsedSeconds);
      await prefs.setString(bgTripStartTimeKey, _startTime.toIso8601String());
    }
  }

  // ── Главный цикл опроса флагов (каждые 3 сек) ───────────────────────────
  Timer.periodic(const Duration(seconds: 3), (_) async {
    // reload() гарантирует актуальные данные (изолят кэширует при первом чтении)
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    // Если авто-поездки отключены — ничего не делаем
    final enabled = prefs.getBool(_keyAutoTripEnabled) ?? false;
    if (!enabled) return;

    if (!_tracking) {
      final startReq = prefs.getBool(_keyTripStartRequested) ?? false;
      if (startReq) {
        // Ждём 5 секунд: если приложение уже открыто, оно само обработает флаг
        // через lifecycle-событие и очистит его. Мы выступаем как fallback.
        await Future.delayed(const Duration(seconds: 5));
        await prefs.reload();
        final stillPending = prefs.getBool(_keyTripStartRequested) ?? false;
        if (!stillPending) return; // Основное приложение уже обработало
        // Основное приложение не смогло обработать → берём на себя
        await prefs.remove(_keyTripStartRequested);
        await _startTracking();
        return;
      }
    } else {
      final stopReq = prefs.getBool(_keyTripStopRequested) ?? false;
      if (stopReq) {
        await prefs.remove(_keyTripStopRequested);
        await _stopTracking();
      }
    }
  });

  // Слушаем команду остановки от UI (на случай ручной остановки)
  service.on('stopTracking').listen((_) async => await _stopTracking());
}

// ─── Haversine ────────────────────────────────────────────────────────────────

double _haversine(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371000.0;
  final dLat = _toRad(lat2 - lat1);
  final dLon = _toRad(lon2 - lon1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRad(lat1)) *
          math.cos(_toRad(lat2)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

double _toRad(double deg) => deg * math.pi / 180;
