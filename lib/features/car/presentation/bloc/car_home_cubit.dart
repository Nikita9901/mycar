import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/car.dart';
import '../../domain/usecases/add_car.dart';
import '../../domain/usecases/delete_all_car_data.dart';
import '../../domain/usecases/watch_all_cars.dart';
import '../../domain/usecases/update_car.dart';
import '../../../refueling/domain/entities/refueling.dart';
import '../../../refueling/domain/usecases/add_refueling.dart';
import '../../../refueling/domain/usecases/get_refuelings_for_car.dart';
import '../../../refueling/domain/usecases/calculate_fuel_consumption.dart';
import '../../../refueling/domain/usecases/delete_refueling.dart';
import '../../../expense/domain/usecases/add_expense.dart';
import '../../../expense/domain/usecases/delete_expense.dart';
import 'car_home_state.dart';

const int kDefaultOilChangeIntervalKm = 10000;

class CarHomeCubit extends Cubit<CarHomeState> {
  CarHomeCubit({
    required WatchAllCars watchAllCars,
    required GetRefuelingsForCar getRefuelingsForCar,
    required CalculateFuelConsumption calculateFuelConsumption,
    required UpdateCar updateCar,
    required AddCar addCar,
    required AddRefueling addRefueling,
    required AddExpense addExpense,
    required DeleteRefueling deleteRefueling,
    required DeleteExpense deleteExpense,
    required DeleteAllCarData deleteAllCarData,
  })  : _watchAllCars = watchAllCars,
        _getRefuelingsForCar = getRefuelingsForCar,
        _calculateFuelConsumption = calculateFuelConsumption,
        _updateCar = updateCar,
        _addCar = addCar,
        _addRefueling = addRefueling,
        _addExpense = addExpense,
        _deleteRefueling = deleteRefueling,
        _deleteExpense = deleteExpense,
        _deleteAllCarData = deleteAllCarData,
        super(const CarHomeLoading());

  int oilChangeIntervalKm = kDefaultOilChangeIntervalKm;

  final WatchAllCars _watchAllCars;
  final GetRefuelingsForCar _getRefuelingsForCar;
  final CalculateFuelConsumption _calculateFuelConsumption;
  final UpdateCar _updateCar;
  final AddCar _addCar;
  final AddRefueling _addRefueling;
  final AddExpense _addExpense;
  final DeleteRefueling _deleteRefueling;
  final DeleteExpense _deleteExpense;
  final DeleteAllCarData _deleteAllCarData;

  StreamSubscription<List<Car>>? _carsSubscription;

  // ── Загрузка ──────────────────────────────────────────────────────────────

  void loadGarage() {
    emit(const CarHomeLoading());
    _carsSubscription?.cancel();
    _carsSubscription = _watchAllCars().listen(
      _onCarsUpdated,
      onError: (Object e) => emit(CarHomeError(e.toString())),
    );
  }

  Future<void> _onCarsUpdated(List<Car> cars) async {
    if (cars.isEmpty) {
      emit(const CarHomeEmpty());
      return;
    }
    final Car car = cars.first;
    try {
      final results = await Future.wait([
        _getRefuelingsForCar(car.id),
        _calculateFuelConsumption(car.id),
      ]);
      final refuelings = results[0] as List<Refueling>;
      final consumption = results[1] as FuelConsumptionResult?;
      final lastRefueling = refuelings.isNotEmpty ? refuelings.first : null;
      final (oilProgress, oilKmLeft) = _calcOilProgress(car, refuelings);

      emit(CarHomeLoaded(
        car: car,
        lastRefueling: lastRefueling,
        oilChangeProgress: oilProgress,
        oilChangeKmLeft: oilKmLeft,
        fuelConsumptionPer100km: consumption?.averageConsumptionPer100km,
      ));
    } catch (e) {
      emit(CarHomeError(e.toString()));
    }
  }

  (double, int) _calcOilProgress(Car car, List<Refueling> refuelings) {
    // Приоритет: зафиксированная замена масла → первая заправка → оценка
    final int base;
    if (car.lastOilChangeOdometer != null) {
      base = car.lastOilChangeOdometer!;
    } else if (refuelings.isNotEmpty) {
      base = refuelings.last.odometer; // самая старая заправка
    } else {
      base = car.currentOdometer - oilChangeIntervalKm ~/ 2;
    }
    final driven = (car.currentOdometer - base).clamp(0, 999999);
    return (
      (driven / oilChangeIntervalKm).clamp(0.0, 1.0),
      oilChangeIntervalKm - driven,
    );
  }

  // ── Техосмотр ─────────────────────────────────────────────────────────────

  /// Сохраняет файл техосмотра: копирует в постоянное хранилище, записывает путь и дату.
  Future<void> addTechInspection(String sourcePath, DateTime expiryDate) async {
    final s = state;
    if (s is! CarHomeLoaded) return;

    final docsDir = await getApplicationDocumentsDirectory();
    final ext = p.extension(sourcePath);
    final destPath = p.join(docsDir.path, 'tech_inspection_${s.car.id}$ext');

    await File(sourcePath).copy(destPath);

    await _updateCar(s.car.copyWith(
      techInspectionFilePath: destPath,
      techInspectionExpiryDate: expiryDate,
    ));
  }

  /// Удаляет локальный файл техосмотра и очищает поля в БД.
  Future<void> removeTechInspection() async {
    final s = state;
    if (s is! CarHomeLoaded) return;

    final path = s.car.techInspectionFilePath;
    if (path != null) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }

    await _updateCar(s.car.copyWith(
      clearTechInspectionFilePath: true,
      clearTechInspectionExpiryDate: true,
    ));
  }

  /// Записывает замену масла: сохраняет текущий пробег как точку отсчёта.
  Future<void> recordOilChange() async {
    final s = state;
    if (s is! CarHomeLoaded) return;
    await _updateCar(s.car.copyWith(
      lastOilChangeOdometer: s.car.currentOdometer,
    ));
  }

  // ── Добавление / обновление ───────────────────────────────────────────────

  Future<void> addCar(AddCarParams params) => _addCar(params);

  /// Обновляет пробег. [force] = true пропускает проверку на уменьшение
  /// (используется при автопересчёте после удаления операции).
  Future<void> updateOdometer(int newOdometer, {bool force = false}) async {
    final s = state;
    if (s is! CarHomeLoaded) return;
    final car = s.car;
    Car updated = car.copyWith(currentOdometer: newOdometer);

    // Вычитаем топливо пропорционально пройденному расстоянию
    final distance = newOdometer - car.currentOdometer;
    if (distance > 0 &&
        car.avgFuelConsumption != null &&
        car.currentFuelLevel != null) {
      final consumed = (distance * car.avgFuelConsumption! / 100).round();
      final newLevel = (car.currentFuelLevel! - consumed)
          .clamp(0, car.fuelTankCapacity ?? car.currentFuelLevel!)
          .toInt();
      updated = updated.copyWith(currentFuelLevel: newLevel);
    }

    await _updateCar(updated);
  }

  /// После удаления операции выставляет пробег = одометр последней по дате записи.
  Future<void> _syncOdometerAfterDelete(Car car) async {
    final refuelings = await _getRefuelingsForCar(car.id);

    // Ищем последнюю по дате операцию с одометром
    int? lastOdo;
    DateTime? lastDate;

    for (final r in refuelings) {
      if (lastDate == null || r.date.isAfter(lastDate)) {
        lastDate = r.date;
        lastOdo = r.odometer;
      }
    }
    // У расходов одометра нет — используем только заправки

    if (lastOdo != null && lastOdo != car.currentOdometer) {
      await _updateCar(car.copyWith(currentOdometer: lastOdo));
    }
  }

  /// Уменьшает уровень топлива по итогам поездки.
  Future<void> updateFuelAfterTrip(double distanceKm) async {
    final s = state;
    if (s is! CarHomeLoaded) return;
    final car = s.car;
    if (car.currentFuelLevel == null || car.avgFuelConsumption == null || car.avgFuelConsumption! <= 0) return;
    final consumed = (distanceKm * car.avgFuelConsumption! / 100).round();
    if (consumed <= 0) return;
    final newLevel = (car.currentFuelLevel! - consumed).clamp(0, car.fuelTankCapacity ?? car.currentFuelLevel!);
    await _updateCar(car.copyWith(currentFuelLevel: newLevel));
  }

  Future<void> addRefueling(AddRefuelingParams params) => _addRefueling(params);

  Future<void> addExpense(AddExpenseParams params) => _addExpense(params);

  // ── Страховка ─────────────────────────────────────────────────────────────

  /// Сохраняет PDF страховки: копирует файл в постоянное хранилище приложения,
  /// записывает путь и дату окончания в БД.
  Future<void> addInsurance(String sourcePath, DateTime expiryDate) async {
    final s = state;
    if (s is! CarHomeLoaded) return;

    final docsDir = await getApplicationDocumentsDirectory();
    final destPath = p.join(docsDir.path, 'insurance_${s.car.id}.pdf');

    // Копируем файл из временной/исходной директории в постоянную
    await File(sourcePath).copy(destPath);

    await _updateCar(s.car.copyWith(
      insurancePdfPath: destPath,
      insuranceExpiryDate: expiryDate,
    ));
  }

  /// Удаляет локальный PDF и очищает поля страховки в БД.
  Future<void> removeInsurance() async {
    final s = state;
    if (s is! CarHomeLoaded) return;

    final path = s.car.insurancePdfPath;
    if (path != null) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }

    await _updateCar(s.car.copyWith(
      clearInsurancePdfPath: true,
      clearInsuranceExpiryDate: true,
    ));
  }

  // ── Удаление ──────────────────────────────────────────────────────────────

  /// Удаляет заправку и пересчитывает пробег по последней оставшейся операции.
  Future<void> deleteRefueling(String refuelingId) async {
    final s = state;
    if (s is! CarHomeLoaded) return;
    await _deleteRefueling(refuelingId);
    await _syncOdometerAfterDelete(s.car);
  }

  /// Удаляет запись расхода.
  Future<void> deleteExpense(String expenseId) => _deleteExpense(expenseId);

  /// Полностью удаляет автомобиль, все его данные и PDF-файл страховки.
  Future<void> deleteCarAndAllData() async {
    final s = state;
    if (s is! CarHomeLoaded) return;
    await _deleteAllCarData(s.car.id, insurancePdfPath: s.car.insurancePdfPath);
  }

  @override
  Future<void> close() {
    _carsSubscription?.cancel();
    return super.close();
  }
}
