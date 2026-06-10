// Маппер для сущности Refueling.

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/refueling.dart';

/// Преобразует объекты между слоями Data и Domain для сущности Refueling.
class RefuelingMapper {
  const RefuelingMapper._();

  /// Из строки БД [RefuelingTableData] → в доменную сущность [Refueling].
  static Refueling fromTableData(RefuelingTableData data) {
    return Refueling(
      id: data.id,
      carId: data.carId,
      date: data.date,
      odometer: data.odometer,
      liters: data.liters,
      totalCost: data.totalCost,
      isFullTank: data.isFullTank,
      stationName: data.stationName,
    );
  }

  /// Из доменной сущности [Refueling] → в [RefuelingTableCompanion].
  static RefuelingTableCompanion toCompanion(Refueling refueling) {
    return RefuelingTableCompanion.insert(
      id: refueling.id,
      carId: refueling.carId,
      date: refueling.date,
      odometer: refueling.odometer,
      liters: refueling.liters,
      totalCost: refueling.totalCost,
      isFullTank: Value(refueling.isFullTank),
      stationName: Value(refueling.stationName),
    );
  }
}
