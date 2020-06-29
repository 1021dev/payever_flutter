package org.payever.app;

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.app.FlutterActivity
import org.payever.app.taponphone.activity.HomeActivity

class MainActivity : FlutterActivity() {

    private val CHANNEL = "payever.flutter.dev/tapthephone"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(flutterView.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "showNativeView") {
                val intent = Intent(this, HomeActivity::class.java)
                startActivity(intent)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

}