// Use Case: обновить данные автомобиля.

import '../entities/car.dart';
import '../repositories/car_repository.dart';

/// Сохраняет изменения в существующем автомобиле.
class UpdateCar {
  const UpdateCar(this._repository);

  final CarRepository _repository;

  Future<void> call(Car car) => _repository.updateCar(car);
}
