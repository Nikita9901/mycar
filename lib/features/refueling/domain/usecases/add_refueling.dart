// Use Case: добавить запись о заправке.

import 'package:uuid/uuid.dart';

import '../entities/refueling.dart';
import '../repositories/refueling_repository.dart';
import '../../../car/domain/repositories/car_repository.dart';

/// Параметры для создания новой записи о заправке.
class AddRefuelingParams {
  const AddRefuelingParams({
    required this.carId,
    required this.date,
    required this.odometer,
    required this.liters,
    required this.totalCost,
    required this.isFullTank,
    this.stationName,
  });

  final String carId;
  final DateTime date;
  final int odometer;
  final double liters;
  final double totalCost;
  final bool isFullTank;
  final String? stationName;
}

/// Добавляет запись о заправке и обновляет одометр автомобиля.
///
/// Бизнес-правило: после добавления заправки одометр машины
/// обновляется до нового значения, если оно больше текущего.
class AddRefueling {
  const AddRefueling({
    required RefuelingRepository refuelingRepository,
    required CarRepository carRepository,
  })  : _refuelingRepository = refuelingRepository,
        _carRepository = carRepository;

  final RefuelingRepository _refuelingRepository;
  final CarRepository _carRepository;

  Future<void> call(AddRefuelingParams params) async {
    final Refueling newRefueling = Refueling(
      id: const Uuid().v4(),
      carId: params.carId,
      date: params.date,
      odometer: params.odometer,
      liters: params.liters,
      totalCost: params.totalCost,
      isFullTank: params.isFullTank,
      stationName: params.stationName,
    );

    // Сохраняем запись о заправке
    await _refuelingRepository.addRefueling(newRefueling);

    // Обновляем одометр автомобиля, если новое значение больше текущего
    final car = await _carRepository.getCarById(params.carId);
    if (car != null && params.odometer > car.currentOdometer) {
      await _carRepository.updateOdometer(params.carId, params.odometer);
    }
  }
}
