import '../entities/refueling.dart';
import '../repositories/refueling_repository.dart';

class WatchRefuelingsForCar {
  const WatchRefuelingsForCar(this._repository);

  final RefuelingRepository _repository;

  Stream<List<Refueling>> call(String carId) =>
      _repository.watchRefuelingsForCar(carId);
}
