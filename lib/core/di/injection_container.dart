import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../services/pdf_report_service.dart';
import '../services/settings_service.dart';

// Car
import '../../features/car/data/datasources/car_local_datasource.dart';
import '../../features/car/data/repositories/car_repository_impl.dart';
import '../../features/car/domain/repositories/car_repository.dart';
import '../../features/car/domain/usecases/add_car.dart';
import '../../features/car/domain/usecases/delete_car.dart';
import '../../features/car/domain/usecases/delete_all_car_data.dart';
import '../../features/car/domain/usecases/get_all_cars.dart';
import '../../features/car/domain/usecases/update_car.dart';
import '../../features/car/domain/usecases/watch_all_cars.dart';

// Refueling
import '../../features/refueling/data/datasources/refueling_local_datasource.dart';
import '../../features/refueling/data/repositories/refueling_repository_impl.dart';
import '../../features/refueling/domain/repositories/refueling_repository.dart';
import '../../features/refueling/domain/usecases/add_refueling.dart';
import '../../features/refueling/domain/usecases/calculate_fuel_consumption.dart';
import '../../features/refueling/domain/usecases/delete_refueling.dart';
import '../../features/refueling/domain/usecases/get_refuelings_for_car.dart';
import '../../features/refueling/domain/usecases/watch_refuelings_for_car.dart';

// Expense
import '../../features/expense/data/datasources/expense_local_datasource.dart';
import '../../features/expense/data/repositories/expense_repository_impl.dart';
import '../../features/expense/domain/repositories/expense_repository.dart';
import '../../features/expense/domain/usecases/add_expense.dart';
import '../../features/expense/domain/usecases/delete_expense.dart';
import '../../features/expense/domain/usecases/get_expenses_for_car.dart';
import '../../features/expense/domain/usecases/watch_expenses_for_car.dart';

// History
import '../../features/history/presentation/bloc/history_cubit.dart';

// Analytics
import '../../features/analytics/presentation/bloc/analytics_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SettingsService>(SettingsService(prefs));
  sl.registerLazySingleton(() => const PdfReportService());

  // Database
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // Data sources
  sl.registerLazySingleton(() => CarLocalDatasource(sl()));
  sl.registerLazySingleton(() => RefuelingLocalDatasource(sl()));
  sl.registerLazySingleton(() => ExpenseLocalDatasource(sl()));

  // Repositories
  sl.registerLazySingleton<CarRepository>(() => CarRepositoryImpl(sl()));
  sl.registerLazySingleton<RefuelingRepository>(() => RefuelingRepositoryImpl(sl()));
  sl.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(sl()));

  // Use Cases — Car
  sl.registerLazySingleton(() => GetAllCars(sl()));
  sl.registerLazySingleton(() => WatchAllCars(sl()));
  sl.registerLazySingleton(() => AddCar(sl()));
  sl.registerLazySingleton(() => UpdateCar(sl()));
  sl.registerLazySingleton(() => DeleteCar(sl()));
  sl.registerLazySingleton(() => DeleteAllCarData(
        carRepository: sl(),
        refuelingRepository: sl(),
        expenseRepository: sl(),
      ));

  // Use Cases — Refueling
  sl.registerLazySingleton(() => GetRefuelingsForCar(sl()));
  sl.registerLazySingleton(() => WatchRefuelingsForCar(sl()));
  sl.registerLazySingleton(() => AddRefueling(refuelingRepository: sl(), carRepository: sl()));
  sl.registerLazySingleton(() => CalculateFuelConsumption(sl()));
  sl.registerLazySingleton(() => DeleteRefueling(sl()));

  // Use Cases — Expense
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => GetExpensesForCar(sl()));
  sl.registerLazySingleton(() => WatchExpensesForCar(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));

  // History
  sl.registerFactory(() => HistoryCubit(
        watchAllCars: sl(),
        watchRefuelingsForCar: sl(),
        watchExpensesForCar: sl(),
      ));

  // Analytics
  sl.registerFactory(() => AnalyticsCubit(
        watchAllCars: sl(),
        watchRefuelingsForCar: sl(),
        watchExpensesForCar: sl(),
      ));
}
