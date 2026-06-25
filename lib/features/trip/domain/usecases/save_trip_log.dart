import '../entities/trip_log_entry.dart';
import '../repositories/trip_log_repository.dart';

class SaveTripLog {
  const SaveTripLog(this._repo);
  final TripLogRepository _repo;

  Future<void> call(TripLogEntry trip) => _repo.saveTrip(trip);
}
