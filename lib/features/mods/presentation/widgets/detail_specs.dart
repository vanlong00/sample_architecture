import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../data/models/mod_detail.dart';

/// Specs grouped by the server's `group` (first-seen order). Hidden if empty.
class DetailSpecs extends StatelessWidget {
  const DetailSpecs({required this.specs, super.key});

  final List<ModSpec> specs;

  @override
  Widget build(BuildContext context) {
    if (specs.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            context.l10n.detailSpecs,
            style: theme.textTheme.titleMedium,
          ),
        ),
        for (final (group, rows) in groupSpecs(specs))
          _SpecGroup(group: group, rows: rows),
      ],
    );
  }
}

class _SpecGroup extends StatelessWidget {
  const _SpecGroup({required this.group, required this.rows});

  final String group;
  final List<ModSpec> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          for (final r in rows) _SpecRow(spec: r),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.spec});

  final ModSpec spec;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                spec.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                spec.value,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
