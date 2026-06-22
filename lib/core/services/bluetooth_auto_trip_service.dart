import 'package:shared_preferences/shared_preferences.dart';

const _keyCarAddress = 'bt_car_device_address';
const _keyCarName = 'bt_car_device_name';
const _keyAutoTripEnabled = 'bt_auto_trip_enabled';
const _keyTripStartRequested = 'bt_trip_start_requested';
const _keyTripStopRequested = 'bt_trip_stop_requested';
const _keyPendingAddress = 'bt_pending_device_address';
const _keyPendingName = 'bt_pending_device_name';

typedef BtPendingDevice = ({String address, String name});

class BluetoothAutoTripService {
  BluetoothAutoTripService._();
  static final BluetoothAutoTripService instance = BluetoothAutoTripService._();

  Future<bool> get isEnabled async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoTripEnabled) ?? false;
  }

  Future<String?> get linkedDeviceName async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCarName);
  }

  Future<void> saveCarDevice(String address, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCarAddress, address);
    await prefs.setString(_keyCarName, name);
    await prefs.setBool(_keyAutoTripEnabled, true);
    await prefs.remove(_keyPendingAddress);
    await prefs.remove(_keyPendingName);
  }

  Future<void> removeCarDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCarAddress);
    await prefs.remove(_keyCarName);
    await prefs.setBool(_keyAutoTripEnabled, false);
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoTripEnabled, value);
  }

  /// Устройство, подключившееся впервые — ждёт подтверждения пользователя.
  Future<BtPendingDevice?> getPendingDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.getString(_keyPendingAddress);
    final name = prefs.getString(_keyPendingName);
    if (address != null && name != null) return (address: address, name: name);
    return null;
  }

  Future<void> clearPendingDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPendingAddress);
    await prefs.remove(_keyPendingName);
  }

  Future<bool> checkAndClearStartRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final requested = prefs.getBool(_keyTripStartRequested) ?? false;
    if (requested) await prefs.remove(_keyTripStartRequested);
    return requested;
  }

  Future<bool> checkAndClearStopRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final requested = prefs.getBool(_keyTripStopRequested) ?? false;
    if (requested) await prefs.remove(_keyTripStopRequested);
    return requested;
  }
}
