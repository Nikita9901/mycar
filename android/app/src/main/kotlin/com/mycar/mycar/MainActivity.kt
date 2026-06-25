package com.mycar.mycar

import android.bluetooth.BluetoothManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.mycar.mycar/bluetooth"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getPairedDevices" -> {
                        try {
                            val btManager =
                                getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
                            val adapter = btManager?.adapter
                            if (adapter == null || !adapter.isEnabled) {
                                result.success(emptyList<Map<String, String>>())
                                return@setMethodCallHandler
                            }
                            @Suppress("MissingPermission")
                            val devices = adapter.bondedDevices?.map { device ->
                                mapOf(
                                    "name" to (try {
                                        @Suppress("MissingPermission") device.name ?: "Unknown"
                                    } catch (_: SecurityException) { "Unknown" }),
                                    "address" to (device.address ?: "")
                                )
                            } ?: emptyList()
                            result.success(devices)
                        } catch (e: Exception) {
                            result.error("BT_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
