package com.pamg.busmod.ads

import android.content.Context
import android.graphics.Typeface
import android.util.TypedValue

/**
 * Look of the native ad cell, parsed from the `customOptions` that Dart's
 * `nativeAdOptions()` builds from the app theme. The defaults here are only
 * fallbacks for a missing key; the Dart theme is the source of truth.
 */
class HouseAdStyle private constructor(
    val medium: Boolean,
    val adLabel: String,
    val colors: Colors,
    val metrics: Metrics,
    val bodyLines: Int,
    val title: Text,
    val body: Text,
    val cta: Text,
    val badge: Text,
    val label: Text,
) {
    class Colors(
        val surface: Int,
        val well: Int,
        val border: Int,
        val primary: Int,
        val onPrimary: Int,
        val title: Int,
        val muted: Int,
        val badge: Int,
        val onBadge: Int,
    )

    /** Every value is in px, converted from Dart logical pixels. */
    class Metrics(
        val gap: Int,
        val radius: Int,
        val ctaPaddingH: Int,
        val ctaPaddingV: Int,
        val badgePaddingH: Int,
        val badgePaddingV: Int,
        val compactIconMax: Int,
        val mediumIcon: Int,
        val labelGap: Int,
    )

    /** [size] in sp. */
    class Text(val bold: Boolean, val size: Float) {
        val typeface: Typeface? get() = if (bold) Typeface.DEFAULT_BOLD else null
    }

    companion object {
        fun parse(context: Context, options: Map<*, *>?): HouseAdStyle {
            val colors = options?.get("colors") as? Map<*, *>
            val metrics = options?.get("metrics") as? Map<*, *>
            val text = options?.get("text") as? Map<*, *>
            fun color(key: String, fallback: Long) =
                ((colors?.get(key) as? Number)?.toLong() ?: fallback).toInt()
            fun px(key: String, fallback: Double) =
                dp(context, (metrics?.get(key) as? Number)?.toDouble() ?: fallback)
            fun style(key: String, fallbackSize: Double) =
                parseText(text?.get(key) as? Map<*, *>, fallbackSize)

            return HouseAdStyle(
                medium = options?.get("template") == "medium",
                adLabel = options?.get("adLabel") as? String ?: "Ad",
                colors = Colors(
                    surface = color("surface", 0xFFECE6F0),
                    well = color("well", 0xFFE6E0E9),
                    border = color("border", 0xFFCAC4D0),
                    primary = color("primary", 0xFF3366FF),
                    onPrimary = color("onPrimary", 0xFFFFFFFF),
                    title = color("title", 0xFF1D1B20),
                    muted = color("muted", 0xFF49454F),
                    badge = color("badge", 0xFF7D5260),
                    onBadge = color("onBadge", 0xFFFFFFFF),
                ),
                metrics = Metrics(
                    gap = px("gap", 8.0),
                    radius = px("radius", 12.0),
                    ctaPaddingH = px("ctaPaddingH", 12.0),
                    ctaPaddingV = px("ctaPaddingV", 6.0),
                    badgePaddingH = px("badgePaddingH", 6.0),
                    badgePaddingV = px("badgePaddingV", 1.0),
                    compactIconMax = px("compactIconMax", 64.0),
                    mediumIcon = px("mediumIcon", 52.0),
                    labelGap = px("labelGap", 4.0),
                ),
                bodyLines = (options?.get("bodyLines") as? Number)?.toInt() ?: 1,
                title = style("title", 14.0),
                body = style("body", 12.0),
                cta = style("cta", 12.0),
                badge = style("badge", 11.0),
                label = style("label", 10.0),
            )
        }

        private fun parseText(map: Map<*, *>?, fallbackSize: Double) = Text(
            bold = map?.get("bold") as? Boolean ?: false,
            size = ((map?.get("size") as? Number)?.toDouble() ?: fallbackSize).toFloat(),
        )

        fun dp(context: Context, value: Double): Int = TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            value.toFloat(),
            context.resources.displayMetrics,
        ).toInt()
    }
}
