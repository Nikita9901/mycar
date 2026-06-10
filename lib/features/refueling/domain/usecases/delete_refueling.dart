import '../repositories/refueling_repository.dart';

class DeleteRefueling {
  const DeleteRefueling(this._repository);

  final RefuelingRepository _repository;

  Future<void> call(String refuelingId) => _repository.deleteRefueling(refuelingId);
}
