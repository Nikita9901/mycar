import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../models/trip_log_table.dart';

class TripLogLocalDatasource {
  const TripLogLocalDatasource(this._db);
  final AppDatabase _db;

  Future<void> insertTrip(TripLogTableCompanion companion) =>
      _db.into(_db.tripLogTable).insert(companion);

  Future<void> confirmTrip(String tripId) =>
      (_db.update(_db.tripLogTable)..where((t) => t.id.equals(tripId)))
          .write(const TripLogTableCompanion(confirmed: Value(true)));

  Future<void> deleteTrip(String tripId) =>
      (_db.delete(_db.tripLogTable)..where((t) => t.id.equals(tripId))).go();

  Future<List<TripLogTableData>> getPendingTrips(String carId) =>
      (_db.select(_db.tripLogTable)
            ..where((t) => t.carId.equals(carId) & t.confirmed.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
          .get();
}
