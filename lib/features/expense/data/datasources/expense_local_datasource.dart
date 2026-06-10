import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class ExpenseLocalDatasource {
  const ExpenseLocalDatasource(this._database);

  final AppDatabase _database;

  Future<List<ExpenseTableData>> getExpensesForCar(String carId) {
    return (_database.select(_database.expenseTable)
          ..where((t) => t.carId.equals(carId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<void> insertExpense(ExpenseTableCompanion companion) {
    return _database.into(_database.expenseTable).insert(companion);
  }

  Future<void> updateExpense(ExpenseTableCompanion companion) {
    return (_database.update(_database.expenseTable)
          ..where((t) => t.id.equals(companion.id.value)))
        .write(companion);
  }

  Future<void> deleteExpense(String expenseId) {
    return (_database.delete(_database.expenseTable)
          ..where((t) => t.id.equals(expenseId)))
        .go();
  }

  Stream<List<ExpenseTableData>> watchExpensesForCar(String carId) {
    return (_database.select(_database.expenseTable)
          ..where((t) => t.carId.equals(carId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }
}
