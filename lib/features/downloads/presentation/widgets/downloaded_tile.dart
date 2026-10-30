import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/mod_image.dart';
import '../../data/models/mod_download_record.dart';
import 'import_action.dart';

/// Row for a downloaded mod; renders fully from the snapshot (offline-safe).
class DownloadedTile extends StatelessWidget {
  const DownloadedTile({
    required this.record,
    required this.onImport,
    required this.onDelete,
    this.missing = false,
    super.key,
  });

  final ModDownloadRecord record;
  final Future<void> Function() onImport;
  final VoidCallback onDelete;

  /// The file is gone from disk (found out on Import): only delete is left.
  final bool missing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 112,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ModImage(url: record.thumbUrl),
                ),
              ),
            ),
            const SizedBox(width: 12),
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
                    '${record.extension.toUpperCase()} · '
                    '${formatBytes(record.sizeBytes)}',
                    style: theme.textTheme.labelMedium,
                  ),
                  if (missing)
                    Text(
                      l10n.ctaFileMissing,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ImportGuard(
                            run: onImport,
                            builder: (_, onPressed) => FilledButton.tonal(
                              onPressed: missing ? null : onPressed,
                              child: Text(
                                l10n.ctaImport,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        tooltip: l10n.deleteModSemantics(record.title),
                        icon: Icon(
                          Icons.delete_outline,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
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
