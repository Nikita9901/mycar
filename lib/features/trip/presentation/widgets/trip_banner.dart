import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/trip_tracking_cubit.dart';
import '../bloc/trip_tracking_state.dart';
import 'trip_result_sheet.dart';

/// Баннер активной поездки — появляется над навбаром когда идёт запись.
class TripBanner extends StatelessWidget {
  const TripBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripTrackingCubit, TripTrackingState>(
      listenWhen: (prev, curr) => curr is TripFinished,
      listener: (context, state) {
        if (state is TripFinished) {
          TripResultSheet.show(context, state);
        }
      },
      buildWhen: (prev, curr) =>
          (prev is TripInProgress) != (curr is TripInProgress),
      builder: (context, state) {
        if (state is! TripInProgress) return const SizedBox.shrink();
        return const _ActiveBanner();
      },
    );
  }
}

class _ActiveBanner extends StatelessWidget {
  const _ActiveBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripTrackingCubit, TripTrackingState>(
      buildWhen: (_, curr) => curr is TripInProgress,
      builder: (context, state) {
        if (state is! TripInProgress) return const SizedBox.shrink();
        final cubit = context.read<TripTrackingCubit>();

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.green.withAlpha(230),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.green.withAlpha(80),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),

                // Пульсирующая точка
                _PulseDot(),

                const SizedBox(width: 10),

                // Дистанция
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.formattedDistance,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        '${state.formattedDuration}  ·  ${state.speedKmh.round()} км/ч',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ),

                // Кнопка остановить
                GestureDetector(
                  onTap: () => cubit.stopTrip(),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Стоп',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Пульсирующая зелёная точка «в эфире».
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
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
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
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withAlpha((_anim.value * 255).round()),
        ),
      ),
    );
  }
}
