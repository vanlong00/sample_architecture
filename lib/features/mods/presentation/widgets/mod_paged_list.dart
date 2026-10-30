import 'package:flutter/material.dart';

import '../../../../core/ads/ad_list_placement.dart';
import '../../../../core/ads/ads_service.dart';
import '../../../../core/ads/controllers/native_ad_controller.dart';
import '../../../../core/ads/widgets/native_ad_view.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/load_more_footer.dart';
import '../../data/models/mod_card.dart';
import 'mod_card_tile.dart';

/// Paged, pull-to-refresh list of [ModCard]s with optional native ad rows.
class ModPagedList extends StatefulWidget {
  const ModPagedList({
    required this.items,
    required this.hasMore,
    required this.loadingMore,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onTap,
    this.loadMoreFailure,
    this.adSlot,
    this.emptyText,
    this.trailingBuilder,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  final List<ModCard> items;
  final bool hasMore;
  final bool loadingMore;
  final Object? loadMoreFailure;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final void Function(ModCard) onTap;

  /// Native ads are inserted only when this is set and list ads are enabled.
  final NativeAdSlot? adSlot;
  final String? emptyText;
  final Widget? Function(ModCard)? trailingBuilder;
  final EdgeInsetsGeometry padding;

  @override
  State<ModPagedList> createState() => _ModPagedListState();
}

class _ModPagedListState extends State<ModPagedList> {
  static const _threshold = 3;

  /// Item count for which a load was already requested, so rebuilds before
  /// the cubit flips `loadingMore` do not fire it again.
  int _requestedAt = -1;

  @override
  void didUpdateWidget(ModPagedList old) {
    super.didUpdateWidget(old);
    // A finished request (even one that added nothing visible: its page was
    // all filtered out) or a new list re-arms the trigger.
    if ((old.loadingMore && !widget.loadingMore) ||
        !identical(old.items, widget.items)) {
      _requestedAt = -1;
    }
  }

  void _maybeLoadMore(int itemIndex) {
    final w = widget;
    if (!w.hasMore || w.loadingMore || w.loadMoreFailure != null) return;
    if (itemIndex < w.items.length - _threshold) return;
    if (_requestedAt == w.items.length) return;
    _requestedAt = w.items.length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onLoadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final Widget list;
    if (w.items.isEmpty) {
      list = LayoutBuilder(
        builder: (context, c) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: c.maxHeight,
              child: Center(
                child: Text(
                  w.emptyText ?? context.l10n.listEmpty,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      final slot = w.adSlot;
      final placement = AdListPlacement(
        enabled:
            slot != null && maybeAdsService()?.listNativeAdsEnabled == true,
      );
      final rows = placement.rowCount(w.items.length);
      final hasFooter = w.loadingMore || w.loadMoreFailure != null;
      list = ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: w.padding,
        itemCount: rows + (hasFooter ? 1 : 0),
        itemBuilder: (context, row) {
          if (row >= rows) {
            return LoadMoreFooter(
              loading: w.loadingMore,
              error: w.loadMoreFailure,
              onRetry: w.onLoadMore,
            );
          }
          if (placement.isAd(row)) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: NativeAdView.maxWidth,
                ),
                child: NativeAdView(
                  key: ValueKey('ad_$row'),
                  slot: slot!,
                  poolIndex: placement.poolIndexOf(row),
                ),
              ),
            );
          }
          final index = placement.itemIndexOf(row);
          _maybeLoadMore(index);
          final card = w.items[index];
          return Padding(
            key: ValueKey(card.sourceId),
            padding: const EdgeInsets.only(bottom: 8),
            child: ModCardTile(
              card: card,
              onTap: () => w.onTap(card),
              trailing: w.trailingBuilder?.call(card),
            ),
          );
        },
      );
    }
    return RefreshIndicator(onRefresh: w.onRefresh, child: list);
  }
}
