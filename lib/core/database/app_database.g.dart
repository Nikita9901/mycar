// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CarTableTable extends CarTable
    with TableInfo<$CarTableTable, CarTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentOdometerMeta = const VerificationMeta(
    'currentOdometer',
  );
  @override
  late final GeneratedColumn<int> currentOdometer = GeneratedColumn<int>(
    'current_odometer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licensePlateMeta = const VerificationMeta(
    'licensePlate',
  );
  @override
  late final GeneratedColumn<String> licensePlate = GeneratedColumn<String>(
    'license_plate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vinMeta = const VerificationMeta('vin');
  @override
  late final GeneratedColumn<String> vin = GeneratedColumn<String>(
    'vin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('gasoline'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _insurancePdfPathMeta = const VerificationMeta(
    'insurancePdfPath',
  );
  @override
  late final GeneratedColumn<String> insurancePdfPath = GeneratedColumn<String>(
    'insurance_pdf_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insuranceExpiryDateMeta =
      const VerificationMeta('insuranceExpiryDate');
  @override
  late final GeneratedColumn<DateTime> insuranceExpiryDate =
      GeneratedColumn<DateTime>(
        'insurance_expiry_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastOilChangeOdometerMeta =
      const VerificationMeta('lastOilChangeOdometer');
  @override
  late final GeneratedColumn<int> lastOilChangeOdometer = GeneratedColumn<int>(
    'last_oil_change_odometer',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgFuelConsumptionMeta =
      const VerificationMeta('avgFuelConsumption');
  @override
  late final GeneratedColumn<double> avgFuelConsumption =
      GeneratedColumn<double>(
        'avg_fuel_consumption',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fuelTankCapacityMeta = const VerificationMeta(
    'fuelTankCapacity',
  );
  @override
  late final GeneratedColumn<int> fuelTankCapacity = GeneratedColumn<int>(
    'fuel_tank_capacity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentFuelLevelMeta = const VerificationMeta(
    'currentFuelLevel',
  );
  @override
  late final GeneratedColumn<int> currentFuelLevel = GeneratedColumn<int>(
    'current_fuel_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _techInspectionFilePathMeta =
      const VerificationMeta('techInspectionFilePath');
  @override
  late final GeneratedColumn<String> techInspectionFilePath =
      GeneratedColumn<String>(
        'tech_inspection_file_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _techInspectionExpiryDateMeta =
      const VerificationMeta('techInspectionExpiryDate');
  @override
  late final GeneratedColumn<DateTime> techInspectionExpiryDate =
      GeneratedColumn<DateTime>(
        'tech_inspection_expiry_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brand,
    model,
    currentOdometer,
    licensePlate,
    vin,
    fuelType,
    createdAt,
    insurancePdfPath,
    insuranceExpiryDate,
    lastOilChangeOdometer,
    avgFuelConsumption,
    fuelTankCapacity,
    currentFuelLevel,
    techInspectionFilePath,
    techInspectionExpiryDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'car_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('current_odometer')) {
      context.handle(
        _currentOdometerMeta,
        currentOdometer.isAcceptableOrUnknown(
          data['current_odometer']!,
          _currentOdometerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentOdometerMeta);
    }
    if (data.containsKey('license_plate')) {
      context.handle(
        _licensePlateMeta,
        licensePlate.isAcceptableOrUnknown(
          data['license_plate']!,
          _licensePlateMeta,
        ),
      );
    }
    if (data.containsKey('vin')) {
      context.handle(
        _vinMeta,
        vin.isAcceptableOrUnknown(data['vin']!, _vinMeta),
      );
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('insurance_pdf_path')) {
      context.handle(
        _insurancePdfPathMeta,
        insurancePdfPath.isAcceptableOrUnknown(
          data['insurance_pdf_path']!,
          _insurancePdfPathMeta,
        ),
      );
    }
    if (data.containsKey('insurance_expiry_date')) {
      context.handle(
        _insuranceExpiryDateMeta,
        insuranceExpiryDate.isAcceptableOrUnknown(
          data['insurance_expiry_date']!,
          _insuranceExpiryDateMeta,
        ),
      );
    }
    if (data.containsKey('last_oil_change_odometer')) {
      context.handle(
        _lastOilChangeOdometerMeta,
        lastOilChangeOdometer.isAcceptableOrUnknown(
          data['last_oil_change_odometer']!,
          _lastOilChangeOdometerMeta,
        ),
      );
    }
    if (data.containsKey('avg_fuel_consumption')) {
      context.handle(
        _avgFuelConsumptionMeta,
        avgFuelConsumption.isAcceptableOrUnknown(
          data['avg_fuel_consumption']!,
          _avgFuelConsumptionMeta,
        ),
      );
    }
    if (data.containsKey('fuel_tank_capacity')) {
      context.handle(
        _fuelTankCapacityMeta,
        fuelTankCapacity.isAcceptableOrUnknown(
          data['fuel_tank_capacity']!,
          _fuelTankCapacityMeta,
        ),
      );
    }
    if (data.containsKey('current_fuel_level')) {
      context.handle(
        _currentFuelLevelMeta,
        currentFuelLevel.isAcceptableOrUnknown(
          data['current_fuel_level']!,
          _currentFuelLevelMeta,
        ),
      );
    }
    if (data.containsKey('tech_inspection_file_path')) {
      context.handle(
        _techInspectionFilePathMeta,
        techInspectionFilePath.isAcceptableOrUnknown(
          data['tech_inspection_file_path']!,
          _techInspectionFilePathMeta,
        ),
      );
    }
    if (data.containsKey('tech_inspection_expiry_date')) {
      context.handle(
        _techInspectionExpiryDateMeta,
        techInspectionExpiryDate.isAcceptableOrUnknown(
          data['tech_inspection_expiry_date']!,
          _techInspectionExpiryDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      currentOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_odometer'],
      )!,
      licensePlate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_plate'],
      ),
      vin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vin'],
      ),
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      insurancePdfPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insurance_pdf_path'],
      ),
      insuranceExpiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}insurance_expiry_date'],
      ),
      lastOilChangeOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_oil_change_odometer'],
      ),
      avgFuelConsumption: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_fuel_consumption'],
      ),
      fuelTankCapacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fuel_tank_capacity'],
      ),
      currentFuelLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_fuel_level'],
      ),
      techInspectionFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tech_inspection_file_path'],
      ),
      techInspectionExpiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tech_inspection_expiry_date'],
      ),
    );
  }

  @override
  $CarTableTable createAlias(String alias) {
    return $CarTableTable(attachedDatabase, alias);
  }
}

class CarTableData extends DataClass implements Insertable<CarTableData> {
  /// Уникальный идентификатор записи (UUID в виде строки).
  final String id;

  /// Марка автомобиля, например «Toyota».
  final String brand;

  /// Модель автомобиля, например «Camry».
  final String model;

  /// Текущий пробег по одометру в километрах.
  final int currentOdometer;

  /// Государственный регистрационный номер (необязательно).
  final String? licensePlate;

  /// VIN-номер кузова автомобиля (необязательно).
  final String? vin;

  /// Тип топлива по умолчанию (хранится как строка enum).
  /// Возможные значения: 'gasoline', 'diesel', 'lpg', 'electric', 'hybrid'.
  final String fuelType;

  /// Дата добавления записи об автомобиле.
  final DateTime createdAt;

  /// Путь к локальному PDF-файлу страховки. Null если файл не загружен.
  final String? insurancePdfPath;

  /// Дата окончания страховки. Null если пользователь не указал.
  final DateTime? insuranceExpiryDate;

  /// Пробег на момент последней замены масла. Null если замена не фиксировалась.
  final int? lastOilChangeOdometer;

  /// Средний расход топлива по данным бортового компьютера, л/100 км.
  final double? avgFuelConsumption;

  /// Объём топливного бака, литры.
  final int? fuelTankCapacity;

  /// Примерное количество топлива в баке на момент добавления, литры.
  final int? currentFuelLevel;

  /// Путь к локальному файлу техосмотра.
  final String? techInspectionFilePath;

  /// Дата окончания техосмотра.
  final DateTime? techInspectionExpiryDate;
  const CarTableData({
    required this.id,
    required this.brand,
    required this.model,
    required this.currentOdometer,
    this.licensePlate,
    this.vin,
    required this.fuelType,
    required this.createdAt,
    this.insurancePdfPath,
    this.insuranceExpiryDate,
    this.lastOilChangeOdometer,
    this.avgFuelConsumption,
    this.fuelTankCapacity,
    this.currentFuelLevel,
    this.techInspectionFilePath,
    this.techInspectionExpiryDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['current_odometer'] = Variable<int>(currentOdometer);
    if (!nullToAbsent || licensePlate != null) {
      map['license_plate'] = Variable<String>(licensePlate);
    }
    if (!nullToAbsent || vin != null) {
      map['vin'] = Variable<String>(vin);
    }
    map['fuel_type'] = Variable<String>(fuelType);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || insurancePdfPath != null) {
      map['insurance_pdf_path'] = Variable<String>(insurancePdfPath);
    }
    if (!nullToAbsent || insuranceExpiryDate != null) {
      map['insurance_expiry_date'] = Variable<DateTime>(insuranceExpiryDate);
    }
    if (!nullToAbsent || lastOilChangeOdometer != null) {
      map['last_oil_change_odometer'] = Variable<int>(lastOilChangeOdometer);
    }
    if (!nullToAbsent || avgFuelConsumption != null) {
      map['avg_fuel_consumption'] = Variable<double>(avgFuelConsumption);
    }
    if (!nullToAbsent || fuelTankCapacity != null) {
      map['fuel_tank_capacity'] = Variable<int>(fuelTankCapacity);
    }
    if (!nullToAbsent || currentFuelLevel != null) {
      map['current_fuel_level'] = Variable<int>(currentFuelLevel);
    }
    if (!nullToAbsent || techInspectionFilePath != null) {
      map['tech_inspection_file_path'] = Variable<String>(techInspectionFilePath);
    }
    if (!nullToAbsent || techInspectionExpiryDate != null) {
      map['tech_inspection_expiry_date'] = Variable<DateTime>(techInspectionExpiryDate);
    }
    return map;
  }

  CarTableCompanion toCompanion(bool nullToAbsent) {
    return CarTableCompanion(
      id: Value(id),
      brand: Value(brand),
      model: Value(model),
      currentOdometer: Value(currentOdometer),
      licensePlate: licensePlate == null && nullToAbsent
          ? const Value.absent()
          : Value(licensePlate),
      vin: vin == null && nullToAbsent ? const Value.absent() : Value(vin),
      fuelType: Value(fuelType),
      createdAt: Value(createdAt),
      insurancePdfPath: insurancePdfPath == null && nullToAbsent
          ? const Value.absent()
          : Value(insurancePdfPath),
      insuranceExpiryDate: insuranceExpiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceExpiryDate),
      lastOilChangeOdometer: lastOilChangeOdometer == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOilChangeOdometer),
      avgFuelConsumption: avgFuelConsumption == null && nullToAbsent
          ? const Value.absent()
          : Value(avgFuelConsumption),
      fuelTankCapacity: fuelTankCapacity == null && nullToAbsent
          ? const Value.absent()
          : Value(fuelTankCapacity),
      currentFuelLevel: currentFuelLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(currentFuelLevel),
      techInspectionFilePath: techInspectionFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(techInspectionFilePath),
      techInspectionExpiryDate: techInspectionExpiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(techInspectionExpiryDate),
    );
  }

  factory CarTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarTableData(
      id: serializer.fromJson<String>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      currentOdometer: serializer.fromJson<int>(json['currentOdometer']),
      licensePlate: serializer.fromJson<String?>(json['licensePlate']),
      vin: serializer.fromJson<String?>(json['vin']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      insurancePdfPath: serializer.fromJson<String?>(json['insurancePdfPath']),
      insuranceExpiryDate: serializer.fromJson<DateTime?>(
        json['insuranceExpiryDate'],
      ),
      lastOilChangeOdometer: serializer.fromJson<int?>(
        json['lastOilChangeOdometer'],
      ),
      avgFuelConsumption: serializer.fromJson<double?>(
        json['avgFuelConsumption'],
      ),
      fuelTankCapacity: serializer.fromJson<int?>(json['fuelTankCapacity']),
      currentFuelLevel: serializer.fromJson<int?>(json['currentFuelLevel']),
      techInspectionFilePath: serializer.fromJson<String?>(json['techInspectionFilePath']),
      techInspectionExpiryDate: serializer.fromJson<DateTime?>(json['techInspectionExpiryDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'currentOdometer': serializer.toJson<int>(currentOdometer),
      'licensePlate': serializer.toJson<String?>(licensePlate),
      'vin': serializer.toJson<String?>(vin),
      'fuelType': serializer.toJson<String>(fuelType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'insurancePdfPath': serializer.toJson<String?>(insurancePdfPath),
      'insuranceExpiryDate': serializer.toJson<DateTime?>(insuranceExpiryDate),
      'lastOilChangeOdometer': serializer.toJson<int?>(lastOilChangeOdometer),
      'avgFuelConsumption': serializer.toJson<double?>(avgFuelConsumption),
      'fuelTankCapacity': serializer.toJson<int?>(fuelTankCapacity),
      'currentFuelLevel': serializer.toJson<int?>(currentFuelLevel),
      'techInspectionFilePath': serializer.toJson<String?>(techInspectionFilePath),
      'techInspectionExpiryDate': serializer.toJson<DateTime?>(techInspectionExpiryDate),
    };
  }

  CarTableData copyWith({
    String? id,
    String? brand,
    String? model,
    int? currentOdometer,
    Value<String?> licensePlate = const Value.absent(),
    Value<String?> vin = const Value.absent(),
    String? fuelType,
    DateTime? createdAt,
    Value<String?> insurancePdfPath = const Value.absent(),
    Value<DateTime?> insuranceExpiryDate = const Value.absent(),
    Value<int?> lastOilChangeOdometer = const Value.absent(),
    Value<double?> avgFuelConsumption = const Value.absent(),
    Value<int?> fuelTankCapacity = const Value.absent(),
    Value<int?> currentFuelLevel = const Value.absent(),
    Value<String?> techInspectionFilePath = const Value.absent(),
    Value<DateTime?> techInspectionExpiryDate = const Value.absent(),
  }) => CarTableData(
    id: id ?? this.id,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    currentOdometer: currentOdometer ?? this.currentOdometer,
    licensePlate: licensePlate.present ? licensePlate.value : this.licensePlate,
    vin: vin.present ? vin.value : this.vin,
    fuelType: fuelType ?? this.fuelType,
    createdAt: createdAt ?? this.createdAt,
    insurancePdfPath: insurancePdfPath.present
        ? insurancePdfPath.value
        : this.insurancePdfPath,
    insuranceExpiryDate: insuranceExpiryDate.present
        ? insuranceExpiryDate.value
        : this.insuranceExpiryDate,
    lastOilChangeOdometer: lastOilChangeOdometer.present
        ? lastOilChangeOdometer.value
        : this.lastOilChangeOdometer,
    avgFuelConsumption: avgFuelConsumption.present
        ? avgFuelConsumption.value
        : this.avgFuelConsumption,
    fuelTankCapacity: fuelTankCapacity.present
        ? fuelTankCapacity.value
        : this.fuelTankCapacity,
    currentFuelLevel: currentFuelLevel.present
        ? currentFuelLevel.value
        : this.currentFuelLevel,
    techInspectionFilePath: techInspectionFilePath.present
        ? techInspectionFilePath.value
        : this.techInspectionFilePath,
    techInspectionExpiryDate: techInspectionExpiryDate.present
        ? techInspectionExpiryDate.value
        : this.techInspectionExpiryDate,
  );
  CarTableData copyWithCompanion(CarTableCompanion data) {
    return CarTableData(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      currentOdometer: data.currentOdometer.present
          ? data.currentOdometer.value
          : this.currentOdometer,
      licensePlate: data.licensePlate.present
          ? data.licensePlate.value
          : this.licensePlate,
      vin: data.vin.present ? data.vin.value : this.vin,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      insurancePdfPath: data.insurancePdfPath.present
          ? data.insurancePdfPath.value
          : this.insurancePdfPath,
      insuranceExpiryDate: data.insuranceExpiryDate.present
          ? data.insuranceExpiryDate.value
          : this.insuranceExpiryDate,
      lastOilChangeOdometer: data.lastOilChangeOdometer.present
          ? data.lastOilChangeOdometer.value
          : this.lastOilChangeOdometer,
      avgFuelConsumption: data.avgFuelConsumption.present
          ? data.avgFuelConsumption.value
          : this.avgFuelConsumption,
      fuelTankCapacity: data.fuelTankCapacity.present
          ? data.fuelTankCapacity.value
          : this.fuelTankCapacity,
      currentFuelLevel: data.currentFuelLevel.present
          ? data.currentFuelLevel.value
          : this.currentFuelLevel,
      techInspectionFilePath: data.techInspectionFilePath.present
          ? data.techInspectionFilePath.value
          : this.techInspectionFilePath,
      techInspectionExpiryDate: data.techInspectionExpiryDate.present
          ? data.techInspectionExpiryDate.value
          : this.techInspectionExpiryDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarTableData(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('currentOdometer: $currentOdometer, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('vin: $vin, ')
          ..write('fuelType: $fuelType, ')
          ..write('createdAt: $createdAt, ')
          ..write('insurancePdfPath: $insurancePdfPath, ')
          ..write('insuranceExpiryDate: $insuranceExpiryDate, ')
          ..write('lastOilChangeOdometer: $lastOilChangeOdometer, ')
          ..write('avgFuelConsumption: $avgFuelConsumption, ')
          ..write('fuelTankCapacity: $fuelTankCapacity, ')
          ..write('currentFuelLevel: $currentFuelLevel, ')
          ..write('techInspectionFilePath: $techInspectionFilePath, ')
          ..write('techInspectionExpiryDate: $techInspectionExpiryDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brand,
    model,
    currentOdometer,
    licensePlate,
    vin,
    fuelType,
    createdAt,
    insurancePdfPath,
    insuranceExpiryDate,
    lastOilChangeOdometer,
    avgFuelConsumption,
    fuelTankCapacity,
    currentFuelLevel,
    techInspectionFilePath,
    techInspectionExpiryDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarTableData &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.currentOdometer == this.currentOdometer &&
          other.licensePlate == this.licensePlate &&
          other.vin == this.vin &&
          other.fuelType == this.fuelType &&
          other.createdAt == this.createdAt &&
          other.insurancePdfPath == this.insurancePdfPath &&
          other.insuranceExpiryDate == this.insuranceExpiryDate &&
          other.lastOilChangeOdometer == this.lastOilChangeOdometer &&
          other.avgFuelConsumption == this.avgFuelConsumption &&
          other.fuelTankCapacity == this.fuelTankCapacity &&
          other.currentFuelLevel == this.currentFuelLevel &&
          other.techInspectionFilePath == this.techInspectionFilePath &&
          other.techInspectionExpiryDate == this.techInspectionExpiryDate);
}

class CarTableCompanion extends UpdateCompanion<CarTableData> {
  final Value<String> id;
  final Value<String> brand;
  final Value<String> model;
  final Value<int> currentOdometer;
  final Value<String?> licensePlate;
  final Value<String?> vin;
  final Value<String> fuelType;
  final Value<DateTime> createdAt;
  final Value<String?> insurancePdfPath;
  final Value<DateTime?> insuranceExpiryDate;
  final Value<int?> lastOilChangeOdometer;
  final Value<double?> avgFuelConsumption;
  final Value<int?> fuelTankCapacity;
  final Value<int?> currentFuelLevel;
  final Value<String?> techInspectionFilePath;
  final Value<DateTime?> techInspectionExpiryDate;
  final Value<int> rowid;
  const CarTableCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.currentOdometer = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.vin = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.insurancePdfPath = const Value.absent(),
    this.insuranceExpiryDate = const Value.absent(),
    this.lastOilChangeOdometer = const Value.absent(),
    this.avgFuelConsumption = const Value.absent(),
    this.fuelTankCapacity = const Value.absent(),
    this.currentFuelLevel = const Value.absent(),
    this.techInspectionFilePath = const Value.absent(),
    this.techInspectionExpiryDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarTableCompanion.insert({
    required String id,
    required String brand,
    required String model,
    required int currentOdometer,
    this.licensePlate = const Value.absent(),
    this.vin = const Value.absent(),
    this.fuelType = const Value.absent(),
    required DateTime createdAt,
    this.insurancePdfPath = const Value.absent(),
    this.insuranceExpiryDate = const Value.absent(),
    this.lastOilChangeOdometer = const Value.absent(),
    this.avgFuelConsumption = const Value.absent(),
    this.fuelTankCapacity = const Value.absent(),
    this.currentFuelLevel = const Value.absent(),
    this.techInspectionFilePath = const Value.absent(),
    this.techInspectionExpiryDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       brand = Value(brand),
       model = Value(model),
       currentOdometer = Value(currentOdometer),
       createdAt = Value(createdAt);
  static Insertable<CarTableData> custom({
    Expression<String>? id,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? currentOdometer,
    Expression<String>? licensePlate,
    Expression<String>? vin,
    Expression<String>? fuelType,
    Expression<DateTime>? createdAt,
    Expression<String>? insurancePdfPath,
    Expression<DateTime>? insuranceExpiryDate,
    Expression<int>? lastOilChangeOdometer,
    Expression<double>? avgFuelConsumption,
    Expression<int>? fuelTankCapacity,
    Expression<int>? currentFuelLevel,
    Expression<String>? techInspectionFilePath,
    Expression<DateTime>? techInspectionExpiryDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (currentOdometer != null) 'current_odometer': currentOdometer,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (vin != null) 'vin': vin,
      if (fuelType != null) 'fuel_type': fuelType,
      if (createdAt != null) 'created_at': createdAt,
      if (insurancePdfPath != null) 'insurance_pdf_path': insurancePdfPath,
      if (insuranceExpiryDate != null)
        'insurance_expiry_date': insuranceExpiryDate,
      if (lastOilChangeOdometer != null)
        'last_oil_change_odometer': lastOilChangeOdometer,
      if (avgFuelConsumption != null)
        'avg_fuel_consumption': avgFuelConsumption,
      if (fuelTankCapacity != null) 'fuel_tank_capacity': fuelTankCapacity,
      if (currentFuelLevel != null) 'current_fuel_level': currentFuelLevel,
      if (techInspectionFilePath != null) 'tech_inspection_file_path': techInspectionFilePath,
      if (techInspectionExpiryDate != null) 'tech_inspection_expiry_date': techInspectionExpiryDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarTableCompanion copyWith({
    Value<String>? id,
    Value<String>? brand,
    Value<String>? model,
    Value<int>? currentOdometer,
    Value<String?>? licensePlate,
    Value<String?>? vin,
    Value<String>? fuelType,
    Value<DateTime>? createdAt,
    Value<String?>? insurancePdfPath,
    Value<DateTime?>? insuranceExpiryDate,
    Value<int?>? lastOilChangeOdometer,
    Value<double?>? avgFuelConsumption,
    Value<int?>? fuelTankCapacity,
    Value<int?>? currentFuelLevel,
    Value<String?>? techInspectionFilePath,
    Value<DateTime?>? techInspectionExpiryDate,
    Value<int>? rowid,
  }) {
    return CarTableCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      licensePlate: licensePlate ?? this.licensePlate,
      vin: vin ?? this.vin,
      fuelType: fuelType ?? this.fuelType,
      createdAt: createdAt ?? this.createdAt,
      insurancePdfPath: insurancePdfPath ?? this.insurancePdfPath,
      insuranceExpiryDate: insuranceExpiryDate ?? this.insuranceExpiryDate,
      lastOilChangeOdometer:
          lastOilChangeOdometer ?? this.lastOilChangeOdometer,
      avgFuelConsumption: avgFuelConsumption ?? this.avgFuelConsumption,
      fuelTankCapacity: fuelTankCapacity ?? this.fuelTankCapacity,
      currentFuelLevel: currentFuelLevel ?? this.currentFuelLevel,
      techInspectionFilePath: techInspectionFilePath ?? this.techInspectionFilePath,
      techInspectionExpiryDate: techInspectionExpiryDate ?? this.techInspectionExpiryDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (currentOdometer.present) {
      map['current_odometer'] = Variable<int>(currentOdometer.value);
    }
    if (licensePlate.present) {
      map['license_plate'] = Variable<String>(licensePlate.value);
    }
    if (vin.present) {
      map['vin'] = Variable<String>(vin.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (insurancePdfPath.present) {
      map['insurance_pdf_path'] = Variable<String>(insurancePdfPath.value);
    }
    if (insuranceExpiryDate.present) {
      map['insurance_expiry_date'] = Variable<DateTime>(
        insuranceExpiryDate.value,
      );
    }
    if (lastOilChangeOdometer.present) {
      map['last_oil_change_odometer'] = Variable<int>(
        lastOilChangeOdometer.value,
      );
    }
    if (avgFuelConsumption.present) {
      map['avg_fuel_consumption'] = Variable<double>(avgFuelConsumption.value);
    }
    if (fuelTankCapacity.present) {
      map['fuel_tank_capacity'] = Variable<int>(fuelTankCapacity.value);
    }
    if (currentFuelLevel.present) {
      map['current_fuel_level'] = Variable<int>(currentFuelLevel.value);
    }
    if (techInspectionFilePath.present) {
      map['tech_inspection_file_path'] = Variable<String>(techInspectionFilePath.value);
    }
    if (techInspectionExpiryDate.present) {
      map['tech_inspection_expiry_date'] = Variable<DateTime>(techInspectionExpiryDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarTableCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('currentOdometer: $currentOdometer, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('vin: $vin, ')
          ..write('fuelType: $fuelType, ')
          ..write('createdAt: $createdAt, ')
          ..write('insurancePdfPath: $insurancePdfPath, ')
          ..write('insuranceExpiryDate: $insuranceExpiryDate, ')
          ..write('lastOilChangeOdometer: $lastOilChangeOdometer, ')
          ..write('avgFuelConsumption: $avgFuelConsumption, ')
          ..write('fuelTankCapacity: $fuelTankCapacity, ')
          ..write('currentFuelLevel: $currentFuelLevel, ')
          ..write('techInspectionFilePath: $techInspectionFilePath, ')
          ..write('techInspectionExpiryDate: $techInspectionExpiryDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RefuelingTableTable extends RefuelingTable
    with TableInfo<$RefuelingTableTable, RefuelingTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefuelingTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<String> carId = GeneratedColumn<String>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES car_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<int> odometer = GeneratedColumn<int>(
    'odometer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _litersMeta = const VerificationMeta('liters');
  @override
  late final GeneratedColumn<double> liters = GeneratedColumn<double>(
    'liters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFullTankMeta = const VerificationMeta(
    'isFullTank',
  );
  @override
  late final GeneratedColumn<bool> isFullTank = GeneratedColumn<bool>(
    'is_full_tank',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_full_tank" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _stationNameMeta = const VerificationMeta(
    'stationName',
  );
  @override
  late final GeneratedColumn<String> stationName = GeneratedColumn<String>(
    'station_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    carId,
    date,
    odometer,
    liters,
    totalCost,
    isFullTank,
    stationName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refueling_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RefuelingTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    } else if (isInserting) {
      context.missing(_odometerMeta);
    }
    if (data.containsKey('liters')) {
      context.handle(
        _litersMeta,
        liters.isAcceptableOrUnknown(data['liters']!, _litersMeta),
      );
    } else if (isInserting) {
      context.missing(_litersMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('is_full_tank')) {
      context.handle(
        _isFullTankMeta,
        isFullTank.isAcceptableOrUnknown(
          data['is_full_tank']!,
          _isFullTankMeta,
        ),
      );
    }
    if (data.containsKey('station_name')) {
      context.handle(
        _stationNameMeta,
        stationName.isAcceptableOrUnknown(
          data['station_name']!,
          _stationNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RefuelingTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RefuelingTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}car_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometer'],
      )!,
      liters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}liters'],
      )!,
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost'],
      )!,
      isFullTank: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_full_tank'],
      )!,
      stationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_name'],
      ),
    );
  }

  @override
  $RefuelingTableTable createAlias(String alias) {
    return $RefuelingTableTable(attachedDatabase, alias);
  }
}

class RefuelingTableData extends DataClass
    implements Insertable<RefuelingTableData> {
  /// Уникальный идентификатор записи (UUID).
  final String id;

  /// Ссылка на автомобиль. При удалении авто — каскадно удаляем заправки.
  final String carId;

  /// Дата и время заправки.
  final DateTime date;

  /// Показание одометра на момент заправки (км).
  final int odometer;

  /// Количество залитых литров топлива.
  final double liters;

  /// Общая стоимость заправки в рублях/копейках (хранится как double).
  final double totalCost;

  /// Признак «заправлено до полного бака».
  /// Используется для расчёта точного расхода топлива.
  final bool isFullTank;

  /// Название АЗС (необязательно), например «Лукойл», «Газпромнефть».
  final String? stationName;
  const RefuelingTableData({
    required this.id,
    required this.carId,
    required this.date,
    required this.odometer,
    required this.liters,
    required this.totalCost,
    required this.isFullTank,
    this.stationName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['car_id'] = Variable<String>(carId);
    map['date'] = Variable<DateTime>(date);
    map['odometer'] = Variable<int>(odometer);
    map['liters'] = Variable<double>(liters);
    map['total_cost'] = Variable<double>(totalCost);
    map['is_full_tank'] = Variable<bool>(isFullTank);
    if (!nullToAbsent || stationName != null) {
      map['station_name'] = Variable<String>(stationName);
    }
    return map;
  }

  RefuelingTableCompanion toCompanion(bool nullToAbsent) {
    return RefuelingTableCompanion(
      id: Value(id),
      carId: Value(carId),
      date: Value(date),
      odometer: Value(odometer),
      liters: Value(liters),
      totalCost: Value(totalCost),
      isFullTank: Value(isFullTank),
      stationName: stationName == null && nullToAbsent
          ? const Value.absent()
          : Value(stationName),
    );
  }

  factory RefuelingTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RefuelingTableData(
      id: serializer.fromJson<String>(json['id']),
      carId: serializer.fromJson<String>(json['carId']),
      date: serializer.fromJson<DateTime>(json['date']),
      odometer: serializer.fromJson<int>(json['odometer']),
      liters: serializer.fromJson<double>(json['liters']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      isFullTank: serializer.fromJson<bool>(json['isFullTank']),
      stationName: serializer.fromJson<String?>(json['stationName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'carId': serializer.toJson<String>(carId),
      'date': serializer.toJson<DateTime>(date),
      'odometer': serializer.toJson<int>(odometer),
      'liters': serializer.toJson<double>(liters),
      'totalCost': serializer.toJson<double>(totalCost),
      'isFullTank': serializer.toJson<bool>(isFullTank),
      'stationName': serializer.toJson<String?>(stationName),
    };
  }

  RefuelingTableData copyWith({
    String? id,
    String? carId,
    DateTime? date,
    int? odometer,
    double? liters,
    double? totalCost,
    bool? isFullTank,
    Value<String?> stationName = const Value.absent(),
  }) => RefuelingTableData(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    date: date ?? this.date,
    odometer: odometer ?? this.odometer,
    liters: liters ?? this.liters,
    totalCost: totalCost ?? this.totalCost,
    isFullTank: isFullTank ?? this.isFullTank,
    stationName: stationName.present ? stationName.value : this.stationName,
  );
  RefuelingTableData copyWithCompanion(RefuelingTableCompanion data) {
    return RefuelingTableData(
      id: data.id.present ? data.id.value : this.id,
      carId: data.carId.present ? data.carId.value : this.carId,
      date: data.date.present ? data.date.value : this.date,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      liters: data.liters.present ? data.liters.value : this.liters,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      isFullTank: data.isFullTank.present
          ? data.isFullTank.value
          : this.isFullTank,
      stationName: data.stationName.present
          ? data.stationName.value
          : this.stationName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RefuelingTableData(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('liters: $liters, ')
          ..write('totalCost: $totalCost, ')
          ..write('isFullTank: $isFullTank, ')
          ..write('stationName: $stationName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    carId,
    date,
    odometer,
    liters,
    totalCost,
    isFullTank,
    stationName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RefuelingTableData &&
          other.id == this.id &&
          other.carId == this.carId &&
          other.date == this.date &&
          other.odometer == this.odometer &&
          other.liters == this.liters &&
          other.totalCost == this.totalCost &&
          other.isFullTank == this.isFullTank &&
          other.stationName == this.stationName);
}

class RefuelingTableCompanion extends UpdateCompanion<RefuelingTableData> {
  final Value<String> id;
  final Value<String> carId;
  final Value<DateTime> date;
  final Value<int> odometer;
  final Value<double> liters;
  final Value<double> totalCost;
  final Value<bool> isFullTank;
  final Value<String?> stationName;
  final Value<int> rowid;
  const RefuelingTableCompanion({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    this.date = const Value.absent(),
    this.odometer = const Value.absent(),
    this.liters = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.isFullTank = const Value.absent(),
    this.stationName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RefuelingTableCompanion.insert({
    required String id,
    required String carId,
    required DateTime date,
    required int odometer,
    required double liters,
    required double totalCost,
    this.isFullTank = const Value.absent(),
    this.stationName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       carId = Value(carId),
       date = Value(date),
       odometer = Value(odometer),
       liters = Value(liters),
       totalCost = Value(totalCost);
  static Insertable<RefuelingTableData> custom({
    Expression<String>? id,
    Expression<String>? carId,
    Expression<DateTime>? date,
    Expression<int>? odometer,
    Expression<double>? liters,
    Expression<double>? totalCost,
    Expression<bool>? isFullTank,
    Expression<String>? stationName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (carId != null) 'car_id': carId,
      if (date != null) 'date': date,
      if (odometer != null) 'odometer': odometer,
      if (liters != null) 'liters': liters,
      if (totalCost != null) 'total_cost': totalCost,
      if (isFullTank != null) 'is_full_tank': isFullTank,
      if (stationName != null) 'station_name': stationName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RefuelingTableCompanion copyWith({
    Value<String>? id,
    Value<String>? carId,
    Value<DateTime>? date,
    Value<int>? odometer,
    Value<double>? liters,
    Value<double>? totalCost,
    Value<bool>? isFullTank,
    Value<String?>? stationName,
    Value<int>? rowid,
  }) {
    return RefuelingTableCompanion(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      liters: liters ?? this.liters,
      totalCost: totalCost ?? this.totalCost,
      isFullTank: isFullTank ?? this.isFullTank,
      stationName: stationName ?? this.stationName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<String>(carId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<int>(odometer.value);
    }
    if (liters.present) {
      map['liters'] = Variable<double>(liters.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (isFullTank.present) {
      map['is_full_tank'] = Variable<bool>(isFullTank.value);
    }
    if (stationName.present) {
      map['station_name'] = Variable<String>(stationName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefuelingTableCompanion(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('liters: $liters, ')
          ..write('totalCost: $totalCost, ')
          ..write('isFullTank: $isFullTank, ')
          ..write('stationName: $stationName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseTableTable extends ExpenseTable
    with TableInfo<$ExpenseTableTable, ExpenseTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<String> carId = GeneratedColumn<String>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES car_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    carId,
    date,
    category,
    cost,
    title,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}car_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ExpenseTableTable createAlias(String alias) {
    return $ExpenseTableTable(attachedDatabase, alias);
  }
}

class ExpenseTableData extends DataClass
    implements Insertable<ExpenseTableData> {
  /// Уникальный идентификатор записи (UUID).
  final String id;

  /// Ссылка на автомобиль.
  final String carId;

  /// Дата и время расхода.
  final DateTime date;

  /// Категория расхода (строковое значение enum [ExpenseCategory]).
  /// Возможные значения: 'service', 'insurance', 'carwash', 'fine',
  /// 'parking', 'other'.
  final String category;

  /// Сумма расхода в рублях.
  final double cost;

  /// Короткое название события, например «ТО», «ОСАГО 2025».
  final String title;

  /// Дополнительная текстовая заметка (необязательно).
  final String? note;
  const ExpenseTableData({
    required this.id,
    required this.carId,
    required this.date,
    required this.category,
    required this.cost,
    required this.title,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['car_id'] = Variable<String>(carId);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    map['cost'] = Variable<double>(cost);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ExpenseTableCompanion toCompanion(bool nullToAbsent) {
    return ExpenseTableCompanion(
      id: Value(id),
      carId: Value(carId),
      date: Value(date),
      category: Value(category),
      cost: Value(cost),
      title: Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory ExpenseTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseTableData(
      id: serializer.fromJson<String>(json['id']),
      carId: serializer.fromJson<String>(json['carId']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      cost: serializer.fromJson<double>(json['cost']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'carId': serializer.toJson<String>(carId),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'cost': serializer.toJson<double>(cost),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String?>(note),
    };
  }

  ExpenseTableData copyWith({
    String? id,
    String? carId,
    DateTime? date,
    String? category,
    double? cost,
    String? title,
    Value<String?> note = const Value.absent(),
  }) => ExpenseTableData(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    date: date ?? this.date,
    category: category ?? this.category,
    cost: cost ?? this.cost,
    title: title ?? this.title,
    note: note.present ? note.value : this.note,
  );
  ExpenseTableData copyWithCompanion(ExpenseTableCompanion data) {
    return ExpenseTableData(
      id: data.id.present ? data.id.value : this.id,
      carId: data.carId.present ? data.carId.value : this.carId,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      cost: data.cost.present ? data.cost.value : this.cost,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTableData(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('cost: $cost, ')
          ..write('title: $title, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, carId, date, category, cost, title, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseTableData &&
          other.id == this.id &&
          other.carId == this.carId &&
          other.date == this.date &&
          other.category == this.category &&
          other.cost == this.cost &&
          other.title == this.title &&
          other.note == this.note);
}

class ExpenseTableCompanion extends UpdateCompanion<ExpenseTableData> {
  final Value<String> id;
  final Value<String> carId;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<double> cost;
  final Value<String> title;
  final Value<String?> note;
  final Value<int> rowid;
  const ExpenseTableCompanion({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.cost = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseTableCompanion.insert({
    required String id,
    required String carId,
    required DateTime date,
    required String category,
    required double cost,
    required String title,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       carId = Value(carId),
       date = Value(date),
       category = Value(category),
       cost = Value(cost),
       title = Value(title);
  static Insertable<ExpenseTableData> custom({
    Expression<String>? id,
    Expression<String>? carId,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<double>? cost,
    Expression<String>? title,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (carId != null) 'car_id': carId,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (cost != null) 'cost': cost,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseTableCompanion copyWith({
    Value<String>? id,
    Value<String>? carId,
    Value<DateTime>? date,
    Value<String>? category,
    Value<double>? cost,
    Value<String>? title,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return ExpenseTableCompanion(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      date: date ?? this.date,
      category: category ?? this.category,
      cost: cost ?? this.cost,
      title: title ?? this.title,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<String>(carId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTableCompanion(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('cost: $cost, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CarTableTable carTable = $CarTableTable(this);
  late final $RefuelingTableTable refuelingTable = $RefuelingTableTable(this);
  late final $ExpenseTableTable expenseTable = $ExpenseTableTable(this);
  late final $TripLogTableTable tripLogTable = $TripLogTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    carTable,
    refuelingTable,
    expenseTable,
    tripLogTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'car_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('refueling_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'car_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expense_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CarTableTableCreateCompanionBuilder =
    CarTableCompanion Function({
      required String id,
      required String brand,
      required String model,
      required int currentOdometer,
      Value<String?> licensePlate,
      Value<String?> vin,
      Value<String> fuelType,
      required DateTime createdAt,
      Value<String?> insurancePdfPath,
      Value<DateTime?> insuranceExpiryDate,
      Value<int?> lastOilChangeOdometer,
      Value<double?> avgFuelConsumption,
      Value<int?> fuelTankCapacity,
      Value<int?> currentFuelLevel,
      Value<int> rowid,
    });
typedef $$CarTableTableUpdateCompanionBuilder =
    CarTableCompanion Function({
      Value<String> id,
      Value<String> brand,
      Value<String> model,
      Value<int> currentOdometer,
      Value<String?> licensePlate,
      Value<String?> vin,
      Value<String> fuelType,
      Value<DateTime> createdAt,
      Value<String?> insurancePdfPath,
      Value<DateTime?> insuranceExpiryDate,
      Value<int?> lastOilChangeOdometer,
      Value<double?> avgFuelConsumption,
      Value<int?> fuelTankCapacity,
      Value<int?> currentFuelLevel,
      Value<int> rowid,
    });

final class $$CarTableTableReferences
    extends BaseReferences<_$AppDatabase, $CarTableTable, CarTableData> {
  $$CarTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RefuelingTableTable, List<RefuelingTableData>>
  _refuelingTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.refuelingTable,
    aliasName: $_aliasNameGenerator(db.carTable.id, db.refuelingTable.carId),
  );

  $$RefuelingTableTableProcessedTableManager get refuelingTableRefs {
    final manager = $$RefuelingTableTableTableManager(
      $_db,
      $_db.refuelingTable,
    ).filter((f) => f.carId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_refuelingTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpenseTableTable, List<ExpenseTableData>>
  _expenseTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenseTable,
    aliasName: $_aliasNameGenerator(db.carTable.id, db.expenseTable.carId),
  );

  $$ExpenseTableTableProcessedTableManager get expenseTableRefs {
    final manager = $$ExpenseTableTableTableManager(
      $_db,
      $_db.expenseTable,
    ).filter((f) => f.carId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expenseTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CarTableTableFilterComposer
    extends Composer<_$AppDatabase, $CarTableTable> {
  $$CarTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentOdometer => $composableBuilder(
    column: $table.currentOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vin => $composableBuilder(
    column: $table.vin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insurancePdfPath => $composableBuilder(
    column: $table.insurancePdfPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get insuranceExpiryDate => $composableBuilder(
    column: $table.insuranceExpiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastOilChangeOdometer => $composableBuilder(
    column: $table.lastOilChangeOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgFuelConsumption => $composableBuilder(
    column: $table.avgFuelConsumption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fuelTankCapacity => $composableBuilder(
    column: $table.fuelTankCapacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentFuelLevel => $composableBuilder(
    column: $table.currentFuelLevel,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> refuelingTableRefs(
    Expression<bool> Function($$RefuelingTableTableFilterComposer f) f,
  ) {
    final $$RefuelingTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refuelingTable,
      getReferencedColumn: (t) => t.carId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefuelingTableTableFilterComposer(
            $db: $db,
            $table: $db.refuelingTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expenseTableRefs(
    Expression<bool> Function($$ExpenseTableTableFilterComposer f) f,
  ) {
    final $$ExpenseTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseTable,
      getReferencedColumn: (t) => t.carId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseTableTableFilterComposer(
            $db: $db,
            $table: $db.expenseTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CarTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CarTableTable> {
  $$CarTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentOdometer => $composableBuilder(
    column: $table.currentOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vin => $composableBuilder(
    column: $table.vin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insurancePdfPath => $composableBuilder(
    column: $table.insurancePdfPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get insuranceExpiryDate => $composableBuilder(
    column: $table.insuranceExpiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastOilChangeOdometer => $composableBuilder(
    column: $table.lastOilChangeOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgFuelConsumption => $composableBuilder(
    column: $table.avgFuelConsumption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fuelTankCapacity => $composableBuilder(
    column: $table.fuelTankCapacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentFuelLevel => $composableBuilder(
    column: $table.currentFuelLevel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CarTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarTableTable> {
  $$CarTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get currentOdometer => $composableBuilder(
    column: $table.currentOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vin =>
      $composableBuilder(column: $table.vin, builder: (column) => column);

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get insurancePdfPath => $composableBuilder(
    column: $table.insurancePdfPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get insuranceExpiryDate => $composableBuilder(
    column: $table.insuranceExpiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastOilChangeOdometer => $composableBuilder(
    column: $table.lastOilChangeOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgFuelConsumption => $composableBuilder(
    column: $table.avgFuelConsumption,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fuelTankCapacity => $composableBuilder(
    column: $table.fuelTankCapacity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentFuelLevel => $composableBuilder(
    column: $table.currentFuelLevel,
    builder: (column) => column,
  );

  Expression<T> refuelingTableRefs<T extends Object>(
    Expression<T> Function($$RefuelingTableTableAnnotationComposer a) f,
  ) {
    final $$RefuelingTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refuelingTable,
      getReferencedColumn: (t) => t.carId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefuelingTableTableAnnotationComposer(
            $db: $db,
            $table: $db.refuelingTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expenseTableRefs<T extends Object>(
    Expression<T> Function($$ExpenseTableTableAnnotationComposer a) f,
  ) {
    final $$ExpenseTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseTable,
      getReferencedColumn: (t) => t.carId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseTableTableAnnotationComposer(
            $db: $db,
            $table: $db.expenseTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CarTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarTableTable,
          CarTableData,
          $$CarTableTableFilterComposer,
          $$CarTableTableOrderingComposer,
          $$CarTableTableAnnotationComposer,
          $$CarTableTableCreateCompanionBuilder,
          $$CarTableTableUpdateCompanionBuilder,
          (CarTableData, $$CarTableTableReferences),
          CarTableData,
          PrefetchHooks Function({
            bool refuelingTableRefs,
            bool expenseTableRefs,
          })
        > {
  $$CarTableTableTableManager(_$AppDatabase db, $CarTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> currentOdometer = const Value.absent(),
                Value<String?> licensePlate = const Value.absent(),
                Value<String?> vin = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> insurancePdfPath = const Value.absent(),
                Value<DateTime?> insuranceExpiryDate = const Value.absent(),
                Value<int?> lastOilChangeOdometer = const Value.absent(),
                Value<double?> avgFuelConsumption = const Value.absent(),
                Value<int?> fuelTankCapacity = const Value.absent(),
                Value<int?> currentFuelLevel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarTableCompanion(
                id: id,
                brand: brand,
                model: model,
                currentOdometer: currentOdometer,
                licensePlate: licensePlate,
                vin: vin,
                fuelType: fuelType,
                createdAt: createdAt,
                insurancePdfPath: insurancePdfPath,
                insuranceExpiryDate: insuranceExpiryDate,
                lastOilChangeOdometer: lastOilChangeOdometer,
                avgFuelConsumption: avgFuelConsumption,
                fuelTankCapacity: fuelTankCapacity,
                currentFuelLevel: currentFuelLevel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String brand,
                required String model,
                required int currentOdometer,
                Value<String?> licensePlate = const Value.absent(),
                Value<String?> vin = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                required DateTime createdAt,
                Value<String?> insurancePdfPath = const Value.absent(),
                Value<DateTime?> insuranceExpiryDate = const Value.absent(),
                Value<int?> lastOilChangeOdometer = const Value.absent(),
                Value<double?> avgFuelConsumption = const Value.absent(),
                Value<int?> fuelTankCapacity = const Value.absent(),
                Value<int?> currentFuelLevel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarTableCompanion.insert(
                id: id,
                brand: brand,
                model: model,
                currentOdometer: currentOdometer,
                licensePlate: licensePlate,
                vin: vin,
                fuelType: fuelType,
                createdAt: createdAt,
                insurancePdfPath: insurancePdfPath,
                insuranceExpiryDate: insuranceExpiryDate,
                lastOilChangeOdometer: lastOilChangeOdometer,
                avgFuelConsumption: avgFuelConsumption,
                fuelTankCapacity: fuelTankCapacity,
                currentFuelLevel: currentFuelLevel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CarTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({refuelingTableRefs = false, expenseTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (refuelingTableRefs) db.refuelingTable,
                    if (expenseTableRefs) db.expenseTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (refuelingTableRefs)
                        await $_getPrefetchedData<
                          CarTableData,
                          $CarTableTable,
                          RefuelingTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CarTableTableReferences
                              ._refuelingTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CarTableTableReferences(
                                db,
                                table,
                                p0,
                              ).refuelingTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.carId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expenseTableRefs)
                        await $_getPrefetchedData<
                          CarTableData,
                          $CarTableTable,
                          ExpenseTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CarTableTableReferences
                              ._expenseTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CarTableTableReferences(
                                db,
                                table,
                                p0,
                              ).expenseTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.carId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CarTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarTableTable,
      CarTableData,
      $$CarTableTableFilterComposer,
      $$CarTableTableOrderingComposer,
      $$CarTableTableAnnotationComposer,
      $$CarTableTableCreateCompanionBuilder,
      $$CarTableTableUpdateCompanionBuilder,
      (CarTableData, $$CarTableTableReferences),
      CarTableData,
      PrefetchHooks Function({bool refuelingTableRefs, bool expenseTableRefs})
    >;
typedef $$RefuelingTableTableCreateCompanionBuilder =
    RefuelingTableCompanion Function({
      required String id,
      required String carId,
      required DateTime date,
      required int odometer,
      required double liters,
      required double totalCost,
      Value<bool> isFullTank,
      Value<String?> stationName,
      Value<int> rowid,
    });
typedef $$RefuelingTableTableUpdateCompanionBuilder =
    RefuelingTableCompanion Function({
      Value<String> id,
      Value<String> carId,
      Value<DateTime> date,
      Value<int> odometer,
      Value<double> liters,
      Value<double> totalCost,
      Value<bool> isFullTank,
      Value<String?> stationName,
      Value<int> rowid,
    });

final class $$RefuelingTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RefuelingTableTable,
          RefuelingTableData
        > {
  $$RefuelingTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CarTableTable _carIdTable(_$AppDatabase db) =>
      db.carTable.createAlias(
        $_aliasNameGenerator(db.refuelingTable.carId, db.carTable.id),
      );

  $$CarTableTableProcessedTableManager get carId {
    final $_column = $_itemColumn<String>('car_id')!;

    final manager = $$CarTableTableTableManager(
      $_db,
      $_db.carTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_carIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RefuelingTableTableFilterComposer
    extends Composer<_$AppDatabase, $RefuelingTableTable> {
  $$RefuelingTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFullTank => $composableBuilder(
    column: $table.isFullTank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnFilters(column),
  );

  $$CarTableTableFilterComposer get carId {
    final $$CarTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarTableTableFilterComposer(
            $db: $db,
            $table: $db.carTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefuelingTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RefuelingTableTable> {
  $$RefuelingTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFullTank => $composableBuilder(
    column: $table.isFullTank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnOrderings(column),
  );

  $$CarTableTableOrderingComposer get carId {
    final $$CarTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarTableTableOrderingComposer(
            $db: $db,
            $table: $db.carTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefuelingTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RefuelingTableTable> {
  $$RefuelingTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<double> get liters =>
      $composableBuilder(column: $table.liters, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<bool> get isFullTank => $composableBuilder(
    column: $table.isFullTank,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => column,
  );

  $$CarTableTableAnnotationComposer get carId {
    final $$CarTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarTableTableAnnotationComposer(
            $db: $db,
            $table: $db.carTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefuelingTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RefuelingTableTable,
          RefuelingTableData,
          $$RefuelingTableTableFilterComposer,
          $$RefuelingTableTableOrderingComposer,
          $$RefuelingTableTableAnnotationComposer,
          $$RefuelingTableTableCreateCompanionBuilder,
          $$RefuelingTableTableUpdateCompanionBuilder,
          (RefuelingTableData, $$RefuelingTableTableReferences),
          RefuelingTableData,
          PrefetchHooks Function({bool carId})
        > {
  $$RefuelingTableTableTableManager(
    _$AppDatabase db,
    $RefuelingTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RefuelingTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RefuelingTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RefuelingTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> carId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> odometer = const Value.absent(),
                Value<double> liters = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<bool> isFullTank = const Value.absent(),
                Value<String?> stationName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RefuelingTableCompanion(
                id: id,
                carId: carId,
                date: date,
                odometer: odometer,
                liters: liters,
                totalCost: totalCost,
                isFullTank: isFullTank,
                stationName: stationName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String carId,
                required DateTime date,
                required int odometer,
                required double liters,
                required double totalCost,
                Value<bool> isFullTank = const Value.absent(),
                Value<String?> stationName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RefuelingTableCompanion.insert(
                id: id,
                carId: carId,
                date: date,
                odometer: odometer,
                liters: liters,
                totalCost: totalCost,
                isFullTank: isFullTank,
                stationName: stationName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RefuelingTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({carId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (carId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.carId,
                                referencedTable: $$RefuelingTableTableReferences
                                    ._carIdTable(db),
                                referencedColumn:
                                    $$RefuelingTableTableReferences
                                        ._carIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RefuelingTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RefuelingTableTable,
      RefuelingTableData,
      $$RefuelingTableTableFilterComposer,
      $$RefuelingTableTableOrderingComposer,
      $$RefuelingTableTableAnnotationComposer,
      $$RefuelingTableTableCreateCompanionBuilder,
      $$RefuelingTableTableUpdateCompanionBuilder,
      (RefuelingTableData, $$RefuelingTableTableReferences),
      RefuelingTableData,
      PrefetchHooks Function({bool carId})
    >;
typedef $$ExpenseTableTableCreateCompanionBuilder =
    ExpenseTableCompanion Function({
      required String id,
      required String carId,
      required DateTime date,
      required String category,
      required double cost,
      required String title,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$ExpenseTableTableUpdateCompanionBuilder =
    ExpenseTableCompanion Function({
      Value<String> id,
      Value<String> carId,
      Value<DateTime> date,
      Value<String> category,
      Value<double> cost,
      Value<String> title,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$ExpenseTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExpenseTableTable, ExpenseTableData> {
  $$ExpenseTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CarTableTable _carIdTable(_$AppDatabase db) => db.carTable
      .createAlias($_aliasNameGenerator(db.expenseTable.carId, db.carTable.id));

  $$CarTableTableProcessedTableManager get carId {
    final $_column = $_itemColumn<String>('car_id')!;

    final manager = $$CarTableTableTableManager(
      $_db,
      $_db.carTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_carIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpenseTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseTableTable> {
  $$ExpenseTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$CarTableTableFilterComposer get carId {
    final $$CarTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarTableTableFilterComposer(
            $db: $db,
            $table: $db.carTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseTableTable> {
  $$ExpenseTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$CarTableTableOrderingComposer get carId {
    final $$CarTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarTableTableOrderingComposer(
            $db: $db,
            $table: $db.carTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseTableTable> {
  $$ExpenseTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$CarTableTableAnnotationComposer get carId {
    final $$CarTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarTableTableAnnotationComposer(
            $db: $db,
            $table: $db.carTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseTableTable,
          ExpenseTableData,
          $$ExpenseTableTableFilterComposer,
          $$ExpenseTableTableOrderingComposer,
          $$ExpenseTableTableAnnotationComposer,
          $$ExpenseTableTableCreateCompanionBuilder,
          $$ExpenseTableTableUpdateCompanionBuilder,
          (ExpenseTableData, $$ExpenseTableTableReferences),
          ExpenseTableData,
          PrefetchHooks Function({bool carId})
        > {
  $$ExpenseTableTableTableManager(_$AppDatabase db, $ExpenseTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> carId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseTableCompanion(
                id: id,
                carId: carId,
                date: date,
                category: category,
                cost: cost,
                title: title,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String carId,
                required DateTime date,
                required String category,
                required double cost,
                required String title,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseTableCompanion.insert(
                id: id,
                carId: carId,
                date: date,
                category: category,
                cost: cost,
                title: title,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpenseTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({carId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (carId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.carId,
                                referencedTable: $$ExpenseTableTableReferences
                                    ._carIdTable(db),
                                referencedColumn: $$ExpenseTableTableReferences
                                    ._carIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExpenseTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseTableTable,
      ExpenseTableData,
      $$ExpenseTableTableFilterComposer,
      $$ExpenseTableTableOrderingComposer,
      $$ExpenseTableTableAnnotationComposer,
      $$ExpenseTableTableCreateCompanionBuilder,
      $$ExpenseTableTableUpdateCompanionBuilder,
      (ExpenseTableData, $$ExpenseTableTableReferences),
      ExpenseTableData,
      PrefetchHooks Function({bool carId})
    >;

// ─── TripLogTable ─────────────────────────────────────────────────────────────

class $TripLogTableTable extends TripLogTable
    with TableInfo<$TripLogTableTable, TripLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripLogTableTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true,
  );

  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<String> carId = GeneratedColumn<String>(
    'car_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true,
  );

  static const VerificationMeta _startTimeMeta = const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true,
  );

  static const VerificationMeta _endTimeMeta = const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true,
  );

  static const VerificationMeta _distanceKmMeta = const VerificationMeta('distanceKm');
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true,
  );

  static const VerificationMeta _durationSecondsMeta = const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true,
  );

  static const VerificationMeta _confirmedMeta = const VerificationMeta('confirmed');
  @override
  late final GeneratedColumn<bool> confirmed = GeneratedColumn<bool>(
    'confirmed', aliasedName, false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("confirmed" IN (0, 1))'),
    defaultValue: const Constant(false),
  );

  static const VerificationMeta _autoTripMeta = const VerificationMeta('autoTrip');
  @override
  late final GeneratedColumn<bool> autoTrip = GeneratedColumn<bool>(
    'auto_trip', aliasedName, false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("auto_trip" IN (0, 1))'),
    defaultValue: const Constant(false),
  );

  @override
  List<GeneratedColumn> get $columns =>
      [id, carId, startTime, endTime, distanceKm, durationSeconds, confirmed, autoTrip];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'trip_log_table';

  @override
  VerificationContext validateIntegrity(Insertable<TripLogTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('car_id')) {
      context.handle(_carIdMeta, carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta));
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta, startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta, endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('distance_km')) {
      context.handle(_distanceKmMeta, distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta));
    } else if (isInserting) {
      context.missing(_distanceKmMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(_durationSecondsMeta, durationSeconds.isAcceptableOrUnknown(data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('confirmed')) {
      context.handle(_confirmedMeta, confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta));
    }
    if (data.containsKey('auto_trip')) {
      context.handle(_autoTripMeta, autoTrip.isAcceptableOrUnknown(data['auto_trip']!, _autoTripMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  TripLogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripLogTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      carId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}car_id'])!,
      startTime: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
      distanceKm: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}distance_km'])!,
      durationSeconds: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      confirmed: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}confirmed'])!,
      autoTrip: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}auto_trip'])!,
    );
  }

  @override
  $TripLogTableTable createAlias(String alias) => $TripLogTableTable(attachedDatabase, alias);
}

class TripLogTableData extends DataClass implements Insertable<TripLogTableData> {
  final String id;
  final String carId;
  final DateTime startTime;
  final DateTime endTime;
  final double distanceKm;
  final int durationSeconds;
  final bool confirmed;
  final bool autoTrip;

  const TripLogTableData({
    required this.id,
    required this.carId,
    required this.startTime,
    required this.endTime,
    required this.distanceKm,
    required this.durationSeconds,
    required this.confirmed,
    required this.autoTrip,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['car_id'] = Variable<String>(carId);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['distance_km'] = Variable<double>(distanceKm);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['confirmed'] = Variable<bool>(confirmed);
    map['auto_trip'] = Variable<bool>(autoTrip);
    return map;
  }

  TripLogTableCompanion toCompanion(bool nullToAbsent) => TripLogTableCompanion(
    id: Value(id),
    carId: Value(carId),
    startTime: Value(startTime),
    endTime: Value(endTime),
    distanceKm: Value(distanceKm),
    durationSeconds: Value(durationSeconds),
    confirmed: Value(confirmed),
    autoTrip: Value(autoTrip),
  );

  factory TripLogTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripLogTableData(
      id: serializer.fromJson<String>(json['id']),
      carId: serializer.fromJson<String>(json['carId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      confirmed: serializer.fromJson<bool>(json['confirmed']),
      autoTrip: serializer.fromJson<bool>(json['autoTrip']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {
      'id': serializer.toJson<String>(id),
      'carId': serializer.toJson<String>(carId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'confirmed': serializer.toJson<bool>(confirmed),
      'autoTrip': serializer.toJson<bool>(autoTrip),
    };
  }

  TripLogTableData copyWith({
    String? id,
    String? carId,
    DateTime? startTime,
    DateTime? endTime,
    double? distanceKm,
    int? durationSeconds,
    bool? confirmed,
    bool? autoTrip,
  }) => TripLogTableData(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    distanceKm: distanceKm ?? this.distanceKm,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    confirmed: confirmed ?? this.confirmed,
    autoTrip: autoTrip ?? this.autoTrip,
  );

  @override
  String toString() =>
      'TripLogTableData(id: $id, carId: $carId, startTime: $startTime, endTime: $endTime, '
      'distanceKm: $distanceKm, durationSeconds: $durationSeconds, confirmed: $confirmed, autoTrip: $autoTrip)';

  @override
  int get hashCode => Object.hash(id, carId, startTime, endTime, distanceKm, durationSeconds, confirmed, autoTrip);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripLogTableData &&
          other.id == id &&
          other.carId == carId &&
          other.startTime == startTime &&
          other.endTime == endTime &&
          other.distanceKm == distanceKm &&
          other.durationSeconds == durationSeconds &&
          other.confirmed == confirmed &&
          other.autoTrip == autoTrip);
}

class TripLogTableCompanion extends UpdateCompanion<TripLogTableData> {
  final Value<String> id;
  final Value<String> carId;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<double> distanceKm;
  final Value<int> durationSeconds;
  final Value<bool> confirmed;
  final Value<bool> autoTrip;
  final Value<int> rowid;

  const TripLogTableCompanion({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.autoTrip = const Value.absent(),
    this.rowid = const Value.absent(),
  });

  TripLogTableCompanion.insert({
    required String id,
    required String carId,
    required DateTime startTime,
    required DateTime endTime,
    required double distanceKm,
    required int durationSeconds,
    this.confirmed = const Value.absent(),
    this.autoTrip = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        carId = Value(carId),
        startTime = Value(startTime),
        endTime = Value(endTime),
        distanceKm = Value(distanceKm),
        durationSeconds = Value(durationSeconds);

  TripLogTableCompanion copyWith({
    Value<String>? id,
    Value<String>? carId,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<double>? distanceKm,
    Value<int>? durationSeconds,
    Value<bool>? confirmed,
    Value<bool>? autoTrip,
    Value<int>? rowid,
  }) => TripLogTableCompanion(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    distanceKm: distanceKm ?? this.distanceKm,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    confirmed: confirmed ?? this.confirmed,
    autoTrip: autoTrip ?? this.autoTrip,
    rowid: rowid ?? this.rowid,
  );

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (carId.present) map['car_id'] = Variable<String>(carId.value);
    if (startTime.present) map['start_time'] = Variable<DateTime>(startTime.value);
    if (endTime.present) map['end_time'] = Variable<DateTime>(endTime.value);
    if (distanceKm.present) map['distance_km'] = Variable<double>(distanceKm.value);
    if (durationSeconds.present) map['duration_seconds'] = Variable<int>(durationSeconds.value);
    if (confirmed.present) map['confirmed'] = Variable<bool>(confirmed.value);
    if (autoTrip.present) map['auto_trip'] = Variable<bool>(autoTrip.value);
    if (rowid.present) map['rowid'] = Variable<int>(rowid.value);
    return map;
  }

  @override
  String toString() =>
      'TripLogTableCompanion(id: $id, carId: $carId, startTime: $startTime, endTime: $endTime, '
      'distanceKm: $distanceKm, durationSeconds: $durationSeconds, confirmed: $confirmed, autoTrip: $autoTrip)';
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CarTableTableTableManager get carTable =>
      $$CarTableTableTableManager(_db, _db.carTable);
  $$RefuelingTableTableTableManager get refuelingTable =>
      $$RefuelingTableTableTableManager(_db, _db.refuelingTable);
  $$ExpenseTableTableTableManager get expenseTable =>
      $$ExpenseTableTableTableManager(_db, _db.expenseTable);
}
