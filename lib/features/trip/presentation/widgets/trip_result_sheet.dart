import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/sheet_widgets.dart';
import '../../../car/presentation/bloc/car_home_cubit.dart';
import '../../../car/presentation/bloc/car_home_state.dart';
import '../bloc/trip_tracking_cubit.dart';
import '../bloc/trip_tracking_state.dart';

class TripResultSheet extends StatelessWidget {
  const TripResultSheet._({required this.result});
  final TripFinished result;

  static void show(BuildContext context, TripFinished result) {
    final tripCubit = context.read<TripTrackingCubit>();
    final carCubit = context.read<CarHomeCubit>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: tripCubit),
          BlocProvider.value(value: carCubit),
        ],
        child: TripResultSheet._(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carState = context.read<CarHomeCubit>().state;
    final currentOdometer =
        carState is CarHomeLoaded ? carState.car.currentOdometer : null;
    final newOdometer = currentOdometer != null
        ? currentOdometer + result.distanceKmRounded
        : null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetDragHandle(),
          const SizedBox(height: 20),

          // Иконка
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.green.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.flag_rounded,
              color: AppColors.green,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Поездка завершена',
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.text1,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Хотите обновить одометр?',
            style: GoogleFonts.manrope(
                fontSize: 14, color: AppColors.text3),
          ),

          const SizedBox(height: 24),

          // Карточка статистики
          Container(
            decoration: BoxDecoration(
              color: AppColors.bg2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border1, width: 0.5),
            ),
            child: Column(
              children: [
                _StatRow(
                  icon: Icons.route_rounded,
                  label: 'Расстояние',
                  value: result.formattedDistance,
                  valueColor: AppColors.blue,
                ),
                Divider(height: 1, color: AppColors.border1),
                _StatRow(
                  icon: Icons.timer_outlined,
                  label: 'Время в пути',
                  value: result.formattedDuration,
                ),
                if (currentOdometer != null) ...[
                  Divider(height: 1, color: AppColors.border1),
                  _StatRow(
                    icon: Icons.speed_rounded,
                    label: 'Новый одометр',
                    value: '${_fmtOdo(newOdometer!)} км',
                    valueColor: AppColors.green,
                    subtitle:
                        'сейчас ${_fmtOdo(currentOdometer)} км  +${result.distanceKmRounded} км',
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Сохранить
          if (currentOdometer != null)
            SizedBox(
              width: double.infinity,
              child: _SaveButton(
                distanceKm: result.distanceKmRounded,
              ),
            ),

          const SizedBox(height: 10),

          // Не сохранять
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                context.read<TripTrackingCubit>().dismiss();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.text3,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Не сохранять',
                style: GoogleFonts.manrope(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtOdo(int km) {
    // простое форматирование с пробелом как разделителем тысяч
    final s = km.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('\u00A0');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.text3),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                  fontSize: 14, color: AppColors.text2),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.text1,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: GoogleFonts.manrope(
                      fontSize: 11, color: AppColors.text3),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  const _SaveButton({required this.distanceKm});
  final int distanceKm;

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading ? null : _save,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 52,
        decoration: BoxDecoration(
          color: _loading ? AppColors.green.withAlpha(120) : AppColors.green,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(
                'Сохранить в одометр',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    final carCubit = context.read<CarHomeCubit>();
    final carState = carCubit.state;
    if (carState is CarHomeLoaded) {
      final newOdo =
          carState.car.currentOdometer + widget.distanceKm;
      await carCubit.updateOdometer(newOdo);
    }
    if (mounted) {
      context.read<TripTrackingCubit>().dismiss();
      Navigator.of(context).pop();
    }
  }
}
