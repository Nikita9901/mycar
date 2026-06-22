package com.mycar.mycar

import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BluetoothReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return

        @Suppress("DEPRECATION")
        val device = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
            ?: return

        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val carAddress = prefs.getString("flutter.bt_car_device_address", null)
        val autoTripEnabled = prefs.getBoolean("flutter.bt_auto_trip_enabled", false)

        when (action) {
            BluetoothDevice.ACTION_ACL_CONNECTED -> {
                val deviceAddress = device.address ?: return
                val deviceName = try { device.name } catch (_: SecurityException) { null }
                    ?: "Bluetooth устройство"

                if (autoTripEnabled && carAddress != null && deviceAddress == carAddress) {
                    // Это наш автомобиль — просим запустить поездку
                    prefs.edit()
                        .putBoolean("flutter.bt_trip_start_requested", true)
                        .apply()
                    launchApp(context)
                } else if (carAddress == null) {
                    // Неизвестное устройство — предлагаем привязать
                    prefs.edit()
                        .putString("flutter.bt_pending_device_address", deviceAddress)
                        .putString("flutter.bt_pending_device_name", deviceName)
                        .apply()
                    launchApp(context)
                }
            }

            BluetoothDevice.ACTION_ACL_DISCONNECTED -> {
                val deviceAddress = device.address ?: return
                if (autoTripEnabled && carAddress != null && deviceAddress == carAddress) {
                    prefs.edit()
                        .putBoolean("flutter.bt_trip_stop_requested", true)
                        .apply()
                    // Не запускаем приложение — если оно открыто, таймер поймает флаг
                }
            }
        }
    }

    private fun launchApp(context: Context) {
        val intent = Intent(context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        context.startActivity(intent)
    }
}
