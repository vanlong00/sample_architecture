import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/mod_image.dart';
import '../../../mods/presentation/widgets/mod_type_label.dart';
import '../../data/models/favorite_record.dart';

/// List row for a saved [FavoriteRecord]; renders fully from the snapshot.
class FavoriteTile extends StatelessWidget {
  const FavoriteTile({
    required this.record,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final FavoriteRecord record;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ModImage(url: record.thumbUrl),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          modTypeLabel(record.type, l10n),
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    tooltip: l10n.favoriteRemoveSemantics(record.title),
                    icon: Icon(
                      Icons.favorite,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
