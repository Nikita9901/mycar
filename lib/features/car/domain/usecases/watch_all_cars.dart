// Use Case: реактивное наблюдение за списком автомобилей.

import '../entities/car.dart';
import '../repositories/car_repository.dart';

/// Возвращает [Stream] — живой поток данных об автомобилях.
///
/// Cubit подписывается на этот поток и автоматически обновляет UI
/// при любом изменении списка авто в БД.
class WatchAllCars {
  const WatchAllCars(this._repository);

  final CarRepository _repository;

  Stream<List<Car>> call() => _repository.watchAllCars();
}
