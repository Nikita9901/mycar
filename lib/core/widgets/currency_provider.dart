import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../services/settings_service.dart';

/// InheritedNotifier, который пробрасывает [SettingsService.currency]
/// вниз по дереву. Любой виджет может подписаться через [CurrencyProvider.of].
class CurrencyProvider extends InheritedNotifier<ValueNotifier<String>> {
  CurrencyProvider({
    super.key,
    required SettingsService settings,
    required super.child,
  }) : super(notifier: settings.currency);

  /// Возвращает текущий символ валюты и подписывает виджет на обновления.
  static String of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CurrencyProvider>();
    return provider?.notifier?.value ?? '₽';
  }
}
