import '../entities/trip_log_entry.dart';

abstract class TripLogRepository {
  Future<void> saveTrip(TripLogEntry trip);
  Future<void> confirmTrip(String tripId);
  Future<void> deleteTrip(String tripId);
  Future<List<TripLogEntry>> getPendingTrips(String carId);
}
