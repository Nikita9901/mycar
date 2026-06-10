import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/car_home_cubit.dart';
import '../bloc/car_home_state.dart';

class OilChangeSheet extends StatelessWidget {
  const OilChangeSheet._();

  static void show(BuildContext context) {
    final cubit = context.read<CarHomeCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const OilChangeSheet._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return BlocBuilder<CarHomeCubit, CarHomeState>(
      builder: (context, state) {
        if (state is! CarHomeLoaded) return const SizedBox.shrink();

        final car = state.car;
        final cubit = context.read<CarHomeCubit>();
        final intervalKm = cubit.oilChangeIntervalKm;
        final lastOdo = car.lastOilChangeOdometer;
        final driven = lastOdo != null
            ? car.currentOdometer - lastOdo
            : null;
        final kmLeft = intervalKm - (driven ?? intervalKm ~/ 2);
        final progress = state.oilChangeProgress;

        return Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border2,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Заголовок
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _progressColor(progress).withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.oil_barrel_rounded,
                        size: 20, color: _progressColor(progress)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Замена масла',
                          style: GoogleFonts.manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text1,
                            letterSpacing: -0.4,
                          )),
                      Text('${car.displayName}',
                          style: GoogleFonts.manrope(
                              fontSize: 13, color: AppColors.text3)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Статистика
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bg2,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border1, width: 0.5),
                ),
                child: Column(
                  children: [
                    _StatRow(
                      label: 'Последняя замена',
                      value: lastOdo != null
                          ? _fmtOdo(lastOdo)
                          : 'не записана',
                    ),
                    const SizedBox(height: 10),
                    _StatRow(
                      label: 'Текущий пробег',
                      value: _fmtOdo(car.currentOdometer),
                    ),
                    const SizedBox(height: 10),
                    _StatRow(
                      label: 'Пройдено с замены',
                      value: driven != null ? _fmtOdo(driven) : '—',
                    ),
                    const SizedBox(height: 10),
                    _StatRow(
                      label: 'Интервал замены',
                      value: _fmtOdo(intervalKm),
                    ),
                    const SizedBox(height: 10),
                    _StatRow(
                      label: kmLeft > 0 ? 'Осталось до замены' : 'Просрочено на',
                      value: _fmtOdo(kmLeft.abs()),
                      valueColor: _progressColor(progress),
                    ),
                    const SizedBox(height: 14),
                    // Прогресс-бар
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: AppColors.bg3,
                        valueColor: AlwaysStoppedAnimation(_progressColor(progress)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Кнопка записи замены
              GestureDetector(
                onTap: () async {
                  await cubit.recordOilChange();
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.green.withAlpha(70),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Записать замену масла сейчас',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Пояснение
              Center(
                child: Text(
                  'Пробег ${_fmtOdo(car.currentOdometer)} будет записан как точка отсчёта',
                  style: GoogleFonts.manrope(
                      fontSize: 12, color: AppColors.text3),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Color _progressColor(double p) {
    if (p < 0.7) return AppColors.green;
    if (p < 0.9) return AppColors.yellow;
    return AppColors.red;
  }

  static String _fmtOdo(int km) {
    return '${NumberFormat('#,##0', 'ru_RU').format(km).replaceAll(',', '\u202F')} км';
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppColors.text3,
                  fontWeight: FontWeight.w500)),
        ),
        Text(value,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.text1,
            )),
      ],
    );
  }
}
