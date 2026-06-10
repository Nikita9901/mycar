import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:open_filex/open_filex.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/car_home_cubit.dart';
import '../bloc/car_home_state.dart';
import '../widgets/add_insurance_sheet.dart';
import '../widgets/car_header_widget.dart';
import '../widgets/oil_change_sheet.dart';
import '../widgets/reminders_sheet.dart';
import '../widgets/tech_status_widget.dart';
import '../widgets/fuel_level_widget.dart';
import '../widgets/last_refueling_widget.dart';
import '../../presentation/pages/settings_screen.dart';

class CarHomeScreen extends StatelessWidget {
  const CarHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: BlocBuilder<CarHomeCubit, CarHomeState>(
        builder: (context, state) => switch (state) {
          CarHomeLoading() => const _LoadingView(),
          CarHomeEmpty()   => const _EmptyGarageView(),
          CarHomeError()   => _ErrorView(message: state.message),
          CarHomeLoaded()  => _LoadedView(state: state),
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Загружено
// ─────────────────────────────────────────────────────────────────────────────

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.state});
  final CarHomeLoaded state;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    // навбар 68 + отступы ~28 + safe area
    final bottomSpace = bottomPad + 68 + 28;
    final cubit = context.read<CarHomeCubit>();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topPad + 20),

              // ── Заголовок страницы ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Мой гараж',
                        style: GoogleFonts.manrope(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text1,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                    _HeaderIconButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: () => RemindersSheet.show(context, state: state),
                    ),
                    const SizedBox(width: 8),
                    _HeaderIconButton(
                      icon: Icons.settings_outlined,
                      onTap: () {
                        final cubit = context.read<CarHomeCubit>();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: cubit,
                              child: const SettingsScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ── Карточка авто ─────────────────────────────────────────
              CarHeaderWidget(
                car: state.car,
                onOdometerUpdated: cubit.updateOdometer,
              ),

              const SizedBox(height: 24),

              // ── Индикаторы ────────────────────────────────────────────
              _SectionLabel(label: 'Состояние'),
              const SizedBox(height: 10),
              TechStatusWidget(
                oilChangeProgress: state.oilChangeProgress,
                oilChangeKmLeft: state.oilChangeKmLeft,
                insuranceDaysLeft: state.insuranceDaysLeft,
                insurancePdfPath: state.car.insurancePdfPath,
                onOilTap: () => OilChangeSheet.show(context),
                onInsuranceTap: () {
                  final pdfPath = state.car.insurancePdfPath;
                  if (pdfPath != null) {
                    OpenFilex.open(pdfPath);
                  } else {
                    AddInsuranceSheet.show(context);
                  }
                },
                onInsuranceRemove: state.car.insurancePdfPath != null
                    ? () => cubit.removeInsurance()
                    : null,
              ),

              // ── Уровень топлива (только если задан объём бака) ───────
              if (state.car.fuelTankCapacity != null) ...[
                const SizedBox(height: 16),
                FuelLevelWidget(car: state.car),
              ],

              const SizedBox(height: 24),

              // ── Последняя заправка ────────────────────────────────────
              _SectionLabel(label: 'Последняя заправка'),
              const SizedBox(height: 10),
              LastRefuelingWidget(
                lastRefueling: state.lastRefueling,
                fuelConsumptionPer100km: state.fuelConsumptionPer100km,
              ),

              SizedBox(height: bottomSpace),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
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

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.bg1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border1, width: 0.5),
        ),
        child: Icon(icon, size: 20, color: AppColors.text2),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Пустой гараж
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyGarageView extends StatelessWidget {
  const _EmptyGarageView();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.fromLTRB(32, topPad + 20, 32, 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
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
              border: Border.all(color: AppColors.blue.withAlpha(55), width: 1),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              size: 46,
              color: AppColors.blue,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'Гараж пустой',
            style: GoogleFonts.manrope(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.text1,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          Text(
            'Добавьте первый автомобиль,\nнажав кнопку «+» ниже',
            style: GoogleFonts.manrope(
              fontSize: 15,
              color: AppColors.text2,
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Загрузка / Ошибка
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              'Не удалось загрузить данные',
              style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.text1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.manrope(fontSize: 13, color: AppColors.text3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<CarHomeCubit>().loadGarage(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
