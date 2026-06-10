import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/currency_provider.dart';
import '../../../car/presentation/bloc/car_home_cubit.dart';
import '../../../expense/domain/entities/expense.dart';
import '../../domain/entities/history_item.dart';
import '../bloc/history_cubit.dart';
import '../bloc/history_state.dart';
import '../widgets/history_detail_sheet.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) => switch (state) {
        HistoryLoading() => const _LoadingView(),
        HistoryEmpty()   => const _EmptyView(),
        HistoryLoaded()  => _LoadedView(items: state.items),
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Загрузка
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.blue, strokeWidth: 2),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Пусто
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.fromLTRB(32, topPad + 24, 32, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок страницы
          Text(
            'История',
            style: GoogleFonts.manrope(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.text1,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Все заправки и расходы',
            style: GoogleFonts.manrope(fontSize: 14, color: AppColors.text3),
          ),

          const Spacer(),

          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.blue.withAlpha(35),
                        AppColors.blue.withAlpha(12),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.blue.withAlpha(55), width: 1),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    size: 38,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'История пуста',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text1,
                    letterSpacing: -0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Здесь будут отображаться ваши заправки\nи расходы. Нажмите «+», чтобы добавить\nпервую запись.',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: AppColors.text2,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Список с данными
// ─────────────────────────────────────────────────────────────────────────────

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.items});

  final List<HistoryItem> items;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final grouped = _buildGroupedList(items);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Заголовок страницы ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, topPad + 24, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'История',
                  style: GoogleFonts.manrope(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text1,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${items.length} ${_pluralRecords(items.length)}',
                  style: GoogleFonts.manrope(
                      fontSize: 14, color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),

        // ── Группированный список ───────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          sliver: SliverList.builder(
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final entry = grouped[index];
              if (entry is String) {
                return _MonthHeader(label: entry);
              }
              final item = entry as HistoryItem;
              return _HistoryCard(
                key: ValueKey(switch (item) {
                  RefuelingHistoryItem(refueling: final r) => 'r_${r.id}',
                  ExpenseHistoryItem(expense: final e) => 'e_${e.id}',
                }),
                item: item,
                isLast: _isLastInGroup(grouped, index),
              );
            },
          ),
        ),

        // Отступ под нав-бар
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom + 68 + 28,
          ),
        ),
      ],
    );
  }

  /// Строит плоский список из заголовков месяцев (String) и элементов (HistoryItem).
  static List<Object> _buildGroupedList(List<HistoryItem> items) {
    final result = <Object>[];
    String? currentKey;

    for (final item in items) {
      final key = _monthKey(item.date);
      if (key != currentKey) {
        currentKey = key;
        result.add(key);
      }
      result.add(item);
    }

    return result;
  }

  static bool _isLastInGroup(List<Object> grouped, int index) {
    if (index == grouped.length - 1) return true;
    return grouped[index + 1] is String;
  }

  static String _monthKey(DateTime date) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  static String _pluralRecords(int n) {
    if (n % 100 >= 11 && n % 100 <= 14) return 'записей';
    switch (n % 10) {
      case 1:
        return 'запись';
      case 2:
      case 3:
      case 4:
        return 'записи';
      default:
        return 'записей';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Заголовок месяца
// ─────────────────────────────────────────────────────────────────────────────

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.text3,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Карточка записи
// ─────────────────────────────────────────────────────────────────────────────

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({super.key, required this.item, required this.isLast});

  final HistoryItem item;
  final bool isLast;

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg2,
        title: Text('Удалить запись?',
            style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.text1)),
        content: Text(
          'Это действие нельзя отменить.',
          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.text2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Отмена', style: GoogleFonts.manrope(color: AppColors.text3)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Удалить',
                style: GoogleFonts.manrope(color: AppColors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        final cubit = context.read<CarHomeCubit>();
        switch (item) {
          case RefuelingHistoryItem(refueling: final r):
            cubit.deleteRefueling(r.id);
          case ExpenseHistoryItem(expense: final e):
            cubit.deleteExpense(e.id);
        }
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: AppColors.red.withAlpha(200),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 22),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 2),
        child: Material(
          color: AppColors.bg1,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => HistoryDetailSheet.show(context, item),
            borderRadius: BorderRadius.circular(18),
            splashColor: _accentColor.withAlpha(18),
            highlightColor: _accentColor.withAlpha(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // ── Иконка ────────────────────────────────────────────────
                  _ItemIcon(color: _accentColor, icon: _icon),

                  const SizedBox(width: 14),

                  // ── Основной текст ─────────────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _subtitle,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppColors.text3,
                            height: 1.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ── Сумма ──────────────────────────────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '−\u202F${_formatCost(item.cost, CurrencyProvider.of(context))}',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _typeLabel,
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _accentColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Данные, зависящие от типа записи ────────────────────────────────────

  Color get _accentColor => switch (item) {
        RefuelingHistoryItem() => AppColors.blue,
        ExpenseHistoryItem(expense: final e) => _categoryColor(e.category),
      };

  IconData get _icon => switch (item) {
        RefuelingHistoryItem() => Icons.local_gas_station_rounded,
        ExpenseHistoryItem(expense: final e) => _categoryIcon(e.category),
      };

  String get _title => switch (item) {
        RefuelingHistoryItem(refueling: final r) =>
          r.stationName ?? 'Заправка',
        ExpenseHistoryItem(expense: final e) => e.title,
      };

  String get _subtitle => switch (item) {
        RefuelingHistoryItem(refueling: final r) =>
          '${_formatDate(r.date)} · ${_fmtOdo(r.odometer)} км · ${r.liters.toStringAsFixed(1)} л',
        ExpenseHistoryItem(expense: final e) =>
          '${_formatDate(e.date)} · ${e.category.label}',
      };

  String get _typeLabel => switch (item) {
        RefuelingHistoryItem() => 'Заправка',
        ExpenseHistoryItem(expense: final e) => e.category.label,
      };

  // ── Вспомогательные функции ──────────────────────────────────────────────

  static Color _categoryColor(ExpenseCategory cat) => switch (cat) {
        ExpenseCategory.service   => const Color(0xFFFF9500),
        ExpenseCategory.insurance => const Color(0xFFBF5AF2),
        ExpenseCategory.carwash   => const Color(0xFF32ADE6),
        ExpenseCategory.fine      => AppColors.red,
        ExpenseCategory.parking   => const Color(0xFF6E6E73),
        ExpenseCategory.other     => AppColors.text2,
      };

  static IconData _categoryIcon(ExpenseCategory cat) => switch (cat) {
        ExpenseCategory.service   => Icons.build_rounded,
        ExpenseCategory.insurance => Icons.shield_rounded,
        ExpenseCategory.carwash   => Icons.water_drop_rounded,
        ExpenseCategory.fine      => Icons.warning_rounded,
        ExpenseCategory.parking   => Icons.local_parking_rounded,
        ExpenseCategory.other     => Icons.more_horiz_rounded,
      };

  static String _formatDate(DateTime d) {
    const months = [
      'янв', 'фев', 'мар', 'апр', 'мая', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
    ];
    final time = DateFormat('HH:mm').format(d);
    return '${d.day} ${months[d.month - 1]}, $time';
  }

  static String _fmtOdo(int km) =>
      NumberFormat('#,##0', 'ru_RU').format(km).replaceAll(',', '\u202F');

  static String _formatCost(double cost, String currency) {
    final formatted =
        NumberFormat('#,##0', 'ru_RU').format(cost.round()).replaceAll(',', '\u202F');
    return '$formatted $currency';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Иконка записи
// ─────────────────────────────────────────────────────────────────────────────

class _ItemIcon extends StatelessWidget {
  const _ItemIcon({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
