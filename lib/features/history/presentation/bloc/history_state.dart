import 'package:equatable/equatable.dart';

import '../../domain/entities/history_item.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

final class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

final class HistoryEmpty extends HistoryState {
  const HistoryEmpty();
}

final class HistoryLoaded extends HistoryState {
  const HistoryLoaded({required this.items});

  /// Все записи, отсортированные по дате (новые сверху).
  final List<HistoryItem> items;

  @override
  List<Object?> get props => [items];
}
