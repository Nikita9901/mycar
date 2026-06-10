import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/currency_provider.dart';
import '../../../../core/widgets/sheet_widgets.dart';
import '../../../car/domain/entities/car.dart';
import '../../../car/presentation/bloc/car_home_cubit.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet._({required this.car});

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
        child: AddExpenseSheet._(car: car),
      ),
    );
  }

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  ExpenseCategory _category = ExpenseCategory.service;
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _costCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<CarHomeCubit>().addExpense(
            AddExpenseParams(
              carId: widget.car.id,
              category: _category,
              cost: double.parse(_costCtrl.text.trim().replaceAll(',', '.')),
              title: _titleCtrl.text.trim(),
              note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
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

            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.amber.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.receipt_long_rounded,
                      size: 20, color: AppColors.amber),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Расход',
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

            // Категория
            Text(
              'КАТЕГОРИЯ',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.text3,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExpenseCategory.values.map((cat) {
                final selected = cat == _category;
                return GestureDetector(
                  onTap: () => setState(() => _category = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.amber.withAlpha(30)
                          : AppColors.bg3,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? AppColors.amber.withAlpha(130)
                            : AppColors.border1,
                        width: selected ? 1 : 0.5,
                      ),
                    ),
                    child: Text(
                      cat.label,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? AppColors.amber : AppColors.text2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Название
            SheetTextField(
              controller: _titleCtrl,
              label: 'Название',
              hint: 'ТО 60 000 км',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Введите название' : null,
            ),

            const SizedBox(height: 14),

            // Сумма
            SheetTextField(
              controller: _costCtrl,
              label: 'Сумма',
              hint: '5 000',
              suffix: CurrencyProvider.of(context),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Введите сумму';
                if (double.tryParse(v.trim().replaceAll(',', '.')) == null) {
                  return 'Неверный формат';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Заметка
            SheetTextField(
              controller: _noteCtrl,
              label: 'Заметка (необязательно)',
              hint: 'Замена масла, фильтров...',
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
