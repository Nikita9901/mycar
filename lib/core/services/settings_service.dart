import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Возможные символы валюты, доступные для выбора.
const List<String> kCurrencyOptions = ['₽', 'BYN', '\$', '€'];

const Map<String, String> kCurrencyLabels = {
  '₽': 'RUB — Российский рубль',
  'BYN': 'BYN — Белорусский рубль',
  '\$': 'USD — Доллар США',
  '€': 'EUR — Евро',
};

/// Сервис для хранения пользовательских настроек в SharedPreferences.
class SettingsService {
  SettingsService(this._prefs) {
    currency = ValueNotifier<String>(_prefs.getString(_keyCurrency) ?? '₽');
  }

  final SharedPreferences _prefs;

  // ── Валюта ───────────────────────────────────────────────────────────────

  static const _keyCurrency = 'currency_symbol';

  /// Реактивный символ валюты. Слушайте через ValueListenableBuilder.
  late final ValueNotifier<String> currency;

  String get currencySymbol => currency.value;

  Future<void> setCurrencySymbol(String symbol) async {
    await _prefs.setString(_keyCurrency, symbol);
    currency.value = symbol;
  }

  // ── Уведомления ───────────────────────────────────────────────────────────

  static const _keyNotifyTO = 'notify_to';
  static const _keyNotifyInsurance = 'notify_insurance';

  bool get notifyTO => _prefs.getBool(_keyNotifyTO) ?? true;

  Future<void> setNotifyTO(bool value) =>
      _prefs.setBool(_keyNotifyTO, value);

  bool get notifyInsurance => _prefs.getBool(_keyNotifyInsurance) ?? true;

  Future<void> setNotifyInsurance(bool value) =>
      _prefs.setBool(_keyNotifyInsurance, value);
}
