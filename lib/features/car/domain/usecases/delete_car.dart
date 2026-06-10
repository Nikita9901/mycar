// Use Case: удалить автомобиль.

import '../repositories/car_repository.dart';

/// Удаляет автомобиль и все связанные записи (каскадно через БД).
class DeleteCar {
  const DeleteCar(this._repository);

  final CarRepository _repository;

  Future<void> call(String carId) => _repository.deleteCar(carId);
}
