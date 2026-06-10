import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_mapper.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this._datasource);

  final ExpenseLocalDatasource _datasource;

  @override
  Future<List<Expense>> getExpensesForCar(String carId) async {
    final rows = await _datasource.getExpensesForCar(carId);
    return rows.map(ExpenseMapper.fromTableData).toList();
  }

  @override
  Future<void> addExpense(Expense expense) {
    return _datasource.insertExpense(ExpenseMapper.toCompanion(expense));
  }

  @override
  Future<void> updateExpense(Expense expense) {
    return _datasource.updateExpense(ExpenseMapper.toCompanion(expense));
  }

  @override
  Future<void> deleteExpense(String expenseId) {
    return _datasource.deleteExpense(expenseId);
  }

  @override
  Stream<List<Expense>> watchExpensesForCar(String carId) {
    return _datasource
        .watchExpensesForCar(carId)
        .map((rows) => rows.map(ExpenseMapper.fromTableData).toList());
  }
}
