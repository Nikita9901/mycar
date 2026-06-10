import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/car/domain/usecases/watch_all_cars.dart';
import '../../../../features/expense/domain/entities/expense.dart';
import '../../../../features/expense/domain/usecases/watch_expenses_for_car.dart';
import '../../../../features/refueling/domain/entities/refueling.dart';
import '../../../../features/refueling/domain/usecases/watch_refuelings_for_car.dart';
import '../../domain/entities/history_item.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({
    required WatchAllCars watchAllCars,
    required WatchRefuelingsForCar watchRefuelingsForCar,
    required WatchExpensesForCar watchExpensesForCar,
  })  : _watchAllCars = watchAllCars,
        _watchRefuelings = watchRefuelingsForCar,
        _watchExpenses = watchExpensesForCar,
        super(const HistoryLoading());

  final WatchAllCars _watchAllCars;
  final WatchRefuelingsForCar _watchRefuelings;
  final WatchExpensesForCar _watchExpenses;

  StreamSubscription<dynamic>? _carsSub;
  StreamSubscription<dynamic>? _refuelingsSub;
  StreamSubscription<dynamic>? _expensesSub;

  List<Refueling> _refuelings = [];
  List<Expense> _expenses = [];

  // ── Запуск подписки ───────────────────────────────────────────────────────

  void load() {
    emit(const HistoryLoading());
    _carsSub?.cancel();
    _carsSub = _watchAllCars().listen(
      (cars) {
        if (cars.isEmpty) {
          _cancelDataSubscriptions();
          emit(const HistoryEmpty());
          return;
        }
        _subscribeToCarData(cars.first.id);
      },
      onError: (_) => emit(const HistoryEmpty()),
    );
  }

  void _subscribeToCarData(String carId) {
    _cancelDataSubscriptions();

    _refuelingsSub = _watchRefuelings(carId).listen(
      (list) {
        _refuelings = list;
        _emitLoaded();
      },
      onError: (_) {},
    );

    _expensesSub = _watchExpenses(carId).listen(
      (list) {
        _expenses = list;
        _emitLoaded();
      },
      onError: (_) {},
    );
  }

  void _emitLoaded() {
    final items = <HistoryItem>[
      ..._refuelings.map(RefuelingHistoryItem.new),
      ..._expenses.map(ExpenseHistoryItem.new),
    ]..sort((a, b) => b.date.compareTo(a.date));

    if (items.isEmpty) {
      emit(const HistoryEmpty());
    } else {
      emit(HistoryLoaded(items: items));
    }
  }

  // ── Очистка ───────────────────────────────────────────────────────────────

  void _cancelDataSubscriptions() {
    _refuelingsSub?.cancel();
    _expensesSub?.cancel();
    _refuelings = [];
    _expenses = [];
  }

  @override
  Future<void> close() {
    _carsSub?.cancel();
    _refuelingsSub?.cancel();
    _expensesSub?.cancel();
    return super.close();
  }
}
