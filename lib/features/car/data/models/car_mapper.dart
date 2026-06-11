import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/car.dart';

class CarMapper {
  const CarMapper._();

  static Car fromTableData(CarTableData data) {
    return Car(
      id: data.id,
      brand: data.brand,
      model: data.model,
      currentOdometer: data.currentOdometer,
      licensePlate: data.licensePlate,
      vin: data.vin,
      fuelType: FuelType.fromValue(data.fuelType),
      createdAt: data.createdAt,
      insurancePdfPath: data.insurancePdfPath,
      insuranceExpiryDate: data.insuranceExpiryDate,
      lastOilChangeOdometer: data.lastOilChangeOdometer,
      avgFuelConsumption: data.avgFuelConsumption,
      fuelTankCapacity: data.fuelTankCapacity,
      currentFuelLevel: data.currentFuelLevel,
      techInspectionFilePath: data.techInspectionFilePath,
      techInspectionExpiryDate: data.techInspectionExpiryDate,
    );
  }

  static CarTableCompanion toCompanion(Car car) {
    return CarTableCompanion.insert(
      id: car.id,
      brand: car.brand,
      model: car.model,
      currentOdometer: car.currentOdometer,
      licensePlate: Value(car.licensePlate),
      vin: Value(car.vin),
      fuelType: Value(car.fuelType.value),
      createdAt: car.createdAt,
      insurancePdfPath: Value(car.insurancePdfPath),
      insuranceExpiryDate: Value(car.insuranceExpiryDate),
      lastOilChangeOdometer: Value(car.lastOilChangeOdometer),
      avgFuelConsumption: Value(car.avgFuelConsumption),
      fuelTankCapacity: Value(car.fuelTankCapacity),
      currentFuelLevel: Value(car.currentFuelLevel),
      techInspectionFilePath: Value(car.techInspectionFilePath),
      techInspectionExpiryDate: Value(car.techInspectionExpiryDate),
    );
  }
}
