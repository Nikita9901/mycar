import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/currency_provider.dart';
import '../../../car/presentation/bloc/car_home_cubit.dart';
import '../../../expense/domain/entities/expense.dart';
import '../../domain/entities/history_item.dart';

class HistoryDetailSheet extends StatelessWidget {
  const HistoryDetailSheet._({required this.item});
  final HistoryItem item;

  static void show(BuildContext context, HistoryItem item) {
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
        child: HistoryDetailSheet._(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _accentColor.withAlpha(28),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_title,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text1,
                          letterSpacing: -0.3,
                        )),
                    Text(_typeLabel,
                        style: GoogleFonts.manrope(
                            fontSize: 13, color: _accentColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              // Стоимость
              Text(
                '−\u202F${_formatCost(item.cost, CurrencyProvider.of(context))}',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Детали
          Container(
            decoration: BoxDecoration(
              color: AppColors.bg2,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border1, width: 0.5),
            ),
            child: Column(
              children: _buildDetails(context, CurrencyProvider.of(context)),
            ),
          ),

          const SizedBox(height: 16),

          // Кнопка удаления
          GestureDetector(
            onTap: () => _confirmDelete(context),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.red.withAlpha(18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.red.withAlpha(60), width: 0.5),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delete_outline_rounded,
                        size: 18, color: AppColors.red),
                    const SizedBox(width: 8),
                    Text('Удалить запись',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.red,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDetails(BuildContext context, String currency) {
    final rows = <(String, String)>[];

    switch (item) {
      case RefuelingHistoryItem(refueling: final r):
        rows.addAll([
          ('Дата', _formatDateTime(r.date)),
          ('Одометр', _fmtOdo(r.odometer)),
          ('Топливо', '${r.liters.toStringAsFixed(2)} л'),
          ('Сумма', _formatCost(r.totalCost, currency)),
          ('Цена за литр', '${r.pricePerLiter.toStringAsFixed(2)} $currency/л'),
          if (r.stationName != null) ('Заправка', r.stationName!),
          ('Полный бак', r.isFullTank ? 'Да' : 'Нет'),
        ]);
      case ExpenseHistoryItem(expense: final e):
        rows.addAll([
          ('Дата', _formatDateTime(e.date)),
          ('Категория', e.category.label),
          ('Сумма', _formatCost(e.cost, currency)),
          if (e.note != null && e.note!.isNotEmpty) ('Примечание', e.note!),
        ]);
    }

    return rows.indexed.map(((int, (String, String)) entry) {
      final (idx, (label, value)) = entry;
      final isLast = idx == rows.length - 1;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
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
                      color: AppColors.text1,
                    )),
              ],
            ),
          ),
          if (!isLast)
            Divider(
                height: 0.5,
                color: AppColors.border1,
                indent: 16,
                endIndent: 16),
        ],
      );
    }).toList();
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg2,
        title: Text('Удалить запись?',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700, color: AppColors.text1)),
        content: Text('Это действие нельзя отменить.',
            style: GoogleFonts.manrope(fontSize: 13, color: AppColors.text2)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Отмена',
                style: GoogleFonts.manrope(color: AppColors.text3)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final cubit = context.read<CarHomeCubit>();
              switch (item) {
                case RefuelingHistoryItem(refueling: final r):
                  await cubit.deleteRefueling(r.id);
                case ExpenseHistoryItem(expense: final e):
                  await cubit.deleteExpense(e.id);
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text('Удалить',
                style: GoogleFonts.manrope(
                    color: AppColors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Color get _accentColor => switch (item) {
        RefuelingHistoryItem() => AppColors.blue,
        ExpenseHistoryItem(expense: final e) => _categoryColor(e.category),
      };

  IconData get _icon => switch (item) {
        RefuelingHistoryItem() => Icons.local_gas_station_rounded,
        ExpenseHistoryItem(expense: final e) => _categoryIcon(e.category),
      };

  String get _title => switch (item) {
        RefuelingHistoryItem(refueling: final r) => r.stationName ?? 'Заправка',
        ExpenseHistoryItem(expense: final e) => e.title,
      };

  String get _typeLabel => switch (item) {
        RefuelingHistoryItem() => 'Заправка',
        ExpenseHistoryItem(expense: final e) => e.category.label,
      };

  static Color _categoryColor(ExpenseCategory cat) => switch (cat) {
        ExpenseCategory.service => const Color(0xFFFF9500),
        ExpenseCategory.insurance => const Color(0xFFBF5AF2),
        ExpenseCategory.carwash => const Color(0xFF32ADE6),
        ExpenseCategory.fine => AppColors.red,
        ExpenseCategory.parking => const Color(0xFF6E6E73),
        ExpenseCategory.other => AppColors.text2,
      };

  static IconData _categoryIcon(ExpenseCategory cat) => switch (cat) {
        ExpenseCategory.service => Icons.build_rounded,
        ExpenseCategory.insurance => Icons.shield_rounded,
        ExpenseCategory.carwash => Icons.water_drop_rounded,
        ExpenseCategory.fine => Icons.warning_rounded,
        ExpenseCategory.parking => Icons.local_parking_rounded,
        ExpenseCategory.other => Icons.more_horiz_rounded,
      };

  static String _formatDateTime(DateTime d) {
    return DateFormat('dd.MM.yyyy, HH:mm').format(d);
  }

  static String _fmtOdo(int km) =>
      '${NumberFormat('#,##0', 'ru_RU').format(km).replaceAll(',', '\u202F')} км';

  static String _formatCost(double cost, String currency) {
    final s = NumberFormat('#,##0', 'ru_RU')
        .format(cost.round())
        .replaceAll(',', '\u202F');
    return '$s $currency';
  }
}
