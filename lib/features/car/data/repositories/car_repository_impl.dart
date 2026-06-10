// Реализация репозитория автомобилей (Data слой).
// Связывает Domain-контракт с реальным источником данных.

import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/car_local_datasource.dart';
import '../models/car_mapper.dart';

/// Реализует [CarRepository], используя [CarLocalDatasource] для работы с БД.
///
/// Именно этот класс регистрируется в DI-контейнере как реализация [CarRepository].
class CarRepositoryImpl implements CarRepository {
  const CarRepositoryImpl(this._datasource);

  final CarLocalDatasource _datasource;

  @override
  Future<List<Car>> getAllCars() async {
    final rows = await _datasource.getAllCars();
    return rows.map(CarMapper.fromTableData).toList();
  }

  @override
  Future<Car?> getCarById(String carId) async {
    final row = await _datasource.getCarById(carId);
    return row != null ? CarMapper.fromTableData(row) : null;
  }

  @override
  Future<void> addCar(Car car) {
    return _datasource.insertCar(CarMapper.toCompanion(car));
  }

  @override
  Future<void> updateCar(Car car) {
    return _datasource.updateCar(CarMapper.toCompanion(car));
  }

  @override
  Future<void> updateOdometer(String carId, int newOdometer) {
    return _datasource.updateOdometer(carId, newOdometer);
  }

  @override
  Future<void> deleteCar(String carId) {
    return _datasource.deleteCar(carId);
  }

  @override
  Stream<List<Car>> watchAllCars() {
    return _datasource
        .watchAllCars()
        .map((rows) => rows.map(CarMapper.fromTableData).toList());
  }
}
