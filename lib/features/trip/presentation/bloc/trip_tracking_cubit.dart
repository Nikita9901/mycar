import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/trip_notification_service.dart';
import 'trip_tracking_state.dart';

class TripTrackingCubit extends Cubit<TripTrackingState> {
  TripTrackingCubit() : super(const TripIdle()) {
    TripNotificationService.instance.registerStopCallback(_onNotificationStop);
  }

  StreamSubscription<Position>? _positionSub;
  Timer? _uiTimer;
  Timer? _notifTimer;

  Position? _lastPosition;
  double _totalDistanceMeters = 0;
  int _elapsedSeconds = 0;
  double _currentSpeedKmh = 0;

  static const double _minAccuracyMeters = 50;
  static const double _minDistanceBetweenPointsMeters = 5;

  /// Запускает поездку: запрашивает разрешение и стартует GPS.
  Future<void> startTrip() async {
    emit(const TripRequestingPermission());

    final permission = await _requestPermission();
    if (permission == null) return;

    _totalDistanceMeters = 0;
    _elapsedSeconds = 0;
    _currentSpeedKmh = 0;
    _lastPosition = null;

    emit(const TripInProgress(
      distanceMeters: 0,
      durationSeconds: 0,
      speedKmh: 0,
    ));

    // Таймер UI — каждую секунду
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      _emitProgress();
    });

    // Таймер уведомлений — каждые 10 секунд
    _notifTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _updateNotification();
    });
    _updateNotification(); // сразу при старте

    // GPS стрим
    _positionSub = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        intervalDuration: const Duration(seconds: 5),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'MyCar',
          notificationText: 'GPS активен — идёт запись пробега',
        ),
      ),
    ).listen(_onPosition, onError: (_) {});
  }

  void _onPosition(Position pos) {
    if (pos.accuracy > _minAccuracyMeters) return;
    _currentSpeedKmh = pos.speed >= 0 ? pos.speed * 3.6 : 0;

    if (_lastPosition != null) {
      final dist = _haversineMeters(
        _lastPosition!.latitude, _lastPosition!.longitude,
        pos.latitude, pos.longitude,
      );
      if (dist >= _minDistanceBetweenPointsMeters) {
        _totalDistanceMeters += dist;
        _lastPosition = pos;
      }
    } else {
      _lastPosition = pos;
    }
    _emitProgress();
  }

  void _emitProgress() {
    if (isClosed) return;
    emit(TripInProgress(
      distanceMeters: _totalDistanceMeters,
      durationSeconds: _elapsedSeconds,
      speedKmh: _currentSpeedKmh,
    ));
  }

  Future<void> _updateNotification() async {
    final s = state;
    if (s is! TripInProgress) return;
    await TripNotificationService.instance.show(
      distance: s.formattedDistance,
      duration: s.formattedDuration,
      speedKmh: s.speedKmh,
    );
  }

  void _onNotificationStop() {
    if (state is TripInProgress) stopTrip();
  }

  /// Завершает поездку.
  Future<TripFinished> stopTrip() async {
    await _stopTracking();
    await TripNotificationService.instance.cancel();
    final finished = TripFinished(
      distanceMeters: _totalDistanceMeters,
      durationSeconds: _elapsedSeconds,
    );
    emit(finished);
    return finished;
  }

  /// Отменяет поездку без сохранения.
  Future<void> cancelTrip() async {
    await _stopTracking();
    await TripNotificationService.instance.cancel();
    emit(const TripIdle());
  }

  void dismiss() => emit(const TripIdle());

  Future<void> _stopTracking() async {
    _uiTimer?.cancel();
    _uiTimer = null;
    _notifTimer?.cancel();
    _notifTimer = null;
    await _positionSub?.cancel();
    _positionSub = null;
  }

  Future<LocationPermission?> _requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(const TripPermissionDenied(isPermanent: false));
      return null;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      emit(const TripPermissionDenied(isPermanent: false));
      return null;
    }
    if (permission == LocationPermission.deniedForever) {
      emit(const TripPermissionDenied(isPermanent: true));
      return null;
    }
    return permission;
  }

  static double _haversineMeters(
      double lat1, double lon1, double lat2, double lon2) {
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

  static double _toRad(double deg) => deg * math.pi / 180;

  @override
  Future<void> close() async {
    await _stopTracking();
    await TripNotificationService.instance.cancel();
    return super.close();
  }
}
