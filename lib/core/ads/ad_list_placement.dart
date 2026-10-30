/// Row layout that inserts ad slots into a list periodically: the first slot
/// after [firstSlot] items, then one slot every [interval] items.
///
/// Lives outside the widget because this is the most error-prone part of
/// inserting ads into a list. An item's index must subtract the number of ad
/// slots before it. Off by one, the list shows the wrong pack or reads past
/// the end of the array.
class AdListPlacement {
  const AdListPlacement({
    this.firstSlot = 3,
    this.interval = 10,
    this.poolSize = 3,
    this.enabled = true,
  }) : assert(firstSlot >= 0, 'firstSlot phải >= 0'),
       assert(interval > 0, 'interval phải > 0'),
       assert(poolSize > 0, 'poolSize phải > 0');

  /// When `false`, the list inserts no ad slots: [isAd] is always `false`,
  /// and [rowCount] and [itemIndexOf] become identity mappings.
  ///
  /// Disable ads here, not where the widget is built. Every index calculation
  /// goes through this class, so one flag here turns off all three together
  /// (row count, index shift, ad slot detection). Disabling at the call site
  /// means remembering to change all three places.
  final bool enabled;

  /// Number of real items before the first ad slot.
  final int firstSlot;

  /// Number of real items between two ad slots.
  final int interval;

  /// Number of controllers (ads) that rotate across the slots of one list.
  ///
  /// The slots do not share one ad: the same ad object must never be in two
  /// `AdWidget`s at once. Slots are [interval] items apart, so they are
  /// rarely in the viewport together. During a fast scroll, though, the new
  /// slot mounts before the old one unmounts. Rotating a few ads avoids the
  /// collision.
  final int poolSize;

  /// Distance between two ad slots in row indexes (ad rows included).
  int get _period => interval + 1;

  bool isAd(int index) =>
      enabled && index >= firstSlot && (index - firstSlot) % _period == 0;

  /// Number of ad slots before row [index], including [index] itself when it
  /// is an ad row.
  int _adsBefore(int index) =>
      !enabled || index < firstSlot ? 0 : (index - firstSlot) ~/ _period + 1;

  /// Returns the index into the real item list for a row that is not an ad.
  int itemIndexOf(int index) => index - _adsBefore(index);

  /// Returns which ad in the pool the ad row at [index] uses.
  int poolIndexOf(int index) => (index - firstSlot) ~/ _period % poolSize;

  /// Returns the total number of rows to build for [itemCount] real items.
  ///
  /// An ad slot is never the last row: a new slot is inserted only when at
  /// least one real item follows it.
  int rowCount(int itemCount) {
    if (!enabled) return itemCount;
    if (itemCount <= firstSlot) return itemCount;
    return itemCount + 1 + (itemCount - firstSlot - 1) ~/ interval;
  }
}
