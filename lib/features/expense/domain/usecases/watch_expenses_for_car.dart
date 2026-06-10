import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class WatchExpensesForCar {
  const WatchExpensesForCar(this._repository);

  final ExpenseRepository _repository;

  Stream<List<Expense>> call(String carId) =>
      _repository.watchExpensesForCar(carId);
}
