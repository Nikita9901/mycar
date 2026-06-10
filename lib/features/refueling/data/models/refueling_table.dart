// Описание таблицы заправок для Drift ORM.

import 'package:drift/drift.dart';

import '../../../car/data/models/car_table.dart';

/// Таблица [RefuelingTable] хранит каждую запись о заправке автомобиля.
///
/// Связана с [CarTable] через внешний ключ [carId].
class RefuelingTable extends Table {
  /// Уникальный идентификатор записи (UUID).
  TextColumn get id => text()();

  /// Ссылка на автомобиль. При удалении авто — каскадно удаляем заправки.
  TextColumn get carId =>
      text().references(CarTable, #id, onDelete: KeyAction.cascade)();

  /// Дата и время заправки.
  DateTimeColumn get date => dateTime()();

  /// Показание одометра на момент заправки (км).
  IntColumn get odometer => integer()();

  /// Количество залитых литров топлива.
  RealColumn get liters => real()();

  /// Общая стоимость заправки в рублях/копейках (хранится как double).
  RealColumn get totalCost => real()();

  /// Признак «заправлено до полного бака».
  /// Используется для расчёта точного расхода топлива.
  BoolColumn get isFullTank => boolean().withDefault(const Constant(true))();

  /// Название АЗС (необязательно), например «Лукойл», «Газпромнефть».
  TextColumn get stationName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
