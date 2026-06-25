import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/di/injection_container.dart';
import 'core/services/settings_service.dart';
import 'core/services/trip_background_service.dart';
import 'core/services/trip_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/currency_provider.dart';
import 'app/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU');
  await initDependencies();
  await TripNotificationService.instance.init();
  await initializeTripBackgroundService();
  runApp(const MyCarApp());
}

class MyCarApp extends StatelessWidget {
  const MyCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CurrencyProvider(
      settings: sl<SettingsService>(),
      child: MaterialApp(
        title: 'MyCar',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ru', 'RU'),
        supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: buildAppTheme(),
        home: const MainScreen(),
      ),
    );
  }
}
