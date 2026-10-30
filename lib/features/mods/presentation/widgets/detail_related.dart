import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/mod_image.dart';
import '../../data/models/mod_card.dart';

/// Horizontal strip of compact related cards. Hidden when [related] is empty.
/// Title: "More from `name`" or "More like this".
class DetailRelated extends StatelessWidget {
  const DetailRelated({
    required this.related,
    this.manufacturerName,
    super.key,
  });

  final List<ModCard> related;
  final String? manufacturerName;

  @override
  Widget build(BuildContext context) {
    if (related.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final name = manufacturerName;
    final title = name == null || name.trim().isEmpty
        ? l10n.detailMoreLike
        : l10n.detailMoreFrom(name);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Semantics(
            header: true,
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        const SizedBox(height: 8),
        // ponytail: Row in a scroll view (not lazy) — related lists are short.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final c in related) _RelatedCard(card: c)],
          ),
        ),
      ],
    );
  }
}

class _RelatedCard extends StatelessWidget {
  const _RelatedCard({required this.card});

  final ModCard card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 200,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: () => context.push(Routes.modDetailOf(card.sourceId)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ModImage(url: card.thumbnail),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  card.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
