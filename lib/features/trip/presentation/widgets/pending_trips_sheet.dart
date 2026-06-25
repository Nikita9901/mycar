import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/sheet_widgets.dart';
import '../../../car/domain/entities/car.dart';
import '../../../car/presentation/bloc/car_home_cubit.dart';
import '../../../car/presentation/bloc/car_home_state.dart';
import '../../domain/entities/trip_log_entry.dart';
import '../../domain/usecases/confirm_trip_log.dart';
import '../../domain/usecases/delete_trip_log.dart';

class PendingTripsSheet extends StatefulWidget {
  const PendingTripsSheet._({required this.trips, required this.car});
  final List<TripLogEntry> trips;
  final Car car;

  static Future<void> show(
    BuildContext context,
    List<TripLogEntry> trips,
    Car car,
  ) {
    final carCubit = context.read<CarHomeCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => BlocProvider.value(
        value: carCubit,
        child: PendingTripsSheet._(trips: trips, car: car),
      ),
    );
  }

  @override
  State<PendingTripsSheet> createState() => _PendingTripsSheetState();
}

class _PendingTripsSheetState extends State<PendingTripsSheet> {
  late final List<TripLogEntry> _trips = List.of(widget.trips);
  bool _loading = false;

  int get _totalDistanceKm =>
      _trips.fold(0, (sum, t) => sum + t.distanceKmRounded);

  @override
  Widget build(BuildContext context) {
    final bot = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bot + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetDragHandle(),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blue.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_car_rounded,
                    color: AppColors.blue, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Неподтверждённые поездки',
                      style: GoogleFonts.manrope(
                        fontSize: 18, fontWeight: FontWeight.w800,
                        color: AppColors.text1, letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      '${_trips.length} ${_pluralPoezdka(_trips.length)} · '
                      'всего $_totalDistanceKm км',
                      style: GoogleFonts.manrope(
                          fontSize: 12, color: AppColors.text3),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Trip list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _trips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _TripCard(
                trip: _trips[i],
                onDelete: () => _deleteOne(_trips[i]),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Кнопка "Сохранить все в одометр"
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _loading ? null : _confirmAll,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 52,
                decoration: BoxDecoration(
                  color: _loading
                      ? AppColors.green.withAlpha(120)
                      : AppColors.green,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: _loading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'Сохранить все в одометр (+$_totalDistanceKm км)',
                        style: GoogleFonts.manrope(
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Кнопка "Отклонить все"
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _loading ? null : _deleteAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.text3,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Отклонить все',
                style: GoogleFonts.manrope(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAll() async {
    setState(() => _loading = true);
    try {
      final carCubit = context.read<CarHomeCubit>();
      final carState = carCubit.state;

      // Подтверждаем все поездки в БД
      for (final trip in _trips) {
        await sl<ConfirmTripLog>()(trip.id);
      }

      // Обновляем одометр суммарно
      if (carState is CarHomeLoaded) {
        final newOdo = (carState as CarHomeLoaded).car.currentOdometer + _totalDistanceKm;
        await carCubit.updateOdometer(newOdo);
      }
    } finally {
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _deleteAll() async {
    for (final trip in _trips) {
      await sl<DeleteTripLog>()(trip.id);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _deleteOne(TripLogEntry trip) async {
    await sl<DeleteTripLog>()(trip.id);
    setState(() => _trips.remove(trip));
    if (_trips.isEmpty && mounted) Navigator.of(context).pop();
  }

  String _pluralPoezdka(int n) {
    if (n % 10 == 1 && n % 100 != 11) return 'поездка';
    if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
      return 'поездки';
    }
    return 'поездок';
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip, required this.onDelete});
  final TripLogEntry trip;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('d MMM, HH:mm', 'ru');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Row(
        children: [
          // Иконка авто/BT
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: (trip.autoTrip ? AppColors.blue : AppColors.green)
                  .withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              trip.autoTrip
                  ? Icons.bluetooth_connected_rounded
                  : Icons.navigation_rounded,
              size: 18,
              color: trip.autoTrip ? AppColors.blue : AppColors.green,
            ),
          ),
          const SizedBox(width: 12),

          // Инфо
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFmt.format(trip.startTime),
                  style: GoogleFonts.manrope(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppColors.text1,
                  ),
                ),
                Text(
                  '${trip.formattedDistance} · ${trip.formattedDuration}',
                  style: GoogleFonts.manrope(
                      fontSize: 11, color: AppColors.text3),
                ),
              ],
            ),
          ),

          // Кнопка удалить
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: AppColors.red.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close_rounded,
                  size: 16, color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }
}
