import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/expense.dart';

class ExpenseMapper {
  const ExpenseMapper._();

  static Expense fromTableData(ExpenseTableData data) {
    return Expense(
      id: data.id,
      carId: data.carId,
      date: data.date,
      category: ExpenseCategory.fromValue(data.category),
      cost: data.cost,
      title: data.title,
      note: data.note,
    );
  }

  static ExpenseTableCompanion toCompanion(Expense expense) {
    return ExpenseTableCompanion.insert(
      id: expense.id,
      carId: expense.carId,
      date: expense.date,
      category: expense.category.value,
      cost: expense.cost,
      title: expense.title,
      note: Value(expense.note),
    );
  }
}
