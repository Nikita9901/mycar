import '../entities/trip_log_entry.dart';
import '../repositories/trip_log_repository.dart';

class GetPendingTripLogs {
  const GetPendingTripLogs(this._repo);
  final TripLogRepository _repo;

  Future<List<TripLogEntry>> call(String carId) => _repo.getPendingTrips(carId);
}
