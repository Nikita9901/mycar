import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/sheet_widgets.dart';
import '../../domain/entities/car.dart';
import '../../domain/usecases/add_car.dart';
import '../bloc/car_home_cubit.dart';

class AddCarSheet extends StatefulWidget {
  const AddCarSheet._();

  /// Показывает шторку добавления авто.
  /// Передаём cubit явно, т.к. BottomSheet — новый route.
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
        child: const AddCarSheet._(),
      ),
    );
  }

  @override
  State<AddCarSheet> createState() => _AddCarSheetState();
}

class _AddCarSheetState extends State<AddCarSheet> {
  final _formKey = GlobalKey<FormState>();
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _odoCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _consumptionCtrl = TextEditingController();
  final _tankCtrl = TextEditingController();
  final _fuelLevelCtrl = TextEditingController();

  FuelType _fuelType = FuelType.gasoline;
  bool _loading = false;
  bool _showBoardComputer = false;

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _odoCtrl.dispose();
    _plateCtrl.dispose();
    _consumptionCtrl.dispose();
    _tankCtrl.dispose();
    _fuelLevelCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final consumptionText = _consumptionCtrl.text.trim().replaceAll(',', '.');
      final tankText = _tankCtrl.text.trim();
      final fuelLevelText = _fuelLevelCtrl.text.trim();
      await context.read<CarHomeCubit>().addCar(
            AddCarParams(
              brand: _brandCtrl.text.trim(),
              model: _modelCtrl.text.trim(),
              currentOdometer: int.parse(_odoCtrl.text.trim()),
              fuelType: _fuelType,
              licensePlate:
                  _plateCtrl.text.trim().isEmpty ? null : _plateCtrl.text.trim(),
              avgFuelConsumption: consumptionText.isEmpty
                  ? null
                  : double.tryParse(consumptionText),
              fuelTankCapacity:
                  tankText.isEmpty ? null : int.tryParse(tankText),
              currentFuelLevel:
                  fuelLevelText.isEmpty ? null : int.tryParse(fuelLevelText),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetDragHandle(),
            const SizedBox(height: 20),

            Text(
              'Новый автомобиль',
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.text1,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              'Введите данные вашего автомобиля',
              style: GoogleFonts.manrope(fontSize: 13, color: AppColors.text3),
            ),

            const SizedBox(height: 24),

            // Марка + Модель рядом
            Row(
              children: [
                Expanded(
                  child: SheetTextField(
                    controller: _brandCtrl,
                    label: 'Марка',
                    hint: 'Toyota',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Введите марку' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SheetTextField(
                    controller: _modelCtrl,
                    label: 'Модель',
                    hint: 'Camry',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Введите модель' : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Одометр
            SheetTextField(
              controller: _odoCtrl,
              label: 'Текущий пробег',
              hint: '75 000',
              suffix: 'км',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Введите пробег';
                if (int.tryParse(v.trim()) == null) return 'Только цифры';
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Госномер (необязательно)
            SheetTextField(
              controller: _plateCtrl,
              label: 'Госномер (необязательно)',
              hint: 'А777АА 77',
              textCapitalization: TextCapitalization.characters,
            ),

            const SizedBox(height: 14),

            // Тип топлива
            Text(
              'ТИП ТОПЛИВА',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.text3,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FuelType.values.map((ft) {
                final selected = ft == _fuelType;
                return GestureDetector(
                  onTap: () => setState(() => _fuelType = ft),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          selected ? AppColors.blue.withAlpha(30) : AppColors.bg3,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? AppColors.blue.withAlpha(130)
                            : AppColors.border1,
                        width: selected ? 1 : 0.5,
                      ),
                    ),
                    child: Text(
                      ft.label,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? AppColors.blue : AppColors.text2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Секция «Бортовой компьютер»
            GestureDetector(
              onTap: () =>
                  setState(() => _showBoardComputer = !_showBoardComputer),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.bg3,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border1, width: 0.5),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.speed_rounded,
                      size: 18,
                      color: AppColors.blue,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Данные бортового компьютера',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    Text(
                      'необязательно',
                      style: GoogleFonts.manrope(
                          fontSize: 11, color: AppColors.text3),
                    ),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: _showBoardComputer ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.text3, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SheetTextField(
                            controller: _consumptionCtrl,
                            label: 'Средний расход',
                            hint: '8.5',
                            suffix: 'л/100км',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return null;
                              final d =
                                  double.tryParse(v.trim().replaceAll(',', '.'));
                              if (d == null || d <= 0 || d > 50) {
                                return 'От 0.1 до 50';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SheetTextField(
                            controller: _tankCtrl,
                            label: 'Объём бака',
                            hint: '55',
                            suffix: 'л',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return null;
                              final n = int.tryParse(v.trim());
                              if (n == null || n < 10 || n > 300) {
                                return 'От 10 до 300';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FuelLevelField(
                      controller: _fuelLevelCtrl,
                      tankCtrl: _tankCtrl,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 14, color: AppColors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Используется для расчёта запаса хода и уточнения аналитики',
                              style: GoogleFonts.manrope(
                                  fontSize: 11, color: AppColors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState: _showBoardComputer
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 220),
            ),

            const SizedBox(height: 24),

            // Кнопка сохранить
            SizedBox(
              width: double.infinity,
              child: SheetSaveButton(loading: _loading, onTap: _save),
            ),
          ],
        ),
      ),
    );
  }
}

/// Поле ввода текущего уровня топлива с визуальным индикатором заполнения.
class _FuelLevelField extends StatelessWidget {
  const _FuelLevelField({
    required this.controller,
    required this.tankCtrl,
    required this.onChanged,
  });

  final TextEditingController controller;
  final TextEditingController tankCtrl;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final tankCapacity = int.tryParse(tankCtrl.text.trim());
    final currentLevel = int.tryParse(controller.text.trim());
    final fillRatio = (tankCapacity != null &&
            tankCapacity > 0 &&
            currentLevel != null)
        ? (currentLevel / tankCapacity).clamp(0.0, 1.0)
        : null;

    Color barColor = AppColors.blue;
    if (fillRatio != null) {
      if (fillRatio < 0.2) barColor = AppColors.red;
      else if (fillRatio < 0.4) barColor = AppColors.yellow;
      else barColor = AppColors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SheetTextField(
                controller: controller,
                label: 'Топливо сейчас',
                hint: tankCapacity != null ? '${(tankCapacity * 0.5).round()}' : '30',
                suffix: 'л',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => onChanged(),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final n = int.tryParse(v.trim());
                  if (n == null || n < 0) return 'Введите число';
                  if (tankCapacity != null && n > tankCapacity) {
                    return 'Больше объёма бака';
                  }
                  return null;
                },
              ),
            ),
            if (fillRatio != null) ...[
              const SizedBox(width: 12),
              Column(
                children: [
                  Text(
                    '${(fillRatio * 100).round()}%',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: barColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 36,
                    height: 56,
                    child: CustomPaint(
                      painter: _TankPainter(
                        fillRatio: fillRatio,
                        color: barColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Рисует схематичный бак с уровнем топлива.
class _TankPainter extends CustomPainter {
  const _TankPainter({required this.fillRatio, required this.color});
  final double fillRatio;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = AppColors.border1
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final fillPaint = Paint()
      ..color = color.withAlpha(40)
      ..style = PaintingStyle.fill;
    final fillStrokePaint = Paint()
      ..color = color.withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rr = const Radius.circular(6);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, rr);

    // Залитая часть снизу
    final fillHeight = size.height * fillRatio;
    final fillRect = Rect.fromLTWH(
      0, size.height - fillHeight, size.width, fillHeight);
    final fillRRect = RRect.fromRectAndCorners(
      fillRect,
      bottomLeft: rr,
      bottomRight: rr,
      topLeft: fillRatio >= 0.99 ? rr : Radius.zero,
      topRight: fillRatio >= 0.99 ? rr : Radius.zero,
    );

    canvas.drawRRect(fillRRect, fillPaint);
    canvas.drawRRect(fillRRect, fillStrokePaint);
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(_TankPainter old) =>
      old.fillRatio != fillRatio || old.color != color;
}
