import '../repositories/trip_log_repository.dart';

class DeleteTripLog {
  const DeleteTripLog(this._repo);
  final TripLogRepository _repo;

  Future<void> call(String tripId) => _repo.deleteTrip(tripId);
}
