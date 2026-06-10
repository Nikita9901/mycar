import 'package:equatable/equatable.dart';

import '../../domain/entities/analytics_data.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

final class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

final class AnalyticsEmpty extends AnalyticsState {
  const AnalyticsEmpty();
}

final class AnalyticsLoaded extends AnalyticsState {
  const AnalyticsLoaded({
    required this.data,
    required this.selectedPeriod,
    required this.isPremiumUser,
  });

  final AnalyticsData data;
  final AnalyticsPeriod selectedPeriod;

  /// false — бесплатный режим (период зафиксирован на «Месяц», cost/km скрыт).
  final bool isPremiumUser;

  @override
  List<Object?> get props => [data, selectedPeriod, isPremiumUser];
}
