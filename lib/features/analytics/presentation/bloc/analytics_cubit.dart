import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/car/domain/entities/car.dart';
import '../../../../features/car/domain/usecases/watch_all_cars.dart';
import '../../../../features/expense/domain/entities/expense.dart';
import '../../../../features/expense/domain/usecases/watch_expenses_for_car.dart';
import '../../../../features/refueling/domain/entities/refueling.dart';
import '../../../../features/refueling/domain/usecases/watch_refuelings_for_car.dart';
import '../../domain/entities/analytics_data.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit({
    required WatchAllCars watchAllCars,
    required WatchRefuelingsForCar watchRefuelingsForCar,
    required WatchExpensesForCar watchExpensesForCar,
  })  : _watchAllCars = watchAllCars,
        _watchRefuelings = watchRefuelingsForCar,
        _watchExpenses = watchExpensesForCar,
        super(const AnalyticsLoading());

  final WatchAllCars _watchAllCars;
  final WatchRefuelingsForCar _watchRefuelings;
  final WatchExpensesForCar _watchExpenses;

  /// Переключатель монетизации. false = все функции бесплатны.
  /// Поменяй на false, чтобы включить пейволл.
  // ignore: prefer_final_fields
  bool _isPremium = true; // TODO: set to false to enable paywall

  StreamSubscription<dynamic>? _carsSub;
  StreamSubscription<dynamic>? _refuelingsSub;
  StreamSubscription<dynamic>? _expensesSub;

  List<Refueling> _allRefuelings = [];
  List<Expense> _allExpenses = [];

  /// Текущий автомобиль (для PDF-отчёта).
  Car? _currentCar;

  List<Refueling> get allRefuelings => List.unmodifiable(_allRefuelings);
  List<Expense> get allExpenses => List.unmodifiable(_allExpenses);
  Car? get currentCar => _currentCar;

  AnalyticsPeriod _period = AnalyticsPeriod.month;

  // ── Запуск ───────────────────────────────────────────────────────────────

  void load() {
    emit(const AnalyticsLoading());
    _carsSub?.cancel();
    _carsSub = _watchAllCars().listen(
      (cars) {
        if (cars.isEmpty) {
          _cancelDataSubs();
          emit(const AnalyticsEmpty());
          return;
        }
        _currentCar = cars.first;
        _subscribeToCarData(cars.first.id);
      },
      onError: (_) => emit(const AnalyticsEmpty()),
    );
  }

  void _subscribeToCarData(String carId) {
    _cancelDataSubs();

    _refuelingsSub = _watchRefuelings(carId).listen(
      (list) {
        _allRefuelings = list;
        _emitLoaded();
      },
      onError: (_) {},
    );

    _expensesSub = _watchExpenses(carId).listen(
      (list) {
        _allExpenses = list;
        _emitLoaded();
      },
      onError: (_) {},
    );
  }

  // ── Смена периода ─────────────────────────────────────────────────────────

  bool changePeriod(AnalyticsPeriod period) {
    if (!_isPremium && period != AnalyticsPeriod.month) return false;
    _period = period;
    _emitLoaded();
    return true;
  }

  /// Симулирует покупку подписки — разблокирует все функции.
  void activatePremium() {
    _isPremium = true;
    _emitLoaded();
  }

  // ── Расчёты ───────────────────────────────────────────────────────────────

  void _emitLoaded() {
    final (from, to) = _dateRange(_period);

    final refuelings = _allRefuelings
        .where((r) => _inRange(r.date, from, to))
        .toList();

    final expenses = _allExpenses
        .where((e) => _inRange(e.date, from, to))
        .toList();

    final totalFuel = refuelings.fold(0.0, (s, r) => s + r.totalCost);
    final totalExpenses = expenses.fold(0.0, (s, e) => s + e.cost);
    final totalSpend = totalFuel + totalExpenses;

    final (avgConsumption, consumptionIsFromCar) =
        _calcAvgConsumption(refuelings, _currentCar?.avgFuelConsumption);
    final costPerKm = _calcCostPerKm(refuelings, totalExpenses);

    final breakdown = _buildBreakdown(
      refuelings: refuelings,
      expenses: expenses,
      totalSpend: totalSpend,
    );

    if (totalSpend == 0 && refuelings.isEmpty && expenses.isEmpty) {
      emit(const AnalyticsEmpty());
      return;
    }

    emit(AnalyticsLoaded(
      data: AnalyticsData(
        totalSpend: totalSpend,
        avgConsumptionPer100km: avgConsumption,
        consumptionIsFromCar: consumptionIsFromCar,
        costPerKm: costPerKm,
        categoryBreakdown: breakdown,
        period: _period,
      ),
      selectedPeriod: _period,
      isPremiumUser: _isPremium,
    ));
  }

  // ── Вспомогательные ───────────────────────────────────────────────────────

  static (DateTime?, DateTime?) _dateRange(AnalyticsPeriod period) {
    final now = DateTime.now();
    return switch (period) {
      AnalyticsPeriod.month => (
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 1)
              .subtract(const Duration(microseconds: 1)),
        ),
      AnalyticsPeriod.year => (
          DateTime(now.year, 1, 1),
          DateTime(now.year + 1, 1, 1)
              .subtract(const Duration(microseconds: 1)),
        ),
      AnalyticsPeriod.allTime => (null, null),
    };
  }

  static bool _inRange(DateTime date, DateTime? from, DateTime? to) {
    if (from != null && date.isBefore(from)) return false;
    if (to != null && date.isAfter(to)) return false;
    return true;
  }

  /// Возвращает (расход, isFromCar).
  /// Сначала считает по заправкам. Если данных недостаточно — берёт из БК.
  static (double?, bool) _calcAvgConsumption(
      List<Refueling> refuelings, double? carAvg) {
    final full = refuelings.where((r) => r.isFullTank).toList()
      ..sort((a, b) => a.odometer.compareTo(b.odometer));
    if (full.length >= 2) {
      final distance = full.last.odometer - full.first.odometer;
      if (distance > 0) {
        final liters = full.skip(1).fold(0.0, (s, r) => s + r.liters);
        return ((liters / distance) * 100, false);
      }
    }
    // Недостаточно заправок — используем данные бортового компьютера
    if (carAvg != null) return (carAvg, true);
    return (null, false);
  }

  static double? _calcCostPerKm(
      List<Refueling> refuelings, double totalExpenses) {
    final full = refuelings.where((r) => r.isFullTank).toList()
      ..sort((a, b) => a.odometer.compareTo(b.odometer));
    if (full.length < 2) return null;

    final distance = full.last.odometer - full.first.odometer;
    if (distance <= 0) return null;

    final totalCost = full.skip(1).fold(0.0, (s, r) => s + r.totalCost) +
        totalExpenses;
    return totalCost / distance;
  }

  static List<CategorySpend> _buildBreakdown({
    required List<Refueling> refuelings,
    required List<Expense> expenses,
    required double totalSpend,
  }) {
    if (totalSpend == 0) return [];

    final Map<String, double> amounts = {
      'Топливо': refuelings.fold(0.0, (s, r) => s + r.totalCost),
    };

    for (final e in expenses) {
      amounts[e.category.label] =
          (amounts[e.category.label] ?? 0) + e.cost;
    }

    final colors = <String, Color>{
      'Топливо': const Color(0xFF5B8FF9),
      'Сервис / ТО': const Color(0xFFFF9500),
      'Документы / Страховка': const Color(0xFFBF5AF2),
      'Автомойка': const Color(0xFF32ADE6),
      'Штраф': const Color(0xFFFF375F),
      'Парковка': const Color(0xFF6E6E73),
      'Другое': const Color(0xFF8D8D92),
    };

    return amounts.entries
        .where((e) => e.value > 0)
        .map((e) => CategorySpend(
              label: e.key,
              color: colors[e.key] ?? const Color(0xFF8D8D92),
              amount: e.value,
              percentage: e.value / totalSpend,
            ))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }

  // ── Очистка ───────────────────────────────────────────────────────────────

  void _cancelDataSubs() {
    _refuelingsSub?.cancel();
    _expensesSub?.cancel();
    _allRefuelings = [];
    _allExpenses = [];
  }

  @override
  Future<void> close() {
    _carsSub?.cancel();
    _refuelingsSub?.cancel();
    _expensesSub?.cancel();
    return super.close();
  }
}
