import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/di/injection_container.dart';
import '../core/theme/app_theme.dart';
import '../features/analytics/presentation/pages/analytics_screen.dart';
import '../features/car/presentation/bloc/car_home_cubit.dart';
import '../features/car/presentation/bloc/car_home_state.dart';
import '../features/car/presentation/pages/car_home_screen.dart';
import '../features/car/presentation/widgets/add_car_sheet.dart';
import '../features/expense/presentation/widgets/add_expense_sheet.dart';
import '../features/analytics/presentation/bloc/analytics_cubit.dart';
import '../features/history/presentation/bloc/history_cubit.dart';
import '../features/history/presentation/pages/history_screen.dart';
import '../features/refueling/presentation/widgets/add_refueling_sheet.dart';
import 'package:geolocator/geolocator.dart';

import '../features/trip/presentation/bloc/trip_tracking_cubit.dart';
import '../features/trip/presentation/bloc/trip_tracking_state.dart';
import '../features/trip/presentation/widgets/trip_active_sheet.dart';
import '../features/trip/presentation/widgets/trip_result_sheet.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CarHomeCubit>(
          create: (_) => CarHomeCubit(
            watchAllCars: sl(),
            getRefuelingsForCar: sl(),
            calculateFuelConsumption: sl(),
            updateCar: sl(),
            addCar: sl(),
            addRefueling: sl(),
            addExpense: sl(),
            deleteRefueling: sl(),
            deleteExpense: sl(),
            deleteAllCarData: sl(),
          )..loadGarage(),
        ),
        BlocProvider<HistoryCubit>(
          create: (_) => (sl<HistoryCubit>())..load(),
        ),
        BlocProvider<AnalyticsCubit>(
          create: (_) => (sl<AnalyticsCubit>())..load(),
        ),
        BlocProvider<TripTrackingCubit>(
          create: (_) => TripTrackingCubit(),
        ),
      ],
      child: BlocListener<TripTrackingCubit, TripTrackingState>(
        listenWhen: (_, curr) => curr is TripFinished,
        listener: (context, state) {
          if (state is TripFinished) {
            // Обновляем уровень топлива по итогам поездки
            context.read<CarHomeCubit>().updateFuelAfterTrip(
                  state.distanceMeters / 1000,
                );
            // Ждём пока TripActiveSheet закроется, потом показываем итоги
            Future.delayed(const Duration(milliseconds: 350), () {
              if (context.mounted) TripResultSheet.show(context, state);
            });
          }
        },
        child: Scaffold(
        backgroundColor: AppColors.bg0,
        body: Stack(
          children: [
            // ── Tabs ──────────────────────────────────────────────────────
            Positioned.fill(
              child: IndexedStack(
                index: _currentIndex,
                children: const [
                  CarHomeScreen(),
                  HistoryScreen(),
                  AnalyticsScreen(),
                ],
              ),
            ),

            // ── Floating nav bar ──────────────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _FloatingNavBar(
                currentIndex: _currentIndex,
                onTabChanged: (i) => setState(() => _currentIndex = i),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating nav bar
// ─────────────────────────────────────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTabChanged,
  });

  final int currentIndex;
  final void Function(int) onTabChanged;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPad + 16),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.bg1,
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: AppColors.border2, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(160),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: AppColors.blue.withAlpha(12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Вкладка Гараж
            Expanded(
              child: _NavPill(
                icon: Icons.garage_rounded,
                label: 'Гараж',
                isActive: currentIndex == 0,
                onTap: () => onTabChanged(0),
              ),
            ),

            // Вкладка История
            Expanded(
              child: _NavPill(
                icon: Icons.receipt_long_rounded,
                label: 'История',
                isActive: currentIndex == 1,
                onTap: () => onTabChanged(1),
              ),
            ),

            // Центральный FAB
            BlocBuilder<CarHomeCubit, CarHomeState>(
              builder: (context, state) => _CenterFab(state: state),
            ),

            // Вкладка Аналитика
            Expanded(
              child: _NavPill(
                icon: Icons.bar_chart_rounded,
                label: 'Аналитика',
                isActive: currentIndex == 2,
                onTap: () => onTabChanged(2),
              ),
            ),

            // Кнопка поездки — только если есть авто
            BlocBuilder<CarHomeCubit, CarHomeState>(
              buildWhen: (p, c) =>
                  (p is CarHomeLoaded) != (c is CarHomeLoaded),
              builder: (context, carState) {
                if (carState is! CarHomeLoaded) {
                  return const SizedBox.shrink();
                }
                return _TripNavButton();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  const _NavPill({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.blue : AppColors.text3;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterFab extends StatelessWidget {
  const _CenterFab({required this.state});
  final CarHomeState state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (state is CarHomeEmpty || state is CarHomeLoading) {
          _showAddMenu(context, isEmpty: true);
        } else {
          _showAddMenu(context, isEmpty: false);
        }
      },
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.amber,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.amber.withAlpha(100),
              blurRadius: 20,
              offset: const Offset(0, 6),
              spreadRadius: -4,
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, size: 26, color: Colors.black87),
      ),
    );
  }

  void _showAddMenu(BuildContext context, {required bool isEmpty}) {
    final cubit = context.read<CarHomeCubit>();

    if (isEmpty) {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.bg1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        builder: (ctx) {
          final bot = MediaQuery.of(ctx).padding.bottom;
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, bot + 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetHandle(),
                const SizedBox(height: 20),
                _sheetTitle('Добавить автомобиль'),
                const SizedBox(height: 14),
                _OptionTile(
                  icon: Icons.directions_car_rounded,
                  color: AppColors.amber,
                  title: 'Новый автомобиль',
                  subtitle: 'Марка, модель, пробег, госномер',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    AddCarSheet.show(context);
                  },
                ),

              ],
            ),
          );
        },
      );
      return;
    }

    // Loaded state — show full menu
    final car = (cubit.state as CarHomeLoaded).car;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        final bot = MediaQuery.of(ctx).padding.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, bot + 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sheetHandle(),
              const SizedBox(height: 20),
              _sheetTitle('Добавить запись'),
              const SizedBox(height: 14),
              _OptionTile(
                icon: Icons.local_gas_station_rounded,
                color: AppColors.blue,
                title: 'Заправка',
                subtitle: 'Литры, стоимость, одометр',
                onTap: () {
                  Navigator.of(ctx).pop();
                  AddRefuelingSheet.show(context, car: car);
                },
              ),
              const SizedBox(height: 10),
              _OptionTile(
                icon: Icons.build_rounded,
                color: AppColors.green,
                title: 'Расход',
                subtitle: 'Сервис, страховка, штраф и другое',
                onTap: () {
                  Navigator.of(ctx).pop();
                  AddExpenseSheet.show(context, car: car);
                },
              ),
              const SizedBox(height: 10),
              _OptionTile(
                icon: Icons.speed_rounded,
                color: const Color(0xFFFF7043),
                title: 'Обновить пробег',
                subtitle: 'Актуализировать показания одометра',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showOdometerDialog(context, cubit, car.currentOdometer);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOdometerDialog(
      BuildContext context, CarHomeCubit cubit, int current) {
    final ctrl = TextEditingController(text: current.toString());
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg2,
        title: Text(
          'Обновить пробег',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700, color: AppColors.text1),
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: GoogleFonts.manrope(color: AppColors.text1),
          decoration: InputDecoration(
            suffixText: 'км',
            suffixStyle:
                GoogleFonts.manrope(color: AppColors.text2),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Отмена',
                style: GoogleFonts.manrope(color: AppColors.text3)),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(ctrl.text.trim());
              if (val != null && val >= current) {
                cubit.updateOdometer(val);
                Navigator.of(ctx).pop();
              }
            },
            child: Text('Сохранить',
                style: GoogleFonts.manrope(
                    color: AppColors.blue, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  static Widget _sheetHandle() => Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.bg4,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );

  static Widget _sheetTitle(String text) => Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.text1,
          letterSpacing: -0.3,
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Кнопка поездки в навбаре
// ─────────────────────────────────────────────────────────────────────────────

class _TripNavButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripTrackingCubit, TripTrackingState>(
      listenWhen: (_, curr) => curr is TripPermissionDenied,
      listener: (context, state) {
        if (state is TripPermissionDenied) {
          _showPermissionDialog(context, state.isPermanent);
        }
      },
      builder: (context, state) {
        final isActive = state is TripInProgress;
        final isLoading = state is TripRequestingPermission;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isLoading
              ? null
              : () {
                  if (isActive) {
                    TripActiveSheet.show(context);
                  } else {
                    context.read<TripTrackingCubit>().startTrip();
                  }
                },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 60,
              decoration: BoxDecoration(
                color: isActive ? AppColors.green.withAlpha(35) : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                  topRight: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.green),
                    )
                  else
                    Icon(
                      isActive ? Icons.navigation_rounded : Icons.navigation_outlined,
                      size: 22,
                      color: isActive ? AppColors.green : AppColors.text3,
                    ),
                  const SizedBox(height: 3),
                  if (isActive) ...[
                    Text(
                      (state as TripInProgress).formattedDistance,
                      style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                    Text(
                      state.formattedDuration,
                      style: GoogleFonts.manrope(
                        fontSize: 8,
                        color: AppColors.green.withAlpha(180),
                      ),
                    ),
                  ] else
                    Text(
                      isLoading ? 'GPS...' : 'Поездка',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text3,
                        letterSpacing: 0.3,
                      ),
                    ),
                ],
              ),
          ),
        );
      },
    );
  }

  void _showPermissionDialog(BuildContext context, bool isPermanent) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bg2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Нужен доступ к геолокации',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700, color: AppColors.text1),
        ),
        content: Text(
          isPermanent
              ? 'Доступ запрещён. Откройте настройки приложения и разрешите «Местоположение».'
              : 'Для записи пробега нужно разрешить геолокацию.',
          style: GoogleFonts.manrope(fontSize: 14, color: AppColors.text2),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<TripTrackingCubit>().dismiss();
              Navigator.of(context).pop();
            },
            child: Text('Отмена',
                style: GoogleFonts.manrope(color: AppColors.text3)),
          ),
          if (isPermanent)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: Text('Настройки',
                  style: GoogleFonts.manrope(color: AppColors.blue)),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<TripTrackingCubit>().startTrip();
              },
              child: Text('Разрешить',
                  style: GoogleFonts.manrope(color: AppColors.blue)),
            ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg2,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: color.withAlpha(25),
        highlightColor: color.withAlpha(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withAlpha(28),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text1,
                      ),
                    ),
                    Text(
                      subtitle,
                      style:
                          GoogleFonts.manrope(fontSize: 12, color: AppColors.text3),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppColors.text3),
            ],
          ),
        ),
      ),
    );
  }
}
