package com.pamg.busmod.ads

import android.content.Context
import android.util.Log
import android.view.View
import com.example.yandex_native_custom.YandexNativeCustomPlugin
import com.yandex.mobile.ads.common.AdBindingResult
import com.yandex.mobile.ads.nativeads.MediaView
import com.yandex.mobile.ads.nativeads.NativeAd
import com.yandex.mobile.ads.nativeads.NativeAdView
import com.yandex.mobile.ads.nativeads.NativeAdViewBinder

/**
 * Yandex native ad drawn with [HouseAdLayout], plus the views Yandex requires
 * (age, domain, feedback, sponsored, warning). Registered as
 * `busmodNativeYandex`.
 */
class YandexNativeAdFactory(private val context: Context) : YandexNativeCustomPlugin.NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd?, customOptions: Map<String?, Any?>?): NativeAdView? {
        val ad = nativeAd ?: return null
        val style = HouseAdStyle.parse(context, customOptions)
        val media = MediaView(context)
        val legal = HouseAdLayout.LegalViews(context)
        val layout = HouseAdLayout(context, style, media, legal)
        val view = NativeAdView(context).apply { addView(layout.root) }
        val assets = ad.adAssets
        legal.warning.visibility = if (assets.warning == null) View.GONE else View.VISIBLE
        legal.favicon.visibility = if (assets.favicon == null) View.GONE else View.VISIBLE
        val binder = NativeAdViewBinder.Builder(view)
            .setAgeView(legal.age)
            .setBodyView(layout.body)
            .setCallToActionView(layout.cta)
            .setDomainView(legal.domain)
            .setFaviconView(legal.favicon)
            .setFeedbackView(legal.feedback)
            .setIconView(layout.icon)
            .setMediaView(media)
            .setSponsoredView(legal.sponsored)
            .setTitleView(layout.title)
            .setWarningView(legal.warning)
            .build()
        return when (val result = ad.bindNativeAd(binder)) {
            is AdBindingResult.Success -> view
            is AdBindingResult.Failure -> {
                Log.e("YandexNativeAdFactory", "bind fail: ${result.exception.message}")
                view
            }
        }
    }
}
