// Локальный источник данных для автомобилей.
// Инкапсулирует все SQL-запросы к таблице CarTable через Drift.

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Выполняет CRUD-операции над таблицей [CarTable] напрямую через Drift.
///
/// Репозиторий использует этот класс и не знает о деталях SQL.
class CarLocalDatasource {
  const CarLocalDatasource(this._database);

  final AppDatabase _database;

  /// Получить все автомобили, отсортированные по дате добавления.
  Future<List<CarTableData>> getAllCars() {
    return (_database.select(_database.carTable)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .get();
  }

  /// Получить автомобиль по идентификатору.
  Future<CarTableData?> getCarById(String carId) {
    return (_database.select(_database.carTable)
          ..where((table) => table.id.equals(carId)))
        .getSingleOrNull();
  }

  /// Вставить новый автомобиль.
  Future<void> insertCar(CarTableCompanion companion) {
    return _database.into(_database.carTable).insert(companion);
  }

  /// Обновить существующий автомобиль по всем полям.
  Future<void> updateCar(CarTableCompanion companion) {
    return (_database.update(_database.carTable)
          ..where((table) => table.id.equals(companion.id.value)))
        .write(companion);
  }

  /// Обновить только поле одометра — быстрая точечная операция.
  Future<void> updateOdometer(String carId, int newOdometer) {
    return (_database.update(_database.carTable)
          ..where((table) => table.id.equals(carId)))
        .write(CarTableCompanion(currentOdometer: Value(newOdometer)));
  }

  /// Удалить автомобиль по идентификатору.
  Future<void> deleteCar(String carId) {
    return (_database.delete(_database.carTable)
          ..where((table) => table.id.equals(carId)))
        .go();
  }

  /// Поток автомобилей — Drift пересылает новые данные при каждом изменении таблицы.
  Stream<List<CarTableData>> watchAllCars() {
    return (_database.select(_database.carTable)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .watch();
  }
}
