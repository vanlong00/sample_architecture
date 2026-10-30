package com.pamg.busmod.ads

import android.content.Context
import android.graphics.drawable.GradientDrawable
import android.text.TextUtils
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.pamg.busmod.R

/**
 * Native copy of Dart's `MoreAppHouseAd`, shared by the AdMob and Yandex
 * factories. It fills exactly the box Flutter gives the platform view: the
 * medium media block takes whatever height the text rows leave.
 *
 * [media] is the network's media view (AdMob and Yandex each require their
 * own class). [legal] adds the labels Yandex requires; AdMob passes `null`.
 */
class HouseAdLayout(
    private val context: Context,
    private val style: HouseAdStyle,
    media: View?,
    val legal: LegalViews?,
) {
    /** Yandex required views. They stay small but visible. */
    class LegalViews(context: Context) {
        val age = TextView(context)
        val sponsored = TextView(context)
        val domain = TextView(context)
        val warning = TextView(context)
        val favicon = ImageView(context)
        val feedback = ImageView(context)
    }

    val icon = ImageView(context).apply { scaleType = ImageView.ScaleType.CENTER_CROP }
    val title = text(style.title, style.colors.title, maxLines = 1)
    val body = text(style.body, style.colors.muted, maxLines = style.bodyLines)
    val cta = text(style.cta, style.colors.onPrimary, maxLines = 1).apply {
        // The house ad CTA reads INSTALL. The SDK writes the ad's own label,
        // so the casing is applied as a transformation instead.
        isAllCaps = true
        gravity = Gravity.CENTER
        val m = style.metrics
        setPadding(m.ctaPaddingH, m.ctaPaddingV, m.ctaPaddingH, m.ctaPaddingV)
        background = box(style.colors.primary, m.radius)
    }

    val root: FrameLayout = FrameLayout(context).apply {
        setBackgroundColor(style.colors.surface)
        layoutParams = ViewGroup.LayoutParams(MATCH, MATCH)
        addView(if (style.medium) mediumBody(media) else compactBody(media), FrameLayout.LayoutParams(MATCH, MATCH))
        addView(corner(), FrameLayout.LayoutParams(WRAP, WRAP, Gravity.TOP or Gravity.END))
    }

    private fun compactBody(media: View?): View {
        val m = style.metrics
        val textColumn = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_VERTICAL
            addView(title)
            addView(body)
            legal?.let { addView(labelRow(it), LinearLayout.LayoutParams(MATCH, WRAP)) }
            legal?.let { addView(it.warning.also { w -> styleLabel(w, maxLines = 1) }) }
        }
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            addView(SquareByHeight(context, m.compactIconMax, m.gap).apply { addView(framed(icon)) }, LinearLayout.LayoutParams(WRAP, MATCH))
            addView(textColumn, LinearLayout.LayoutParams(0, WRAP, 1f).apply { marginStart = m.gap; marginEnd = m.gap })
            addView(cta, LinearLayout.LayoutParams(WRAP, WRAP))
            // Yandex requires a media view even where the strip has no room
            // for one; it stays bound but takes no space.
            media?.let { addView(it, LinearLayout.LayoutParams(0, 0)) }
        }
    }

    private fun mediumBody(media: View?): View {
        val m = style.metrics
        val textColumn = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_VERTICAL
            addView(title)
            addView(body)
        }
        val iconRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            addView(framed(icon), LinearLayout.LayoutParams(m.mediumIcon, m.mediumIcon))
            addView(textColumn, LinearLayout.LayoutParams(0, WRAP, 1f).apply { marginStart = m.gap })
        }
        return LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            val mediaFrame = FrameLayout(context).apply {
                background = box(style.colors.well, m.radius)
                clipToOutline = true
                media?.let { addView(it, FrameLayout.LayoutParams(MATCH, MATCH)) }
            }
            addView(mediaFrame, LinearLayout.LayoutParams(MATCH, 0, 1f))
            addView(iconRow, gapAbove(m.gap))
            legal?.let {
                addView(labelRow(it), gapAbove(m.labelGap))
                styleLabel(it.warning, maxLines = 2)
                addView(it.warning, gapAbove(m.labelGap))
            }
            addView(cta, gapAbove(m.gap))
        }
    }

    /** Sponsored and domain on the left, age on the right. */
    private fun labelRow(legal: LegalViews): View {
        val m = style.metrics
        styleLabel(legal.sponsored, maxLines = 1)
        styleLabel(legal.domain, maxLines = 1)
        styleLabel(legal.age, maxLines = 1)
        val favicon = sp(style.label.size)
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            addView(legal.sponsored, LinearLayout.LayoutParams(WRAP, WRAP).apply { marginEnd = m.labelGap })
            addView(legal.favicon, LinearLayout.LayoutParams(favicon, favicon).apply { marginEnd = m.labelGap })
            addView(legal.domain, LinearLayout.LayoutParams(0, WRAP, 1f))
            addView(legal.age, LinearLayout.LayoutParams(WRAP, WRAP).apply { marginStart = m.labelGap })
        }
    }

    /** The gold AD badge in the corner, with the Yandex feedback button beside it. */
    private fun corner(): View {
        val m = style.metrics
        val badge = text(style.badge, style.colors.onBadge, maxLines = 1).apply {
            text = style.adLabel
            setPadding(m.badgePaddingH, m.badgePaddingV, m.badgePaddingH, m.badgePaddingV)
            background = box(style.colors.badge, m.radius / 2)
        }
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            legal?.feedback?.let {
                it.setImageResource(R.drawable.ic_ad_feedback)
                it.setColorFilter(style.colors.muted)
                val size = m.mediumIcon / 3
                addView(it, LinearLayout.LayoutParams(size, size).apply { marginEnd = m.labelGap })
            }
            addView(badge)
        }
    }

    private fun framed(view: View): View = FrameLayout(context).apply {
        background = box(style.colors.well, style.metrics.radius)
        clipToOutline = true
        addView(view, FrameLayout.LayoutParams(MATCH, MATCH))
    }

    private fun box(fill: Int, radius: Int) = GradientDrawable().apply {
        setColor(fill)
        cornerRadius = radius.toFloat()
    }

    private fun sp(value: Float): Int =
        TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, value, context.resources.displayMetrics).toInt()

    private fun gapAbove(gap: Int) = LinearLayout.LayoutParams(MATCH, WRAP).apply { topMargin = gap }

    private fun styleLabel(view: TextView, maxLines: Int) {
        apply(view, style.label, style.colors.muted, maxLines)
    }

    private fun text(text: HouseAdStyle.Text, color: Int, maxLines: Int) =
        TextView(context).also { apply(it, text, color, maxLines) }

    private fun apply(view: TextView, text: HouseAdStyle.Text, color: Int, maxLines: Int) {
        view.setTextColor(color)
        view.setTextSize(TypedValue.COMPLEX_UNIT_SP, text.size)
        text.typeface?.let { view.typeface = it }
        view.maxLines = maxLines
        view.ellipsize = TextUtils.TruncateAt.END
        view.includeFontPadding = false
    }

    /**
     * Square cell as tall as the strip minus [inset] above and below, capped at
     * [max]. Mirrors the house ad's `(height - 2 * gap).clamp(0, compactIconMax)`.
     */
    private class SquareByHeight(context: Context, private val max: Int, private val inset: Int) :
        FrameLayout(context) {
        override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
            val height = MeasureSpec.getSize(heightMeasureSpec)
            val side = (height - 2 * inset).coerceIn(0, max)
            val exact = MeasureSpec.makeMeasureSpec(side, MeasureSpec.EXACTLY)
            for (i in 0 until childCount) getChildAt(i).measure(exact, exact)
            setMeasuredDimension(side, height)
        }

        override fun onLayout(changed: Boolean, left: Int, top: Int, right: Int, bottom: Int) {
            val top0 = (bottom - top - measuredWidth) / 2
            for (i in 0 until childCount) getChildAt(i).layout(0, top0, measuredWidth, top0 + measuredWidth)
        }
    }

    private companion object {
        const val MATCH = ViewGroup.LayoutParams.MATCH_PARENT
        const val WRAP = ViewGroup.LayoutParams.WRAP_CONTENT
    }
}
