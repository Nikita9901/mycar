import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/car.dart';

class CarHeaderWidget extends StatelessWidget {
  const CarHeaderWidget({
    super.key,
    required this.car,
    required this.onOdometerUpdated,
  });

  final Car car;
  final ValueChanged<int> onOdometerUpdated;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg1,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border1, width: 0.5),
          boxShadow: [
            // Тёмная объёмная тень
            BoxShadow(
              color: Colors.black.withAlpha(120),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
            // Лёгкое голубое подсвечивание снизу
            BoxShadow(
              color: AppColors.blue.withAlpha(18),
              blurRadius: 40,
              offset: const Offset(0, 24),
              spreadRadius: -8,
            ),
          ],
        ),
        child: Column(
          children: [
            _HeroBanner(car: car),
            _OdometerSection(car: car, onOdometerUpdated: onOdometerUpdated),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Верхний баннер
// ─────────────────────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.car});
  final Car car;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        constraints: const BoxConstraints(minHeight: 160),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 0.45, 1],
            colors: [
              Color(0xFF0F2040), // насыщенный тёмно-синий
              Color(0xFF091526), // переходный
              Color(0xFF060D18), // почти чёрный
            ],
          ),
        ),
        child: Stack(
          children: [
            // Декоративное кольцо — большое, правый угол
            Positioned(
              right: -60,
              top: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.blue.withAlpha(22),
                    width: 1,
                  ),
                ),
              ),
            ),
            // Декоративное кольцо — малое, правый угол
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.blue.withAlpha(35),
                    width: 1,
                  ),
                ),
              ),
            ),
            // Световой блик — тонкая диагональная полоска
            Positioned(
              left: -40,
              top: 0,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  width: 2,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withAlpha(0),
                        Colors.white.withAlpha(12),
                        Colors.white.withAlpha(0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Основной контент
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Текстовый блок слева
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Марка — маленький капс с большим треккингом
                            Text(
                              car.brand.toUpperCase(),
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3,
                                color: AppColors.blue.withAlpha(200),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Модель — главный hero-текст
                            Text(
                              car.model,
                              style: GoogleFonts.manrope(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                                color: AppColors.text1,
                                height: 1.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Иконка авто — стилизованный контейнер
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.blue.withAlpha(40),
                              AppColors.blue.withAlpha(15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.blue.withAlpha(70),
                            width: 0.8,
                          ),
                        ),
                        child: const Icon(
                          Icons.directions_car_rounded,
                          size: 32,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Нижний ряд чипов — Wrap чтобы не было overflow
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _InfoChip(
                        icon: Icons.local_gas_station_rounded,
                        label: car.fuelType.label,
                      ),
                      if (car.licensePlate != null)
                        _InfoChip(
                          icon: Icons.credit_card_rounded,
                          label: car.licensePlate!.toUpperCase(),
                          letterSpacing: 1.5,
                        ),
                      if (car.vin != null)
                        _InfoChip(
                          icon: Icons.numbers_rounded,
                          label: 'VIN',
                        ),
                      if (car.avgFuelConsumption != null)
                        _InfoChip(
                          icon: Icons.speed_rounded,
                          label: '${car.avgFuelConsumption!.toStringAsFixed(1)} л/100км',
                        ),
                      if (car.fuelTankCapacity != null)
                        _InfoChip(
                          icon: Icons.water_drop_rounded,
                          label: '${car.fuelTankCapacity} л',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.letterSpacing = 0.2,
  });

  final IconData icon;
  final String label;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withAlpha(20),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.text2),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.text2,
              letterSpacing: letterSpacing,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Секция одометра
// ─────────────────────────────────────────────────────────────────────────────

class _OdometerSection extends StatelessWidget {
  const _OdometerSection({
    required this.car,
    required this.onOdometerUpdated,
  });

  final Car car;
  final ValueChanged<int> onOdometerUpdated;

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormat('#,###', 'ru_RU')
        .format(car.currentOdometer)
        .replaceAll(',', '\u202F'); // тонкий неразрывный пробел

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Иконка
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.bg3,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border1, width: 0.5),
            ),
            child: const Icon(
              Icons.speed_rounded,
              size: 20,
              color: AppColors.text2,
            ),
          ),
          const SizedBox(width: 14),

          // Значение
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ПРОБЕГ',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text3,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      formatted,
                      style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text1,
                        letterSpacing: -1.2,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'км',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Кнопка редактирования
          GestureDetector(
            onTap: () => _showOdometerDialog(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.blue.withAlpha(22),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: AppColors.blue.withAlpha(55),
                  width: 0.8,
                ),
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 18,
                color: AppColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOdometerDialog(BuildContext context) {
    final ctrl = TextEditingController(text: car.currentOdometer.toString());
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg2,
        title: Text(
          'Обновить пробег',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.text1,
          ),
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.manrope(color: AppColors.text1),
          decoration: InputDecoration(
            labelText: 'Показания одометра',
            suffixText: 'км',
            labelStyle: GoogleFonts.manrope(color: AppColors.text3),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Отмена',
                style: GoogleFonts.manrope(color: AppColors.text3)),
          ),
          FilledButton(
            onPressed: () {
              final v = int.tryParse(ctrl.text.trim());
              if (v == null) return;
              if (v < car.currentOdometer) {
                Navigator.of(ctx).pop();
                _confirmDecrease(context, v);
              } else {
                onOdometerUpdated(v);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _confirmDecrease(BuildContext context, int newValue) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg2,
        title: Text(
          'Уменьшить пробег?',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700, color: AppColors.text1),
        ),
        content: Text(
          'Вы хотите изменить пробег с ${car.currentOdometer} км на $newValue км.\n\nЭто может означать исправление ошибки ввода. Продолжить?',
          style: GoogleFonts.manrope(
              fontSize: 13, color: AppColors.text2, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Отмена',
                style: GoogleFonts.manrope(color: AppColors.text3)),
          ),
          TextButton(
            onPressed: () {
              onOdometerUpdated(newValue);
              Navigator.of(ctx).pop();
            },
            child: Text('Да, изменить',
                style: GoogleFonts.manrope(
                    color: AppColors.yellow, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
