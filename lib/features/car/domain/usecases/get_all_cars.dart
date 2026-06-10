// Use Case: получить список всех автомобилей.

import '../entities/car.dart';
import '../repositories/car_repository.dart';

/// Возвращает список всех автомобилей пользователя.
///
/// Use Case инкапсулирует одно бизнес-действие и зависит только
/// от абстрактного [CarRepository].
class GetAllCars {
  const GetAllCars(this._repository);

  final CarRepository _repository;

  Future<List<Car>> call() => _repository.getAllCars();
}
