// Use Case: получить заправки для автомобиля.

import '../entities/refueling.dart';
import '../repositories/refueling_repository.dart';

/// Возвращает список всех заправок для указанного автомобиля.
class GetRefuelingsForCar {
  const GetRefuelingsForCar(this._repository);

  final RefuelingRepository _repository;

  Future<List<Refueling>> call(String carId) =>
      _repository.getRefuelingsForCar(carId);
}
