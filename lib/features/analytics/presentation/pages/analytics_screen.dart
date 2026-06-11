import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/services/pdf_report_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/currency_provider.dart';
import '../../domain/entities/analytics_data.dart';
import '../bloc/analytics_cubit.dart';
import '../bloc/analytics_state.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) => switch (state) {
        AnalyticsLoading() => const _LoadingView(),
        AnalyticsEmpty()   => const _EmptyView(),
        AnalyticsLoaded()  => _LoadedView(state: state),
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
          Text(
            'Аналитика',
            style: GoogleFonts.manrope(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.text1,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Финансовые показатели',
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
                      colors: [
                        AppColors.amber.withAlpha(35),
                        AppColors.amber.withAlpha(12),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.amber.withAlpha(55), width: 1),
                  ),
                  child: const Icon(Icons.bar_chart_rounded,
                      size: 38, color: AppColors.amber),
                ),
                const SizedBox(height: 24),
                Text(
                  'Данных пока нет',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text1,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Добавьте заправки и расходы,\nчтобы увидеть статистику.',
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
// Данные загружены
// ─────────────────────────────────────────────────────────────────────────────

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.state});

  final AnalyticsLoaded state;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final cubit = context.read<AnalyticsCubit>();

    return SizedBox.expand(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, topPad + 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Заголовок ──────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Аналитика',
                              style: GoogleFonts.manrope(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text1,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Финансовые показатели',
                              style: GoogleFonts.manrope(
                                  fontSize: 14, color: AppColors.text3),
                            ),
                          ],
                        ),
                      ),
                      if (state.isPremiumUser)
                        _PremiumBadge(),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Переключатель периода ──────────────────────────────
                  _PeriodSelector(
                    selected: state.selectedPeriod,
                    isPremium: state.isPremiumUser,
                    onSelect: (period) {
                      final allowed = cubit.changePeriod(period);
                      if (!allowed) _showPaywall(context);
                    },
                  ),

                  const SizedBox(height: 20),

                  // ── Карточка «Общие расходы» ───────────────────────────
                  _TotalCard(totalSpend: state.data.totalSpend),

                  const SizedBox(height: 12),

                  // ── Инсайты: расход топлива + стоимость км ─────────────
                  Row(
                    children: [
                      Expanded(
                        child: _InsightCard(
                          label: 'Ср. расход',
                          value: state.data.avgConsumptionPer100km != null
                              ? '${state.data.avgConsumptionPer100km!.toStringAsFixed(1)} л'
                              : '—',
                          unit: '/ 100 км',
                          icon: Icons.local_gas_station_rounded,
                          color: AppColors.blue,
                          isLocked: false,
                          badge: state.data.consumptionIsFromCar ? 'БК' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CostPerKmCard(
                          costPerKm: state.data.costPerKm,
                          isPremium: state.isPremiumUser,
                          onTap: state.isPremiumUser
                              ? null
                              : () => _showPaywall(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Круговая диаграмма ─────────────────────────────────
                  if (state.data.categoryBreakdown.isNotEmpty) ...[
                    _SectionLabel(label: 'Структура расходов'),
                    const SizedBox(height: 16),
                    _SpendDonut(categories: state.data.categoryBreakdown),
                    const SizedBox(height: 20),
                    _Legend(categories: state.data.categoryBreakdown),
                  ],

                  const SizedBox(height: 28),

                  // ── Кнопка экспорта (только Premium) ──────────────────
                  if (state.isPremiumUser)
                    _ExportButton()
                  else
                    _UpgradeButton(onTap: () => _showPaywall(context)),

                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 68 + 28,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showPaywall(BuildContext context) {
    final cubit = context.read<AnalyticsCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PremiumPaywallSheet(cubit: cubit),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Переключатель периода — sliding segmented control
// ─────────────────────────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selected,
    required this.isPremium,
    required this.onSelect,
  });

  final AnalyticsPeriod selected;
  final bool isPremium;
  final void Function(AnalyticsPeriod) onSelect;

  @override
  Widget build(BuildContext context) {
    final periods = AnalyticsPeriod.values;
    final selectedIndex = periods.indexOf(selected);

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth =
              (constraints.maxWidth - 8) / periods.length;

          return Stack(
            children: [
              // Sliding indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                left: selectedIndex * itemWidth,
                top: 0,
                bottom: 0,
                width: itemWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.bg4,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(70),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Labels
              Row(
                children: periods.map((period) {
                  final isSelected = period == selected;
                  final isLocked =
                      !isPremium && period != AnalyticsPeriod.month;

                  return GestureDetector(
                    onTap: () => onSelect(period),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: itemWidth,
                      height: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLocked) ...[
                            Icon(
                              Icons.lock_rounded,
                              size: 10,
                              color: isSelected
                                  ? AppColors.text2
                                  : AppColors.text3,
                            ),
                            const SizedBox(width: 4),
                          ],
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 180),
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.text1
                                  : AppColors.text3,
                            ),
                            child: Text(period.label),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Карточка «Общие расходы»
// ─────────────────────────────────────────────────────────────────────────────

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.totalSpend});

  final double totalSpend;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        border: Border.all(color: AppColors.blue.withAlpha(60), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.blue.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded,
                    size: 16, color: AppColors.blue),
              ),
              const SizedBox(width: 10),
              Text(
                'Общие расходы',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _formatCost(totalSpend, CurrencyProvider.of(context)),
            style: GoogleFonts.manrope(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.text1,
              letterSpacing: -1,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'за выбранный период',
            style: GoogleFonts.manrope(fontSize: 12, color: AppColors.text3),
          ),
        ],
      ),
    );
  }

  static String _formatCost(double cost, String currency) {
    final n = NumberFormat('#,##0', 'ru_RU')
        .format(cost.round())
        .replaceAll(',', '\u202F');
    return '$n $currency';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Карточка инсайта (средний расход)
// ─────────────────────────────────────────────────────────────────────────────

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.isLocked,
    this.badge,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final bool isLocked;
  /// Маленькая плашка рядом с иконкой (например «БК» — данные бортового компьютера).
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withAlpha(30),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    badge!,
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.text1,
              letterSpacing: -0.5,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style:
                GoogleFonts.manrope(fontSize: 11, color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Карточка «Стоимость 1 км» — с размытием для бесплатных
// ─────────────────────────────────────────────────────────────────────────────

class _CostPerKmCard extends StatelessWidget {
  const _CostPerKmCard({
    required this.costPerKm,
    required this.isPremium,
    required this.onTap,
  });

  final double? costPerKm;
  final bool isPremium;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final valueText = costPerKm != null
        ? costPerKm!.toStringAsFixed(1)
        : '—';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bg1,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isPremium
                ? AppColors.border1
                : AppColors.amber.withAlpha(80),
            width: isPremium ? 0.5 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.route_rounded,
                          size: 14, color: AppColors.green),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '1 км пути',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    valueText,
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text1,
                      letterSpacing: -0.5,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${CurrencyProvider.of(context)} / км',
                    style: GoogleFonts.manrope(
                        fontSize: 11, color: AppColors.text3),
                  ),
                ],
              ),

              // Размытие для бесплатных пользователей
              if (!isPremium)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.bg1.withAlpha(160),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.amber.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.lock_rounded,
                                size: 16, color: AppColors.amber),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Premium',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Диаграмма «Пончик»
// ─────────────────────────────────────────────────────────────────────────────

class _SpendDonut extends StatefulWidget {
  const _SpendDonut({required this.categories});

  final List<CategorySpend> categories;

  @override
  State<_SpendDonut> createState() => _SpendDonutState();
}

class _SpendDonutState extends State<_SpendDonut> {
  int? _touched;

  @override
  Widget build(BuildContext context) {
    final sections = widget.categories.asMap().entries.map((entry) {
      final i = entry.key;
      final cat = entry.value;
      final isTouched = _touched == i;

      return PieChartSectionData(
        color: cat.color,
        value: cat.amount,
        title: isTouched
            ? '${(cat.percentage * 100).toStringAsFixed(0)}%'
            : '',
        titleStyle: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          shadows: [
            const Shadow(color: Colors.black26, blurRadius: 4),
          ],
        ),
        radius: isTouched ? 52 : 42,
        badgeWidget: null,
      );
    }).toList();

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2.5,
          centerSpaceRadius: 64,
          startDegreeOffset: -90,
          sections: sections,
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    response == null ||
                    response.touchedSection == null) {
                  _touched = null;
                  return;
                }
                _touched =
                    response.touchedSection!.touchedSectionIndex;
              });
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Легенда
// ─────────────────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  const _Legend({required this.categories});

  final List<CategorySpend> categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Column(
        children: categories.asMap().entries.map((entry) {
          final i = entry.key;
          final cat = entry.value;
          final isLast = i == categories.length - 1;

          return Column(
            children: [
              Row(
                children: [
                  // Цветной кружок
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: cat.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Название
                  Expanded(
                    child: Text(
                      cat.label,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  // Процент
                  Text(
                    '${(cat.percentage * 100).toStringAsFixed(1)}%',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Сумма
                  Text(
                    _formatAmount(cat.amount, CurrencyProvider.of(context)),
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text1,
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                const SizedBox(height: 8),
                Divider(
                    height: 1,
                    color: AppColors.border1,
                    thickness: 0.5),
                const SizedBox(height: 8),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  static String _formatAmount(double amount, String currency) {
    final n = NumberFormat('#,##0', 'ru_RU')
        .format(amount.round())
        .replaceAll(',', '\u202F');
    return '$n $currency';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Метка секции
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.text3,
        letterSpacing: 2,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Кнопка «Экспорт отчёта» (только Premium)
// ─────────────────────────────────────────────────────────────────────────────

class _ExportButton extends StatefulWidget {
  const _ExportButton();

  @override
  State<_ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<_ExportButton> {
  bool _loading = false;

  Future<void> _export() async {
    final cubit = context.read<AnalyticsCubit>();
    final car = cubit.currentCar;
    if (car == null) return;
    setState(() => _loading = true);
    try {
      final analyticsState = cubit.state;
      double? avgConsumption;
      if (analyticsState is AnalyticsLoaded) {
        avgConsumption = analyticsState.data.avgConsumptionPer100km;
      }
      await sl<PdfReportService>().generateAndShare(
        car: car,
        refuelings: cubit.allRefuelings,
        expenses: cubit.allExpenses,
        currencySymbol: CurrencyProvider.of(context),
        avgConsumption: avgConsumption,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading ? null : _export,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.bg2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border2, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading)
              const SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.text2),
              )
            else
              const Icon(Icons.picture_as_pdf_rounded,
                  size: 18, color: AppColors.text2),
            const SizedBox(width: 10),
            Text(
              _loading ? 'Генерация...' : 'Экспорт отчёта в PDF',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.text2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Кнопка перехода в Premium (для бесплатных)
// ─────────────────────────────────────────────────────────────────────────────

class _UpgradeButton extends StatelessWidget {
  const _UpgradeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.amber,
              AppColors.amber.withRed(255).withGreen(180),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.amber.withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_rounded, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              'Получить Premium',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Значок Premium рядом с заголовком
// ─────────────────────────────────────────────────────────────────────────────

class _PremiumBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.amber.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.amber.withAlpha(80), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 12, color: AppColors.amber),
          const SizedBox(width: 4),
          Text(
            'Premium',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Paywall — шторка предложения Premium
// ─────────────────────────────────────────────────────────────────────────────

class _PremiumPaywallSheet extends StatelessWidget {
  const _PremiumPaywallSheet({required this.cubit});
  final AnalyticsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPad + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const SizedBox(height: 12),
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
            const SizedBox(height: 28),

            // Иконка
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFD700), Color(0xFFFF9500)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amber.withAlpha(100),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.star_rounded,
                  size: 34, color: Colors.white),
            ),

            const SizedBox(height: 20),

            Text(
              'MyCar Premium',
              style: GoogleFonts.manrope(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.text1,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Полный контроль над расходами',
              style: GoogleFonts.manrope(
                  fontSize: 14, color: AppColors.text3),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // Список фич
            _FeatureList(),

            const SizedBox(height: 28),

            // Основная кнопка
            GestureDetector(
              onTap: () {
                cubit.activatePremium();
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF9500)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.amber.withAlpha(100),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Попробовать бесплатно · 7 дней',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Вторичная кнопка
            GestureDetector(
              onTap: () {
                cubit.activatePremium();
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Подключить за 299 ₽/мес',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.text2,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.text3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),
            Text(
              'Отмена в любой момент · Без скрытых условий',
              style: GoogleFonts.manrope(
                  fontSize: 11, color: AppColors.text3),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const features = [
      (Icons.bar_chart_rounded, AppColors.blue,
          'Аналитика за год и всё время', 'Смотрите тренды за любой период'),
      (Icons.route_rounded, AppColors.green,
          'Стоимость 1 км пути', 'Точный расчёт с учётом всех расходов'),
      (Icons.picture_as_pdf_rounded, const Color(0xFFBF5AF2),
          'Экспорт отчёта в PDF', 'Для продажи авто или налоговой'),
      (Icons.notifications_active_rounded, AppColors.amber,
          'Умные напоминания', 'ТО, страховка, штрафы — не пропустите'),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Column(
        children: features.asMap().entries.map((entry) {
          final i = entry.key;
          final (icon, color, title, subtitle) = entry.value;
          final isLast = i == features.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withAlpha(28),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded,
                        size: 18, color: AppColors.green),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColors.border1,
                    thickness: 0.5),
            ],
          );
        }).toList(),
      ),
    );
  }
}
