import '../repositories/trip_log_repository.dart';

class ConfirmTripLog {
  const ConfirmTripLog(this._repo);
  final TripLogRepository _repo;

  Future<void> call(String tripId) => _repo.confirmTrip(tripId);
}
