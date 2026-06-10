// Доменная сущность «Расход».

import 'package:equatable/equatable.dart';

/// Перечисление категорий расходов.
enum ExpenseCategory {
  service('service', 'Сервис / ТО'),
  insurance('insurance', 'Документы / Страховка'),
  carwash('carwash', 'Автомойка'),
  fine('fine', 'Штраф'),
  parking('parking', 'Парковка'),
  other('other', 'Другое');

  const ExpenseCategory(this.value, this.label);

  /// Строковое значение для хранения в БД.
  final String value;

  /// Отображаемое название на русском.
  final String label;

  /// Восстановить из строки, сохранённой в БД.
  static ExpenseCategory fromValue(String value) {
    return ExpenseCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ExpenseCategory.other,
    );
  }
}

/// Доменная сущность [Expense] представляет произвольный расход по автомобилю.
class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.carId,
    required this.date,
    required this.category,
    required this.cost,
    required this.title,
    this.note,
  });

  final String id;
  final String carId;
  final DateTime date;
  final ExpenseCategory category;

  /// Сумма расхода в рублях.
  final double cost;

  /// Краткое название, например «ТО 60 000 км».
  final String title;

  /// Дополнительная заметка (опционально).
  final String? note;

  Expense copyWith({
    String? id,
    String? carId,
    DateTime? date,
    ExpenseCategory? category,
    double? cost,
    String? title,
    String? note,
  }) {
    return Expense(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      date: date ?? this.date,
      category: category ?? this.category,
      cost: cost ?? this.cost,
      title: title ?? this.title,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, carId, date, category, cost, title, note];
}
