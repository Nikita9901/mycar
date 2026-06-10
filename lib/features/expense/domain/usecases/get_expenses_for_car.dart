import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesForCar {
  const GetExpensesForCar(this._repository);
  final ExpenseRepository _repository;

  Future<List<Expense>> call(String carId) =>
      _repository.getExpensesForCar(carId);
}
