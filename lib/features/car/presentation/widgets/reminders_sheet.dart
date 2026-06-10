import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/car_home_state.dart';

class RemindersSheet extends StatelessWidget {
  const RemindersSheet._({required this.state});
  final CarHomeLoaded state;

  static void show(BuildContext context, {required CarHomeLoaded state}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => RemindersSheet._(state: state),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final reminders = _buildReminders();

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

          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.blue.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_rounded,
                    size: 20, color: AppColors.blue),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Напоминания',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text1,
                        letterSpacing: -0.4,
                      )),
                  Text(state.car.displayName,
                      style: GoogleFonts.manrope(
                          fontSize: 13, color: AppColors.text3)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (reminders.isEmpty)
            _EmptyReminders()
          else
            ...reminders.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ReminderCard(reminder: r),
                )),
        ],
      ),
    );
  }

  List<_Reminder> _buildReminders() {
    final list = <_Reminder>[];

    // Масло
    final oilKmLeft = state.oilChangeKmLeft;
    if (oilKmLeft <= 1500) {
      list.add(_Reminder(
        icon: Icons.oil_barrel_rounded,
        color: oilKmLeft <= 0 ? AppColors.red : AppColors.yellow,
        title: oilKmLeft <= 0
            ? 'Замена масла просрочена'
            : 'Скоро замена масла',
        subtitle: oilKmLeft <= 0
            ? 'Превышено на ${(-oilKmLeft).abs()} км. Выполните замену как можно скорее.'
            : 'Осталось $oilKmLeft км до плановой замены масла.',
        isUrgent: oilKmLeft <= 0,
      ));
    } else {
      list.add(_Reminder(
        icon: Icons.oil_barrel_rounded,
        color: AppColors.green,
        title: 'Масло в норме',
        subtitle: 'До следующей замены осталось $oilKmLeft км.',
        isUrgent: false,
      ));
    }

    // Страховка
    final insLeft = state.insuranceDaysLeft;
    if (insLeft != null) {
      if (insLeft <= 30) {
        list.add(_Reminder(
          icon: Icons.shield_rounded,
          color: insLeft <= 7 ? AppColors.red : AppColors.yellow,
          title: insLeft <= 0
              ? 'Страховка истекла'
              : 'Страховка истекает скоро',
          subtitle: insLeft <= 0
              ? 'Ваша страховка уже не действует. Необходимо продлить.'
              : 'До конца страховки осталось $insLeft ${_dayWord(insLeft)}.',
          isUrgent: insLeft <= 7,
        ));
      } else {
        list.add(_Reminder(
          icon: Icons.shield_rounded,
          color: AppColors.green,
          title: 'Страховка действует',
          subtitle: 'До окончания страховки $insLeft ${_dayWord(insLeft)}.',
          isUrgent: false,
        ));
      }
    } else {
      list.add(_Reminder(
        icon: Icons.shield_outlined,
        color: AppColors.text3,
        title: 'Страховка не добавлена',
        subtitle: 'Загрузите полис ОСАГО в разделе «Состояние».',
        isUrgent: false,
      ));
    }

    return list;
  }

  static String _dayWord(int days) {
    if (days % 100 >= 11 && days % 100 <= 14) return 'дней';
    switch (days % 10) {
      case 1:
        return 'день';
      case 2:
      case 3:
      case 4:
        return 'дня';
      default:
        return 'дней';
    }
  }
}

class _Reminder {
  const _Reminder({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.isUrgent,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool isUrgent;
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({required this.reminder});
  final _Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: reminder.isUrgent
              ? reminder.color.withAlpha(80)
              : AppColors.border1,
          width: reminder.isUrgent ? 1 : 0.5,
        ),
        boxShadow: reminder.isUrgent
            ? [
                BoxShadow(
                  color: reminder.color.withAlpha(25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: reminder.color.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(reminder.icon, size: 18, color: reminder.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder.title,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text1,
                    )),
                const SizedBox(height: 3),
                Text(reminder.subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.text3,
                      height: 1.5,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyReminders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Icon(Icons.check_circle_rounded,
                size: 48, color: AppColors.green),
            const SizedBox(height: 12),
            Text('Всё в порядке',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text1,
                )),
            const SizedBox(height: 6),
            Text('Нет срочных напоминаний',
                style: GoogleFonts.manrope(
                    fontSize: 13, color: AppColors.text3)),
          ],
        ),
      ),
    );
  }
}
