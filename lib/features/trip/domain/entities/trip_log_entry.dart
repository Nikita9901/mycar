class TripLogEntry {
  const TripLogEntry({
    required this.id,
    required this.carId,
    required this.startTime,
    required this.endTime,
    required this.distanceKm,
    required this.durationSeconds,
    required this.confirmed,
    required this.autoTrip,
  });

  final String id;
  final String carId;
  final DateTime startTime;
  final DateTime endTime;
  final double distanceKm;
  final int durationSeconds;
  final bool confirmed;
  final bool autoTrip;

  int get distanceKmRounded => distanceKm.round();

  String get formattedDistance =>
      distanceKm >= 1 ? '${distanceKm.toStringAsFixed(2)} км' : '${(distanceKm * 1000).round()} м';

  String get formattedDuration {
    final h = durationSeconds ~/ 3600;
    final m = (durationSeconds % 3600) ~/ 60;
    if (h > 0) return '$h ч $m мин';
    return '$m мин';
  }
}
