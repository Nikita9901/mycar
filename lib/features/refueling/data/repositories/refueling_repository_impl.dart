// Реализация репозитория заправок (Data слой).

import '../../domain/entities/refueling.dart';
import '../../domain/repositories/refueling_repository.dart';
import '../datasources/refueling_local_datasource.dart';
import '../models/refueling_mapper.dart';

/// Реализует [RefuelingRepository] через [RefuelingLocalDatasource].
class RefuelingRepositoryImpl implements RefuelingRepository {
  const RefuelingRepositoryImpl(this._datasource);

  final RefuelingLocalDatasource _datasource;

  @override
  Future<List<Refueling>> getRefuelingsForCar(String carId) async {
    final rows = await _datasource.getRefuelingsForCar(carId);
    return rows.map(RefuelingMapper.fromTableData).toList();
  }

  @override
  Future<List<Refueling>> getRefuelingsForPeriod({
    required String carId,
    required DateTime from,
    required DateTime to,
  }) async {
    final rows = await _datasource.getRefuelingsForPeriod(
      carId: carId,
      from: from,
      to: to,
    );
    return rows.map(RefuelingMapper.fromTableData).toList();
  }

  @override
  Future<Refueling?> getLastRefueling(String carId) async {
    final row = await _datasource.getLastRefueling(carId);
    return row != null ? RefuelingMapper.fromTableData(row) : null;
  }

  @override
  Future<void> addRefueling(Refueling refueling) {
    return _datasource.insertRefueling(RefuelingMapper.toCompanion(refueling));
  }

  @override
  Future<void> updateRefueling(Refueling refueling) {
    return _datasource.updateRefueling(RefuelingMapper.toCompanion(refueling));
  }

  @override
  Future<void> deleteRefueling(String refuelingId) {
    return _datasource.deleteRefueling(refuelingId);
  }

  @override
  Stream<List<Refueling>> watchRefuelingsForCar(String carId) {
    return _datasource
        .watchRefuelingsForCar(carId)
        .map((rows) => rows.map(RefuelingMapper.fromTableData).toList());
  }
}
