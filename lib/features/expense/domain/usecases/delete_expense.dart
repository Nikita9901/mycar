import '../repositories/expense_repository.dart';

class DeleteExpense {
  const DeleteExpense(this._repository);

  final ExpenseRepository _repository;

  Future<void> call(String expenseId) => _repository.deleteExpense(expenseId);
}
