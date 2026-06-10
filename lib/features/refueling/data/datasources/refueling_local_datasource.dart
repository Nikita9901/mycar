// Локальный источник данных для заправок.

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Выполняет CRUD-операции над таблицей [RefuelingTable] через Drift.
class RefuelingLocalDatasource {
  const RefuelingLocalDatasource(this._database);

  final AppDatabase _database;

  /// Получить все заправки для автомобиля, отсортированные по дате (новые сверху).
  Future<List<RefuelingTableData>> getRefuelingsForCar(String carId) {
    return (_database.select(_database.refuelingTable)
          ..where((table) => table.carId.equals(carId))
          ..orderBy([(table) => OrderingTerm.desc(table.date)]))
        .get();
  }

  /// Получить заправки за период.
  Future<List<RefuelingTableData>> getRefuelingsForPeriod({
    required String carId,
    required DateTime from,
    required DateTime to,
  }) {
    return (_database.select(_database.refuelingTable)
          ..where((table) =>
              table.carId.equals(carId) &
              table.date.isBetweenValues(from, to))
          ..orderBy([(table) => OrderingTerm.desc(table.date)]))
        .get();
  }

  /// Получить последнюю заправку по дате.
  Future<RefuelingTableData?> getLastRefueling(String carId) {
    return (_database.select(_database.refuelingTable)
          ..where((table) => table.carId.equals(carId))
          ..orderBy([(table) => OrderingTerm.desc(table.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Вставить запись о заправке.
  Future<void> insertRefueling(RefuelingTableCompanion companion) {
    return _database.into(_database.refuelingTable).insert(companion);
  }

  /// Обновить запись о заправке.
  Future<void> updateRefueling(RefuelingTableCompanion companion) {
    return (_database.update(_database.refuelingTable)
          ..where((table) => table.id.equals(companion.id.value)))
        .write(companion);
  }

  /// Удалить запись о заправке.
  Future<void> deleteRefueling(String refuelingId) {
    return (_database.delete(_database.refuelingTable)
          ..where((table) => table.id.equals(refuelingId)))
        .go();
  }

  /// Поток заправок для автомобиля.
  Stream<List<RefuelingTableData>> watchRefuelingsForCar(String carId) {
    return (_database.select(_database.refuelingTable)
          ..where((table) => table.carId.equals(carId))
          ..orderBy([(table) => OrderingTerm.desc(table.date)]))
        .watch();
  }
}
