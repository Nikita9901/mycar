import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/currency_provider.dart';
import '../../../../core/widgets/sheet_widgets.dart';
import '../../../car/domain/entities/car.dart';
import '../../../car/presentation/bloc/car_home_cubit.dart';
import '../../domain/usecases/add_refueling.dart';

class AddRefuelingSheet extends StatefulWidget {
  const AddRefuelingSheet._({required this.car});

  final Car car;

  static void show(BuildContext context, {required Car car}) {
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
        child: AddRefuelingSheet._(car: car),
      ),
    );
  }

  @override
  State<AddRefuelingSheet> createState() => _AddRefuelingSheetState();
}

class _AddRefuelingSheetState extends State<AddRefuelingSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _odoCtrl =
      TextEditingController(text: widget.car.currentOdometer.toString());
  final _litersCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _stationCtrl = TextEditingController();

  bool _isFullTank = true;
  bool _loading = false;

  // Отображаемая цена за литр (вычисляется на лету)
  double? get _pricePerLiter {
    final liters = double.tryParse(_litersCtrl.text.replaceAll(',', '.'));
    final cost = double.tryParse(_costCtrl.text.replaceAll(',', '.'));
    if (liters != null && liters > 0 && cost != null && cost > 0) {
      return cost / liters;
    }
    return null;
  }

  @override
  void dispose() {
    _odoCtrl.dispose();
    _litersCtrl.dispose();
    _costCtrl.dispose();
    _stationCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<CarHomeCubit>().addRefueling(
            AddRefuelingParams(
              carId: widget.car.id,
              date: DateTime.now(),
              odometer: int.parse(_odoCtrl.text.trim()),
              liters:
                  double.parse(_litersCtrl.text.trim().replaceAll(',', '.')),
              totalCost:
                  double.parse(_costCtrl.text.trim().replaceAll(',', '.')),
              isFullTank: _isFullTank,
              stationName: _stationCtrl.text.trim().isEmpty
                  ? null
                  : _stationCtrl.text.trim(),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: AppColors.red),
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

            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.blue.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_gas_station_rounded,
                      size: 20, color: AppColors.blue),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Заправка',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text1,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      widget.car.displayName,
                      style: GoogleFonts.manrope(
                          fontSize: 13, color: AppColors.text3),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Одометр
            SheetTextField(
              controller: _odoCtrl,
              label: 'Пробег',
              hint: widget.car.currentOdometer.toString(),
              suffix: 'км',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Введите пробег';
                final val = int.tryParse(v.trim());
                if (val == null) return 'Только цифры';
                if (val < widget.car.currentOdometer) {
                  return 'Не меньше текущего (${widget.car.currentOdometer})';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: SheetTextField(
                    controller: _litersCtrl,
                    label: 'Литры',
                    hint: '45.00',
                    suffix: 'л',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Введите литры';
                      if (double.tryParse(v.trim().replaceAll(',', '.')) == null) {
                        return 'Неверный формат';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SheetTextField(
                    controller: _costCtrl,
                    label: 'Стоимость',
                    hint: '2 500',
                    suffix: CurrencyProvider.of(context),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Введите сумму';
                      if (double.tryParse(v.trim().replaceAll(',', '.')) == null) {
                        return 'Неверный формат';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            // Цена за литр — подсказка
            if (_pricePerLiter != null) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  '≈ ${_pricePerLiter!.toStringAsFixed(2)} ${CurrencyProvider.of(context)}/л',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 14),

            // АЗС
            SheetTextField(
              controller: _stationCtrl,
              label: 'Название АЗС (необязательно)',
              hint: 'Лукойл, Газпромнефть...',
            ),

            const SizedBox(height: 16),

            // Переключатель «Полный бак»
            GestureDetector(
              onTap: () => setState(() => _isFullTank = !_isFullTank),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bg2,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isFullTank
                        ? AppColors.green.withAlpha(80)
                        : AppColors.border1,
                    width: _isFullTank ? 1 : 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_gas_station_rounded,
                      size: 18,
                      color: _isFullTank ? AppColors.green : AppColors.text3,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Полный бак',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text1,
                            ),
                          ),
                          Text(
                            'Нужно для точного расчёта расхода',
                            style: GoogleFonts.manrope(
                                fontSize: 11, color: AppColors.text3),
                          ),
                        ],
                      ),
                    ),
                    SheetToggle(value: _isFullTank),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

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
