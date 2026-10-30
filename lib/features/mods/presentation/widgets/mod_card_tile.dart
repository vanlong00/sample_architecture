import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/mod_image.dart';
import '../../data/models/mod_card.dart';
import 'mod_type_label.dart';

/// List row for a [ModCard]: 16:9 thumbnail, title, manufacturer, type, size
/// and download count. Only reads `thumbnail`, never a download URL.
class ModCardTile extends StatelessWidget {
  const ModCardTile({
    required this.card,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final ModCard card;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final size = card.download?.sizeBytes;
    final downloads = card.stats?.downloads;
    final meta = [
      modTypeLabel(card.type, l10n),
      ?(size == null ? null : formatBytes(size)),
    ].join(' · ');

    // InkWell's tap node merges the text labels below it; a `trailing` button
    // keeps its own semantics node.
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ModImage(url: card.thumbnail),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        if (card.manufacturer?.name case final name?)
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(meta, style: theme.textTheme.labelMedium),
                            if (downloads != null) _Downloads(count: downloads),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Downloads extends StatelessWidget {
  const _Downloads({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.download_outlined,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 2),
        Text('$count', style: theme.textTheme.labelMedium),
      ],
    );
  }
}
