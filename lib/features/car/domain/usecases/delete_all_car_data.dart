import 'dart:io';

import '../repositories/car_repository.dart';
import '../../../refueling/domain/repositories/refueling_repository.dart';
import '../../../expense/domain/repositories/expense_repository.dart';

/// Полностью удаляет автомобиль: заправки, расходы, PDF-файл страховки, запись в БД.
class DeleteAllCarData {
  const DeleteAllCarData({
    required CarRepository carRepository,
    required RefuelingRepository refuelingRepository,
    required ExpenseRepository expenseRepository,
  })  : _carRepo = carRepository,
        _refuelingRepo = refuelingRepository,
        _expenseRepo = expenseRepository;

  final CarRepository _carRepo;
  final RefuelingRepository _refuelingRepo;
  final ExpenseRepository _expenseRepo;

  Future<void> call(String carId, {String? insurancePdfPath}) async {
    // 1. Удаляем PDF-файл страховки с диска
    if (insurancePdfPath != null) {
      try {
        final file = File(insurancePdfPath);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }

    // 2. Удаляем все заправки
    final refuelings = await _refuelingRepo.getRefuelingsForCar(carId);
    for (final r in refuelings) {
      await _refuelingRepo.deleteRefueling(r.id);
    }

    // 3. Удаляем все расходы
    final expenses = await _expenseRepo.getExpensesForCar(carId);
    for (final e in expenses) {
      await _expenseRepo.deleteExpense(e.id);
    }

    // 4. Удаляем сам автомобиль
    await _carRepo.deleteCar(carId);
  }
}
