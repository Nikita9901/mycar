// Use Case: добавить новый автомобиль.

import 'package:uuid/uuid.dart';

import '../entities/car.dart';
import '../repositories/car_repository.dart';

/// Параметры для создания нового автомобиля.
class AddCarParams {
  const AddCarParams({
    required this.brand,
    required this.model,
    required this.currentOdometer,
    required this.fuelType,
    this.licensePlate,
    this.vin,
    this.avgFuelConsumption,
    this.fuelTankCapacity,
    this.currentFuelLevel,
  });

  final String brand;
  final String model;
  final int currentOdometer;
  final FuelType fuelType;
  final String? licensePlate;
  final String? vin;
  final double? avgFuelConsumption;
  final int? fuelTankCapacity;
  final int? currentFuelLevel;
}

/// Создаёт новый объект [Car] с UUID и сохраняет его через репозиторий.
class AddCar {
  const AddCar(this._repository);

  final CarRepository _repository;

  Future<void> call(AddCarParams params) async {
    final Car newCar = Car(
      id: const Uuid().v4(),
      brand: params.brand,
      model: params.model,
      currentOdometer: params.currentOdometer,
      fuelType: params.fuelType,
      createdAt: DateTime.now(),
      licensePlate: params.licensePlate,
      vin: params.vin,
      avgFuelConsumption: params.avgFuelConsumption,
      fuelTankCapacity: params.fuelTankCapacity,
      currentFuelLevel: params.currentFuelLevel,
    );

    await _repository.addCar(newCar);
  }
}
