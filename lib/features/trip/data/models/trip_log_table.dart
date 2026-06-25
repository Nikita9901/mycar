import 'package:drift/drift.dart';

class TripLogTable extends Table {
  TextColumn get id => text()();
  TextColumn get carId => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  RealColumn get distanceKm => real()();
  IntColumn get durationSeconds => integer()();
  BoolColumn get confirmed =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get autoTrip =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
