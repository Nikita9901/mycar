import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/car.dart';

/// Карточка текущего уровня топлива.
/// Показывается только если у авто задан объём бака.
class FuelLevelWidget extends StatelessWidget {
  const FuelLevelWidget({super.key, required this.car});
  final Car car;

  @override
  Widget build(BuildContext context) {
    final capacity = car.fuelTankCapacity;
    if (capacity == null) return const SizedBox.shrink();

    final level = car.currentFuelLevel;
    final ratio =
        level != null ? (level / capacity).clamp(0.0, 1.0) : null;

    final color = ratio == null
        ? AppColors.text3
        : ratio < 0.2
            ? AppColors.red
            : ratio < 0.4
                ? AppColors.yellow
                : AppColors.green;

    // Запас хода
    final avg = car.avgFuelConsumption;
    final rangeKm =
        (level != null && avg != null && avg > 0)
            ? (level / avg * 100).round()
            : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.bg1,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: ratio != null && ratio < 0.2
                ? AppColors.red.withAlpha(70)
                : AppColors.border1,
            width: ratio != null && ratio < 0.2 ? 1 : 0.5,
          ),
          boxShadow: ratio != null && ratio < 0.2
              ? [
                  BoxShadow(
                    color: AppColors.red.withAlpha(30),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.local_gas_station_rounded,
                    size: 17,
                    color: color,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Топливо в баке',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text2,
                  ),
                ),
                const Spacer(),
                Text(
                  '$capacity л бак',
                  style: GoogleFonts.manrope(
                      fontSize: 11, color: AppColors.text3),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Значение + запас хода
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  level != null ? '$level л' : '—',
                  style: GoogleFonts.manrope(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: -0.8,
                    height: 1.0,
                  ),
                ),
                if (ratio != null) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      '${(ratio * 100).round()}%',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: color.withAlpha(180),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (rangeKm != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '≈ $rangeKm км',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text1,
                        ),
                      ),
                      Text(
                        'запас хода',
                        style: GoogleFonts.manrope(
                            fontSize: 11, color: AppColors.text3),
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // Полоса уровня топлива
            _FuelBar(ratio: ratio ?? 0, color: color, capacity: capacity),
          ],
        ),
      ),
    );
  }
}

class _FuelBar extends StatelessWidget {
  const _FuelBar({
    required this.ratio,
    required this.color,
    required this.capacity,
  });
  final double ratio;
  final Color color;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    // Делим бак на 4 сегмента с пробелами
    const segments = 4;
    return LayoutBuilder(builder: (_, box) {
      final totalW = box.maxWidth;
      const gap = 4.0;
      final segW = (totalW - gap * (segments - 1)) / segments;
      final filled = ratio * segments;

      return Row(
        children: List.generate(segments * 2 - 1, (i) {
          if (i.isOdd) return const SizedBox(width: gap);
          final idx = i ~/ 2;
          final segFill = (filled - idx).clamp(0.0, 1.0);

          return SizedBox(
            width: segW,
            height: 8,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.bg3,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: segFill,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [color.withAlpha(160), color],
                      ),
                      boxShadow: segFill > 0
                          ? [
                              BoxShadow(
                                color: color.withAlpha(80),
                                blurRadius: 6,
                              )
                            ]
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
