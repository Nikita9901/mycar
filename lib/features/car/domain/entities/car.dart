import 'package:equatable/equatable.dart';

enum FuelType {
  gasoline('gasoline', 'Бензин'),
  diesel('diesel', 'Дизель'),
  lpg('lpg', 'Газ (LPG)'),
  electric('electric', 'Электро'),
  hybrid('hybrid', 'Гибрид');

  const FuelType(this.value, this.label);
  final String value;
  final String label;

  static FuelType fromValue(String value) {
    return FuelType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => FuelType.gasoline,
    );
  }
}

class Car extends Equatable {
  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.currentOdometer,
    required this.fuelType,
    required this.createdAt,
    this.licensePlate,
    this.vin,
    this.insurancePdfPath,
    this.insuranceExpiryDate,
    this.lastOilChangeOdometer,
    this.avgFuelConsumption,
    this.fuelTankCapacity,
    this.currentFuelLevel,
    this.techInspectionFilePath,
    this.techInspectionExpiryDate,
  });

  final String id;
  final String brand;
  final String model;
  final int currentOdometer;
  final String? licensePlate;
  final String? vin;
  final FuelType fuelType;
  final DateTime createdAt;

  /// Путь к локальному PDF-файлу страховки. Null если файл не добавлен.
  final String? insurancePdfPath;

  /// Дата окончания страховки. Null если не указана.
  final DateTime? insuranceExpiryDate;

  /// Пробег на момент последней замены масла. Null если замена не фиксировалась.
  final int? lastOilChangeOdometer;

  /// Средний расход топлива по данным бортового компьютера, л/100 км.
  final double? avgFuelConsumption;

  /// Объём топливного бака, литры.
  final int? fuelTankCapacity;

  /// Примерное количество топлива в баке на момент добавления, литры.
  final int? currentFuelLevel;

  /// Путь к локальному файлу техосмотра (PDF или изображение).
  final String? techInspectionFilePath;

  /// Дата окончания техосмотра.
  final DateTime? techInspectionExpiryDate;

  String get displayName => '$brand $model';

  /// Дней до окончания страховки. Null если дата не указана.
  int? get insuranceDaysLeft => insuranceExpiryDate != null
      ? insuranceExpiryDate!.difference(DateTime.now()).inDays
      : null;

  int? get techInspectionDaysLeft => techInspectionExpiryDate != null
      ? techInspectionExpiryDate!.difference(DateTime.now()).inDays
      : null;

  Car copyWith({
    String? id,
    String? brand,
    String? model,
    int? currentOdometer,
    String? licensePlate,
    String? vin,
    FuelType? fuelType,
    DateTime? createdAt,
    String? insurancePdfPath,
    DateTime? insuranceExpiryDate,
    int? lastOilChangeOdometer,
    double? avgFuelConsumption,
    int? fuelTankCapacity,
    int? currentFuelLevel,
    String? techInspectionFilePath,
    DateTime? techInspectionExpiryDate,
    bool clearInsurancePdfPath = false,
    bool clearInsuranceExpiryDate = false,
    bool clearLastOilChangeOdometer = false,
    bool clearAvgFuelConsumption = false,
    bool clearFuelTankCapacity = false,
    bool clearCurrentFuelLevel = false,
    bool clearTechInspectionFilePath = false,
    bool clearTechInspectionExpiryDate = false,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      licensePlate: licensePlate ?? this.licensePlate,
      vin: vin ?? this.vin,
      fuelType: fuelType ?? this.fuelType,
      createdAt: createdAt ?? this.createdAt,
      insurancePdfPath:
          clearInsurancePdfPath ? null : (insurancePdfPath ?? this.insurancePdfPath),
      insuranceExpiryDate:
          clearInsuranceExpiryDate ? null : (insuranceExpiryDate ?? this.insuranceExpiryDate),
      lastOilChangeOdometer:
          clearLastOilChangeOdometer ? null : (lastOilChangeOdometer ?? this.lastOilChangeOdometer),
      avgFuelConsumption:
          clearAvgFuelConsumption ? null : (avgFuelConsumption ?? this.avgFuelConsumption),
      fuelTankCapacity:
          clearFuelTankCapacity ? null : (fuelTankCapacity ?? this.fuelTankCapacity),
      currentFuelLevel:
          clearCurrentFuelLevel ? null : (currentFuelLevel ?? this.currentFuelLevel),
      techInspectionFilePath:
          clearTechInspectionFilePath ? null : (techInspectionFilePath ?? this.techInspectionFilePath),
      techInspectionExpiryDate:
          clearTechInspectionExpiryDate ? null : (techInspectionExpiryDate ?? this.techInspectionExpiryDate),
    );
  }

  @override
  List<Object?> get props => [
        id, brand, model, currentOdometer, licensePlate, vin,
        fuelType, createdAt, insurancePdfPath, insuranceExpiryDate,
        lastOilChangeOdometer, avgFuelConsumption, fuelTankCapacity, currentFuelLevel,
        techInspectionFilePath, techInspectionExpiryDate,
      ];
}
