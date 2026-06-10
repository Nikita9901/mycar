// Доменная сущность «Заправка».

import 'package:equatable/equatable.dart';

/// Доменная сущность [Refueling] представляет одну запись о заправке.
class Refueling extends Equatable {
  const Refueling({
    required this.id,
    required this.carId,
    required this.date,
    required this.odometer,
    required this.liters,
    required this.totalCost,
    required this.isFullTank,
    this.stationName,
  });

  /// Уникальный идентификатор (UUID).
  final String id;

  /// Идентификатор автомобиля.
  final String carId;

  /// Дата и время заправки.
  final DateTime date;

  /// Показание одометра на момент заправки (км).
  final int odometer;

  /// Количество залитых литров.
  final double liters;

  /// Общая стоимость заправки в рублях.
  final double totalCost;

  /// Признак заправки «до полного бака».
  final bool isFullTank;

  /// Название АЗС (опционально).
  final String? stationName;

  /// Стоимость одного литра топлива (вычисляемое поле).
  double get pricePerLiter => liters > 0 ? totalCost / liters : 0.0;

  Refueling copyWith({
    String? id,
    String? carId,
    DateTime? date,
    int? odometer,
    double? liters,
    double? totalCost,
    bool? isFullTank,
    String? stationName,
  }) {
    return Refueling(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      liters: liters ?? this.liters,
      totalCost: totalCost ?? this.totalCost,
      isFullTank: isFullTank ?? this.isFullTank,
      stationName: stationName ?? this.stationName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        carId,
        date,
        odometer,
        liters,
        totalCost,
        isFullTank,
        stationName,
      ];
}
