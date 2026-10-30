package com.pamg.busmod

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Sends a downloaded mod file to PBSU: ACTION_VIEW on a FileProvider content:// uri,
 * pinned to PBSU's package. Failures go back to Dart as channel errors (never swallowed)
 * so the app can fall back to the system chooser.
 */
class PbsuLauncher(private val context: Context) : MethodChannel.MethodCallHandler {
    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isInstalled" -> {
                val pkg = call.argument<String>("packageName")
                if (pkg == null) result.error("BAD_ARGS", "packageName is required", null)
                else result.success(isInstalled(pkg))
            }
            "launch" -> {
                val path = call.argument<String>("path")
                val mime = call.argument<String>("mime")
                val pkg = call.argument<String>("packageName")
                if (path == null || mime == null || pkg == null) {
                    result.error("BAD_ARGS", "path, mime and packageName are required", null)
                } else {
                    launch(path, mime, pkg, result)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun isInstalled(packageName: String): Boolean =
        try {
            context.packageManager.getPackageInfo(packageName, 0)
            true
        } catch (_: PackageManager.NameNotFoundException) {
            false
        }

    private fun launch(path: String, mime: String, packageName: String, result: MethodChannel.Result) {
        try {
            val uri = FileProvider.getUriForFile(context, "${context.packageName}.provider", File(path))
            val intent = Intent(Intent.ACTION_VIEW)
                .setDataAndType(uri, mime)
                .setPackage(packageName)
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            result.success(null)
        } catch (e: ActivityNotFoundException) {
            result.error("ACTIVITY_NOT_FOUND", e.message, null)
        } catch (e: Exception) {
            result.error("LAUNCH_FAILED", e.message ?: e.javaClass.simpleName, null)
        }
    }

    companion object {
        const val CHANNEL = "com.pamg.busmod/pbsu"
    }
}
