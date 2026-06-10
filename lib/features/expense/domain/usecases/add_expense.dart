import 'package:uuid/uuid.dart';

import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class AddExpenseParams {
  const AddExpenseParams({
    required this.carId,
    required this.category,
    required this.cost,
    required this.title,
    this.note,
  });

  final String carId;
  final ExpenseCategory category;
  final double cost;
  final String title;
  final String? note;
}

class AddExpense {
  const AddExpense(this._repository);

  final ExpenseRepository _repository;

  Future<void> call(AddExpenseParams params) async {
    final expense = Expense(
      id: const Uuid().v4(),
      carId: params.carId,
      date: DateTime.now(),
      category: params.category,
      cost: params.cost,
      title: params.title,
      note: params.note,
    );
    await _repository.addExpense(expense);
  }
}
