package com.pamg.busmod

import com.example.yandex_native_custom.YandexNativeCustomPlugin
import com.pamg.busmod.ads.AdmobNativeAdFactory
import com.pamg.busmod.ads.YandexNativeAdFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {
    // The ids must match NativeAdFactoryIds in lib/core/ads/native_ad_template.dart.
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, ADMOB_FACTORY, AdmobNativeAdFactory(this))
        YandexNativeCustomPlugin.registerNativeAdFactory(flutterEngine, YANDEX_FACTORY, YandexNativeAdFactory(this))
        PbsuLauncher(this).register(flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, ADMOB_FACTORY)
        YandexNativeCustomPlugin.unregisterNativeAdFactory(flutterEngine, YANDEX_FACTORY)
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private companion object {
        const val ADMOB_FACTORY = "busmodNativeAdmob"
        const val YANDEX_FACTORY = "busmodNativeYandex"
    }
}
