import 'package:equatable/equatable.dart';

import '../../domain/entities/car.dart';
import '../../../refueling/domain/entities/refueling.dart';

sealed class CarHomeState extends Equatable {
  const CarHomeState();

  @override
  List<Object?> get props => [];
}

final class CarHomeLoading extends CarHomeState {
  const CarHomeLoading();
}

final class CarHomeLoaded extends CarHomeState {
  const CarHomeLoaded({
    required this.car,
    required this.lastRefueling,
    required this.oilChangeProgress,
    required this.oilChangeKmLeft,
    required this.fuelConsumptionPer100km,
  });

  final Car car;
  final Refueling? lastRefueling;
  final double oilChangeProgress;
  final int oilChangeKmLeft;
  final double? fuelConsumptionPer100km;

  /// Делегируем в car — страховка хранится прямо в сущности.
  int? get insuranceDaysLeft => car.insuranceDaysLeft;

  @override
  List<Object?> get props => [
        car, lastRefueling, oilChangeProgress,
        oilChangeKmLeft, fuelConsumptionPer100km,
      ];
}

final class CarHomeError extends CarHomeState {
  const CarHomeError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class CarHomeEmpty extends CarHomeState {
  const CarHomeEmpty();
}
