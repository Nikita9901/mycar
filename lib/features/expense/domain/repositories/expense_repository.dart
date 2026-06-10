import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpensesForCar(String carId);
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String expenseId);
  Stream<List<Expense>> watchExpensesForCar(String carId);
}
