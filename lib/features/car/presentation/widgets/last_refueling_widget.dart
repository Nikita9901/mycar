import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/currency_provider.dart';
import '../../../refueling/domain/entities/refueling.dart';

class LastRefuelingWidget extends StatelessWidget {
  const LastRefuelingWidget({
    super.key,
    required this.lastRefueling,
    required this.fuelConsumptionPer100km,
  });

  final Refueling? lastRefueling;
  final double? fuelConsumptionPer100km;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: lastRefueling == null
          ? _EmptyState()
          : _FilledCard(
              refueling: lastRefueling!,
              consumption: fuelConsumptionPer100km,
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Пустой стейт
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Column(
        children: [
          // Иконка
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.bg3,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border2, width: 0.5),
            ),
            child: const Icon(
              Icons.local_gas_station_rounded,
              size: 26,
              color: AppColors.text3,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Заправок пока нет',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.text2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Нажмите «+» чтобы добавить\nпервую запись',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppColors.text3,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Заполненная карточка — стиль банковской выписки
// ─────────────────────────────────────────────────────────────────────────────

class _FilledCard extends StatelessWidget {
  const _FilledCard({required this.refueling, required this.consumption});

  final Refueling refueling;
  final double? consumption;

  @override
  Widget build(BuildContext context) {
    final currency = CurrencyProvider.of(context);
    final cost = NumberFormat.currency(
      locale: 'ru_RU', symbol: currency, decimalDigits: 0,
    ).format(refueling.totalCost);
    final liters = '${refueling.liters.toStringAsFixed(2)}\u00a0л';
    final odo = NumberFormat('#,###', 'ru_RU')
        .format(refueling.odometer)
        .replaceAll(',', '\u202F');
    final pricePerL =
        refueling.liters > 0 ? refueling.totalCost / refueling.liters : 0.0;
    final date = DateFormat('d MMM, HH:mm', 'ru_RU').format(refueling.date);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Column(
        children: [
          // ── Шапка ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.blue.withAlpha(22),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.blue.withAlpha(50),
                      width: 0.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.local_gas_station_rounded,
                    size: 19,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        refueling.stationName ?? 'Заправка',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        date,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Бейдж полного бака
                if (refueling.isFullTank)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.green.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.green.withAlpha(55),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      'Full',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Главная сумма ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cost,
                  style: GoogleFonts.manrope(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text1,
                    letterSpacing: -1.2,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '≈ ${pricePerL.toStringAsFixed(1)} $currency/л',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: AppColors.text3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Пунктирный разделитель в стиле чека ───────────────────────
          _DashedDivider(),

          const SizedBox(height: 16),

          // ── Строки деталей ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _DetailRow(
                  label: 'Объём',
                  value: liters,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  label: 'Одометр',
                  value: '$odo\u00a0км',
                ),
                if (consumption != null) ...[
                  const SizedBox(height: 10),
                  _DetailRow(
                    label: 'Средний расход',
                    value: '${consumption!.toStringAsFixed(1)}\u00a0л/100\u00a0км',
                    valueColor: AppColors.blue,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Строка «Ключ ........... Значение» — в стиле чека.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.text3,
          ),
        ),
        // Точки-заполнитель
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: LayoutBuilder(builder: (_, c) {
              const dotSpacing = 6.0;
              final count = (c.maxWidth / dotSpacing).floor();
              return Row(
                children: List.generate(
                  count,
                  (_) => Expanded(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      color: AppColors.border1,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

/// Пунктирная горизонтальная линия — как перфорация на чеке.
class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(
        painter: _DashPainter(),
        size: const Size(double.infinity, 1),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border2
      ..strokeWidth = 1;

    const dashW = 6.0;
    const gapW = 5.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashW, 0), paint);
      x += dashW + gapW;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
