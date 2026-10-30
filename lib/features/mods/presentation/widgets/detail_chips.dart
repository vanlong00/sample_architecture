import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../data/models/mod_detail.dart';
import 'mod_type_label.dart';

/// Type + category + manufacturer + country chips; null/blank ones are skipped.
class DetailChips extends StatelessWidget {
  const DetailChips({required this.mod, super.key});

  final ModDetail mod;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      modTypeLabel(mod.type, l10n),
      for (final name in [
        mod.category?.name,
        mod.manufacturer?.name,
        mod.country?.name,
      ])
        if (name != null && name.trim().isNotEmpty) name,
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final l in labels) Chip(label: Text(l))],
    );
  }
}
