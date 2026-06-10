import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/sheet_widgets.dart';
import '../../../car/presentation/bloc/car_home_cubit.dart';
import '../bloc/trip_tracking_cubit.dart';
import '../bloc/trip_tracking_state.dart';

class TripActiveSheet extends StatelessWidget {
  const TripActiveSheet._();

  static void show(BuildContext context) {
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
        child: const TripActiveSheet._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripTrackingCubit, TripTrackingState>(
      listenWhen: (_, curr) => curr is TripFinished,
      listener: (context, state) {
        if (state is TripFinished) Navigator.of(context).pop();
      },
      builder: (context, state) {
        if (state is! TripInProgress) {
          return const SizedBox(height: 120);
        }
        return _SheetBody(state: state);
      },
    );
  }
}

class _SheetBody extends StatelessWidget {
  const _SheetBody({required this.state});
  final TripInProgress state;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetDragHandle(),
          const SizedBox(height: 20),

          // ── Заголовок ────────────────────────────────────────────────────
          Row(
            children: [
              _PulseDot(),
              const SizedBox(width: 10),
              Text(
                'Поездка идёт',
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text1,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Главная метрика — расстояние ─────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.bg2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border1, width: 0.5),
            ),
            child: Column(
              children: [
                Text(
                  state.formattedDistance,
                  style: GoogleFonts.manrope(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: AppColors.green,
                    letterSpacing: -2,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'пройдено',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.text3,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Вторичные метрики ────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.timer_outlined,
                  label: 'Время',
                  value: state.formattedDuration,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  icon: Icons.speed_rounded,
                  label: 'Скорость',
                  value: '${state.speedKmh.round()} км/ч',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Кнопки ──────────────────────────────────────────────────────
          _StopButton(),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.text3,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Свернуть',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.bg3,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: AppColors.text2),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text1,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StopButton extends StatefulWidget {
  @override
  State<_StopButton> createState() => _StopButtonState();
}

class _StopButtonState extends State<_StopButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading ? null : _stop,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _loading ? AppColors.bg3 : AppColors.red,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _loading
              ? null
              : [
                  BoxShadow(
                    color: AppColors.red.withAlpha(60),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.text2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stop_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Завершить поездку',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _stop() async {
    setState(() => _loading = true);
    await context.read<TripTrackingCubit>().stopTrip();
  }
}

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.green.withAlpha((_anim.value * 255).round()),
        ),
      ),
    );
  }
}
