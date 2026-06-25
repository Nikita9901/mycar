import 'package:equatable/equatable.dart';

sealed class TripTrackingState extends Equatable {
  const TripTrackingState();
}

/// Поездка не идёт.
class TripIdle extends TripTrackingState {
  const TripIdle();
  @override
  List<Object?> get props => [];
}

/// Запрашиваем разрешение на геолокацию.
class TripRequestingPermission extends TripTrackingState {
  const TripRequestingPermission();
  @override
  List<Object?> get props => [];
}

/// Разрешение отклонено.
class TripPermissionDenied extends TripTrackingState {
  const TripPermissionDenied({required this.isPermanent});
  final bool isPermanent;
  @override
  List<Object?> get props => [isPermanent];
}

/// Идёт поездка — обновляется в реальном времени.
class TripInProgress extends TripTrackingState {
  const TripInProgress({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.speedKmh,
  });

  final double distanceMeters;
  final int durationSeconds;
  final double speedKmh;

  double get distanceKm => distanceMeters / 1000;

  String get formattedDistance {
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()} м';
    }
    return '${distanceKm.toStringAsFixed(2)} км';
  }

  String get formattedDuration {
    final h = durationSeconds ~/ 3600;
    final m = (durationSeconds % 3600) ~/ 60;
    final s = durationSeconds % 60;
    if (h > 0) return '${h}ч ${m.toString().padLeft(2, '0')}м';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [distanceMeters, durationSeconds, speedKmh];
}

/// Поездка завершена — показываем итоги.
class TripFinished extends TripTrackingState {
  const TripFinished({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.startTime,
    this.tripLogId,
    this.autoTrip = false,
  });

  final double distanceMeters;
  final int durationSeconds;
  final DateTime startTime;
  final String? tripLogId; // ID записи в БД (null если не сохранена)
  final bool autoTrip;

  double get distanceKm => distanceMeters / 1000;
  int get distanceKmRounded => (distanceMeters / 1000).round();

  String get formattedDistance => '${distanceKm.toStringAsFixed(2)} км';

  String get formattedDuration {
    final h = durationSeconds ~/ 3600;
    final m = (durationSeconds % 3600) ~/ 60;
    if (h > 0) return '${h} ч ${m} мин';
    return '$m мин';
  }

  @override
  List<Object?> get props => [distanceMeters, durationSeconds, startTime, tripLogId, autoTrip];
}
