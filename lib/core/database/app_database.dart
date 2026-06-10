// Главный файл базы данных приложения.
// Drift автоматически генерирует реализацию на основе аннотаций.
// Запуск кодогенерации: dart run build_runner build --delete-conflicting-outputs

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../features/car/data/models/car_table.dart';
import '../../features/refueling/data/models/refueling_table.dart';
import '../../features/expense/data/models/expense_table.dart';

// Директива part подключает сгенерированный файл.
// Он появится после запуска build_runner.
part 'app_database.g.dart';

/// Центральная база данных приложения MyCar.
///
/// Содержит все таблицы и является точкой входа для всех запросов.
/// Версия схемы увеличивается при каждом изменении структуры таблиц.
@DriftDatabase(
  tables: [
    CarTable,
    RefuelingTable,
    ExpenseTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Версия схемы. При изменении таблиц — увеличить и написать миграцию.
  @override
  int get schemaVersion => 5;

  /// Стратегия миграции при изменении схемы.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator migrator) async {
          await migrator.createAll();
        },
        onUpgrade: (Migrator migrator, int from, int to) async {
          if (from < 2) {
            // v1 → v2: поля страховки в таблице Car
            await migrator.addColumn(carTable, carTable.insurancePdfPath);
            await migrator.addColumn(carTable, carTable.insuranceExpiryDate);
          }
          if (from < 3) {
            // v2 → v3: пробег последней замены масла
            await migrator.addColumn(carTable, carTable.lastOilChangeOdometer);
          }
          if (from < 4) {
            // v3 → v4: данные бортового компьютера
            await migrator.addColumn(carTable, carTable.avgFuelConsumption);
            await migrator.addColumn(carTable, carTable.fuelTankCapacity);
          }
          if (from < 5) {
            // v4 → v5: текущий уровень топлива
            await migrator.addColumn(carTable, carTable.currentFuelLevel);
          }
        },
      );
}

/// Открывает соединение с файлом SQLite в директории документов приложения.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Получаем путь к директории для хранения данных приложения
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final File databaseFile =
        File(path.join(documentsDirectory.path, 'mycar.db'));
    return NativeDatabase.createInBackground(databaseFile);
  });
}
