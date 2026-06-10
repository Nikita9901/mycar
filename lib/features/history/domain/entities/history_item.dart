import '../../../expense/domain/entities/expense.dart';
import '../../../refueling/domain/entities/refueling.dart';

/// Единица истории — заправка или расход, приведённые к общему интерфейсу.
sealed class HistoryItem {
  const HistoryItem();

  DateTime get date;
  double get cost;
}

final class RefuelingHistoryItem extends HistoryItem {
  const RefuelingHistoryItem(this.refueling);

  final Refueling refueling;

  @override
  DateTime get date => refueling.date;

  @override
  double get cost => refueling.totalCost;
}

final class ExpenseHistoryItem extends HistoryItem {
  const ExpenseHistoryItem(this.expense);

  final Expense expense;

  @override
  DateTime get date => expense.date;

  @override
  double get cost => expense.cost;
}
