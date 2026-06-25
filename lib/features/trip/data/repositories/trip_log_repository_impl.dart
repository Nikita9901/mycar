import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/trip_log_entry.dart';
import '../../domain/repositories/trip_log_repository.dart';
import '../datasources/trip_log_local_datasource.dart';

class TripLogRepositoryImpl implements TripLogRepository {
  const TripLogRepositoryImpl(this._ds);
  final TripLogLocalDatasource _ds;

  @override
  Future<void> saveTrip(TripLogEntry trip) => _ds.insertTrip(
        TripLogTableCompanion(
          id: Value(trip.id),
          carId: Value(trip.carId),
          startTime: Value(trip.startTime),
          endTime: Value(trip.endTime),
          distanceKm: Value(trip.distanceKm),
          durationSeconds: Value(trip.durationSeconds),
          confirmed: Value(trip.confirmed),
          autoTrip: Value(trip.autoTrip),
        ),
      );

  @override
  Future<void> confirmTrip(String tripId) => _ds.confirmTrip(tripId);

  @override
  Future<void> deleteTrip(String tripId) => _ds.deleteTrip(tripId);

  @override
  Future<List<TripLogEntry>> getPendingTrips(String carId) async {
    final rows = await _ds.getPendingTrips(carId);
    return rows.map(_toEntity).toList();
  }

  TripLogEntry _toEntity(TripLogTableData row) => TripLogEntry(
        id: row.id,
        carId: row.carId,
        startTime: row.startTime,
        endTime: row.endTime,
        distanceKm: row.distanceKm,
        durationSeconds: row.durationSeconds,
        confirmed: row.confirmed,
        autoTrip: row.autoTrip,
      );
}
