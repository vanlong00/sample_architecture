package com.pamg.busmod.ads

import android.content.Context
import android.widget.ImageView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.NativeAdFactory

/** AdMob native ad drawn with [HouseAdLayout]. Registered as `busmodNativeAdmob`. */
class AdmobNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val style = HouseAdStyle.parse(context, customOptions)
        // Small has no room for media; AdMob then serves image assets only.
        val media = if (style.medium) {
            MediaView(context).apply { setImageScaleType(ImageView.ScaleType.CENTER_CROP) }
        } else {
            null
        }
        val layout = HouseAdLayout(context, style, media, legal = null)
        return NativeAdView(context).apply {
            addView(layout.root)
            headlineView = layout.title
            bodyView = layout.body
            callToActionView = layout.cta
            iconView = layout.icon
            mediaView = media
            layout.title.text = nativeAd.headline
            layout.body.text = nativeAd.body
            layout.cta.text = nativeAd.callToAction
            layout.icon.setImageDrawable(nativeAd.icon?.drawable)
            setNativeAd(nativeAd)
        }
    }
}
