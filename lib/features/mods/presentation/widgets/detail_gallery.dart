import 'package:flutter/material.dart';

import '../../../../core/widgets/mod_image.dart';
import '../../data/models/mod_card.dart';

/// Swipeable 16:9 gallery with page dots. No media -> a single placeholder.
class DetailGallery extends StatefulWidget {
  const DetailGallery({required this.media, super.key});

  final ModMedia? media;

  @override
  State<DetailGallery> createState() => _DetailGalleryState();
}

class _DetailGalleryState extends State<DetailGallery> {
  final _page = ValueNotifier<int>(0);

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  List<String> get _urls {
    final media = widget.media;
    if (media == null) return const [];
    final images = media.images.where((u) => u.isNotEmpty).toList();
    if (images.isNotEmpty) return images;
    final thumb = media.thumbnail;
    return thumb == null || thumb.isEmpty ? const [] : [thumb];
  }

  @override
  Widget build(BuildContext context) {
    final urls = _urls;
    if (urls.isEmpty) {
      return const AspectRatio(aspectRatio: 16 / 9, child: ModImage(url: null));
    }
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: urls.length,
            onPageChanged: (i) => _page.value = i,
            itemBuilder: (_, i) => ModImage(url: urls[i]),
          ),
          if (urls.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: _Dots(count: urls.length, page: _page),
            ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.page});

  final int count;
  final ValueNotifier<int> page;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: ValueListenableBuilder<int>(
        valueListenable: page,
        builder: (_, current, _) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < count; i++)
              Container(
                key: ValueKey('dot_$i'),
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == current
                      ? scheme.primary
                      : scheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
