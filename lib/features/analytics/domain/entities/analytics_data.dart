import 'package:flutter/material.dart';

/// Выбранный период аналитики.
enum AnalyticsPeriod {
  month('Месяц'),
  year('Год'),
  allTime('Всё время');

  const AnalyticsPeriod(this.label);
  final String label;
}

/// Разбивка трат по одной категории.
class CategorySpend {
  const CategorySpend({
    required this.label,
    required this.color,
    required this.amount,
    required this.percentage,
  });

  final String label;
  final Color color;

  /// Сумма расходов по категории за период (рубли).
  final double amount;

  /// Доля от общих расходов 0.0 – 1.0.
  final double percentage;
}

/// Результат расчётов для экрана аналитики.
class AnalyticsData {
  const AnalyticsData({
    required this.totalSpend,
    required this.avgConsumptionPer100km,
    required this.costPerKm,
    required this.categoryBreakdown,
    required this.period,
    this.consumptionIsFromCar = false,
  });

  /// Сумма всех трат за период (топливо + расходы).
  final double totalSpend;

  /// Средний расход топлива л/100 км. Null если данных недостаточно.
  final double? avgConsumptionPer100km;

  /// true — расход взят из данных бортового компьютера, а не посчитан по заправкам.
  final bool consumptionIsFromCar;

  /// Стоимость 1 км пути. Null если данных недостаточно.
  final double? costPerKm;

  /// Разбивка по категориям (отсортирована по убыванию суммы).
  final List<CategorySpend> categoryBreakdown;

  final AnalyticsPeriod period;
}
