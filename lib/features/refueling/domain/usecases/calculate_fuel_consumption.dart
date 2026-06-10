// Use Case: расчёт среднего расхода топлива.

import '../entities/refueling.dart';
import '../repositories/refueling_repository.dart';

/// Результат расчёта расхода топлива.
class FuelConsumptionResult {
  const FuelConsumptionResult({
    required this.averageConsumptionPer100km,
    required this.costPerKm,
    required this.totalLiters,
    required this.totalCost,
    required this.totalDistance,
  });

  /// Средний расход топлива в литрах на 100 км.
  final double averageConsumptionPer100km;

  /// Стоимость одного километра пути в рублях.
  final double costPerKm;

  /// Всего залито литров за анализируемый период.
  final double totalLiters;

  /// Общая стоимость топлива за период.
  final double totalCost;

  /// Пройденное расстояние за период (км).
  final int totalDistance;
}

/// Рассчитывает средний расход топлива по записям заправок.
///
/// Алгоритм работает только с записями «до полного бака» ([isFullTank] = true),
/// так как только они позволяют точно определить расход между заправками.
class CalculateFuelConsumption {
  const CalculateFuelConsumption(this._repository);

  final RefuelingRepository _repository;

  Future<FuelConsumptionResult?> call(String carId) async {
    final List<Refueling> allRefuelings =
        await _repository.getRefuelingsForCar(carId);

    // Фильтруем только полные заправки и сортируем по одометру
    final List<Refueling> fullTankRefuelings = allRefuelings
        .where((refueling) => refueling.isFullTank)
        .toList()
      ..sort((a, b) => a.odometer.compareTo(b.odometer));

    // Для расчёта нужно минимум 2 заправки «до полного бака»
    if (fullTankRefuelings.length < 2) {
      return null;
    }

    // Берём участок между первой и последней полной заправкой
    final Refueling firstRefueling = fullTankRefuelings.first;
    final Refueling lastRefueling = fullTankRefuelings.last;

    final int totalDistance =
        lastRefueling.odometer - firstRefueling.odometer;

    if (totalDistance <= 0) {
      return null;
    }

    // Суммируем литры всех заправок КРОМЕ первой
    // (топливо первой заправки израсходовано до начала отсчёта)
    final double totalLiters = fullTankRefuelings
        .skip(1)
        .fold(0.0, (sum, refueling) => sum + refueling.liters);

    final double totalCost = fullTankRefuelings
        .skip(1)
        .fold(0.0, (sum, refueling) => sum + refueling.totalCost);

    final double averageConsumptionPer100km =
        (totalLiters / totalDistance) * 100;

    final double costPerKm =
        totalDistance > 0 ? totalCost / totalDistance : 0.0;

    return FuelConsumptionResult(
      averageConsumptionPer100km: averageConsumptionPer100km,
      costPerKm: costPerKm,
      totalLiters: totalLiters,
      totalCost: totalCost,
      totalDistance: totalDistance,
    );
  }
}
