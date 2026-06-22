import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/services/bluetooth_auto_trip_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/car_home_cubit.dart';
import '../bloc/car_home_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settings = sl();
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _appVersion = '${info.version} (${info.buildNumber})');
    } catch (_) {
      if (mounted) setState(() => _appVersion = '—');
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topPad + 12),

                // ── Header ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 24, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 20, color: AppColors.text2),
                      ),
                      Expanded(
                        child: Text(
                          'Настройки',
                          style: GoogleFonts.manrope(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text1,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Валюта ───────────────────────────────────────────────
                _SectionLabel(label: 'Валюта'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _CurrencySelector(settings: _settings, onChanged: () => setState(() {})),
                ),

                const SizedBox(height: 24),

                // ── Уведомления ──────────────────────────────────────────
                _SectionLabel(label: 'Уведомления'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _NotificationSettings(settings: _settings, onChanged: () => setState(() {})),
                ),

                const SizedBox(height: 24),

                // ── Bluetooth ────────────────────────────────────────────────
                if (Platform.isAndroid) ...[
                  _SectionLabel(label: 'Bluetooth'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _BluetoothSettings(onChanged: () => setState(() {})),
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Автомобиль ───────────────────────────────────────────
                _SectionLabel(label: 'Автомобиль'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _DeleteCarCard(context: context),
                ),

                const SizedBox(height: 24),

                // ── О приложении ─────────────────────────────────────────
                _SectionLabel(label: 'О приложении'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _AboutCard(version: _appVersion),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Currency selector chips
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencySelector extends StatelessWidget {
  const _CurrencySelector({required this.settings, required this.onChanged});
  final SettingsService settings;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final current = settings.currencySymbol;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Row(
        children: kCurrencyOptions.map((symbol) {
          final isActive = symbol == current;
          return Expanded(
            child: GestureDetector(
              onTap: () async {
                await settings.setCurrencySymbol(symbol);
                onChanged();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 40,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: isActive
                      ? [BoxShadow(
                          color: AppColors.blue.withAlpha(60),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )]
                      : null,
                ),
                child: Center(
                  child: Text(
                    symbol,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : AppColors.text2,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification toggles
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationSettings extends StatelessWidget {
  const _NotificationSettings({required this.settings, required this.onChanged});
  final SettingsService settings;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Column(
        children: [
          _ToggleRow(
            icon: Icons.oil_barrel_rounded,
            iconColor: AppColors.yellow,
            title: 'ТО и замена масла',
            subtitle: 'Напоминать за 500 км',
            value: settings.notifyTO,
            onChanged: (v) async {
              await settings.setNotifyTO(v);
              onChanged();
            },
            isFirst: true,
          ),
          Divider(height: 0.5, color: AppColors.border1, indent: 56, endIndent: 16),
          _ToggleRow(
            icon: Icons.shield_rounded,
            iconColor: const Color(0xFFBF5AF2),
            title: 'Страховка',
            subtitle: 'Напоминать за 30 дней',
            value: settings.notifyInsurance,
            onChanged: (v) async {
              await settings.setNotifyInsurance(v);
              onChanged();
            },
            isFirst: false,
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isFirst,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isFirst ? 14 : 10, 16, isFirst ? 10 : 14),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.manrope(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text1,
                )),
                Text(subtitle, style: GoogleFonts.manrope(
                  fontSize: 11, color: AppColors.text3,
                )),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.blue,
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return AppColors.blue.withAlpha(80);
              return AppColors.bg3;
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Delete car card
// ─────────────────────────────────────────────────────────────────────────────

class _DeleteCarCard extends StatelessWidget {
  const _DeleteCarCard({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarHomeCubit, CarHomeState>(
      builder: (context, state) {
        if (state is! CarHomeLoaded) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => _confirmDelete(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bg1,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.red.withAlpha(60), width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.red.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_forever_rounded, size: 18, color: AppColors.red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Удалить автомобиль', style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.red,
                      )),
                      Text(
                        '${state.car.brand} ${state.car.model} · все данные будут удалены',
                        style: GoogleFonts.manrope(fontSize: 11, color: AppColors.text3),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.red),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg2,
        title: Text('Удалить автомобиль?',
            style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.text1)),
        content: Text(
          'Все заправки, расходы и документы будут безвозвратно удалены.',
          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.text2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Отмена', style: GoogleFonts.manrope(color: AppColors.text3)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await context.read<CarHomeCubit>().deleteCarAndAllData();
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text('Удалить',
                style: GoogleFonts.manrope(color: AppColors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// About card
// ─────────────────────────────────────────────────────────────────────────────

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.version});
  final String version;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Column(
        children: [
          _InfoRow(label: 'Версия', value: version, isFirst: true),
          Divider(height: 0.5, color: AppColors.border1, indent: 16, endIndent: 16),
          _InfoRow(label: 'Разработчик', value: 'Nikita Shybeka', isFirst: false),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.isFirst});
  final String label;
  final String value;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isFirst ? 14 : 10, 16, isFirst ? 10 : 14),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: GoogleFonts.manrope(
              fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.text2,
            )),
          ),
          Text(value, style: GoogleFonts.manrope(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text1,
          )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bluetooth auto-trip settings
// ─────────────────────────────────────────────────────────────────────────────

class _BluetoothSettings extends StatefulWidget {
  const _BluetoothSettings({required this.onChanged});
  final VoidCallback onChanged;

  @override
  State<_BluetoothSettings> createState() => _BluetoothSettingsState();
}

class _BluetoothSettingsState extends State<_BluetoothSettings> {
  final _bt = BluetoothAutoTripService.instance;
  bool _enabled = false;
  String? _deviceName;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await _bt.isEnabled;
    final name = await _bt.linkedDeviceName;
    if (mounted) setState(() { _enabled = enabled; _deviceName = name; });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border1, width: 0.5),
      ),
      child: Column(
        children: [
          // Переключатель авто-поездки
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.blue.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.bluetooth_rounded,
                      size: 17, color: AppColors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Авто-поездка',
                          style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text1)),
                      Text(
                        _deviceName != null
                            ? 'Привязано: $_deviceName'
                            : 'Подключитесь к BT-устройству в авто',
                        style: GoogleFonts.manrope(
                            fontSize: 11, color: AppColors.text3),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _enabled && _deviceName != null,
                  onChanged: _deviceName == null
                      ? null
                      : (v) async {
                          await _bt.setEnabled(v);
                          setState(() => _enabled = v);
                          widget.onChanged();
                        },
                  activeThumbColor: AppColors.blue,
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.blue.withAlpha(80);
                    }
                    return AppColors.bg3;
                  }),
                ),
              ],
            ),
          ),

          // Кнопка отвязать устройство (если привязано)
          if (_deviceName != null) ...[
            Divider(height: 0.5, color: AppColors.border1, indent: 16, endIndent: 16),
            GestureDetector(
              onTap: () async {
                await _bt.removeCarDevice();
                await _load();
                widget.onChanged();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                child: Row(
                  children: [
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.red.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.bluetooth_disabled_rounded,
                          size: 17, color: AppColors.red),
                    ),
                    const SizedBox(width: 12),
                    Text('Отвязать устройство',
                        style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.red)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
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
