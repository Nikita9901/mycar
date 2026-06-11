// Описание таблицы автомобилей для Drift ORM.
// Drift использует классы-таблицы для кодогенерации SQL-схемы и запросов.

import 'package:drift/drift.dart';

/// Таблица [CarTable] хранит данные об автомобилях пользователя.
///
/// Каждый столбец соответствует полю сущности [Car] из доменного слоя.
/// Nullable-поля помечены через `.nullable()` — пользователь может
/// не знать VIN или госномер при добавлении авто.
class CarTable extends Table {
  /// Уникальный идентификатор записи (UUID в виде строки).
  TextColumn get id => text()();

  /// Марка автомобиля, например «Toyota».
  TextColumn get brand => text()();

  /// Модель автомобиля, например «Camry».
  TextColumn get model => text()();

  /// Текущий пробег по одометру в километрах.
  IntColumn get currentOdometer => integer()();

  /// Государственный регистрационный номер (необязательно).
  TextColumn get licensePlate => text().nullable()();

  /// VIN-номер кузова автомобиля (необязательно).
  TextColumn get vin => text().nullable()();

  /// Тип топлива по умолчанию (хранится как строка enum).
  /// Возможные значения: 'gasoline', 'diesel', 'lpg', 'electric', 'hybrid'.
  TextColumn get fuelType => text().withDefault(const Constant('gasoline'))();

  /// Дата добавления записи об автомобиле.
  DateTimeColumn get createdAt => dateTime()();

  /// Путь к локальному PDF-файлу страховки. Null если файл не загружен.
  TextColumn get insurancePdfPath => text().nullable()();

  /// Дата окончания страховки. Null если пользователь не указал.
  DateTimeColumn get insuranceExpiryDate => dateTime().nullable()();

  /// Пробег на момент последней замены масла. Null если замена не фиксировалась.
  IntColumn get lastOilChangeOdometer => integer().nullable()();

  /// Средний расход топлива по данным бортового компьютера, л/100 км.
  RealColumn get avgFuelConsumption => real().nullable()();

  /// Объём топливного бака, литры.
  IntColumn get fuelTankCapacity => integer().nullable()();

  /// Примерное количество топлива в баке на момент добавления, литры.
  IntColumn get currentFuelLevel => integer().nullable()();

  /// Путь к локальному файлу техосмотра (PDF или изображение). Null если файл не загружен.
  TextColumn get techInspectionFilePath => text().nullable()();

  /// Дата окончания техосмотра. Null если пользователь не указал.
  DateTimeColumn get techInspectionExpiryDate => dateTime().nullable()();

  /// Первичный ключ — идентификатор UUID.
  @override
  Set<Column> get primaryKey => {id};
}
