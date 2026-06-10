import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/trip_tracking_cubit.dart';
import '../bloc/trip_tracking_state.dart';

/// Кнопка запуска поездки — показывается на главном экране.
class StartTripButton extends StatelessWidget {
  const StartTripButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripTrackingCubit, TripTrackingState>(
      listenWhen: (_, curr) =>
          curr is TripPermissionDenied,
      listener: (context, state) {
        if (state is TripPermissionDenied) {
          _showPermissionDialog(context, state.isPermanent);
        }
      },
      buildWhen: (prev, curr) =>
          (prev is TripInProgress || prev is TripRequestingPermission) !=
          (curr is TripInProgress || curr is TripRequestingPermission),
      builder: (context, state) {
        final isActive = state is TripInProgress;
        final isLoading = state is TripRequestingPermission;

        // Когда поездка идёт — кнопка скрыта (показан баннер)
        if (isActive) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: GestureDetector(
            onTap: isLoading
                ? null
                : () => context.read<TripTrackingCubit>().startTrip(),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.bg2,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border1, width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.green,
                      ),
                    )
                  else
                    Icon(
                      Icons.navigation_rounded,
                      size: 20,
                      color: AppColors.green,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    isLoading ? 'Получение GPS...' : 'Начать поездку',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text1,
                    ),
                  ),
                ],
              ),
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Нужен доступ к геолокации',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            color: AppColors.text1,
          ),
        ),
        content: Text(
          isPermanent
              ? 'Доступ к геолокации запрещён. Откройте настройки приложения и разрешите «Местоположение».'
              : 'Для записи пробега нужно разрешить доступ к геолокации.',
          style:
              GoogleFonts.manrope(fontSize: 14, color: AppColors.text2),
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
