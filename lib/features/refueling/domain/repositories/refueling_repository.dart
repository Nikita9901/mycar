// Абстрактный репозиторий для сущности Refueling.

import '../entities/refueling.dart';

/// Контракт репозитория заправок.
abstract class RefuelingRepository {
  /// Получить все заправки для указанного автомобиля.
  /// Список отсортирован по дате (новые сверху).
  Future<List<Refueling>> getRefuelingsForCar(String carId);

  /// Получить заправки за указанный период.
  Future<List<Refueling>> getRefuelingsForPeriod({
    required String carId,
    required DateTime from,
    required DateTime to,
  });

  /// Добавить запись о заправке.
  Future<void> addRefueling(Refueling refueling);

  /// Обновить запись о заправке.
  Future<void> updateRefueling(Refueling refueling);

  /// Удалить запись о заправке.
  Future<void> deleteRefueling(String refuelingId);

  /// Поток заправок для автомобиля — реагирует на изменения в БД.
  Stream<List<Refueling>> watchRefuelingsForCar(String carId);

  /// Получить последнюю запись заправки для автомобиля.
  /// Используется для отображения текущего пробега и расчёта расхода.
  Future<Refueling?> getLastRefueling(String carId);
}
