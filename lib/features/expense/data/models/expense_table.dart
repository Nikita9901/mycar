// Описание таблицы прочих расходов для Drift ORM.

import 'package:drift/drift.dart';

import '../../../car/data/models/car_table.dart';

/// Таблица [ExpenseTable] хранит записи обо всех расходах кроме заправок.
///
/// Категория хранится как строка — текстовое представление enum [ExpenseCategory].
class ExpenseTable extends Table {
  /// Уникальный идентификатор записи (UUID).
  TextColumn get id => text()();

  /// Ссылка на автомобиль.
  TextColumn get carId =>
      text().references(CarTable, #id, onDelete: KeyAction.cascade)();

  /// Дата и время расхода.
  DateTimeColumn get date => dateTime()();

  /// Категория расхода (строковое значение enum [ExpenseCategory]).
  /// Возможные значения: 'service', 'insurance', 'carwash', 'fine',
  /// 'parking', 'other'.
  TextColumn get category => text()();

  /// Сумма расхода в рублях.
  RealColumn get cost => real()();

  /// Короткое название события, например «ТО», «ОСАГО 2025».
  TextColumn get title => text()();

  /// Дополнительная текстовая заметка (необязательно).
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
