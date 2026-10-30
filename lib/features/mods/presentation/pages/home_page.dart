import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../data/models/mod_type.dart';
import '../widgets/mod_list_tab.dart';
import '../widgets/mod_type_label.dart';

/// Home: one tab per [ModType] (enum order), each an independent list.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: ModType.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navHome),
          bottom: TabBar(
            tabs: [
              for (final t in ModType.values) Tab(text: modTypeLabel(t, l10n)),
            ],
          ),
        ),
        body: TabBarView(
          children: [for (final t in ModType.values) ModListTab(type: t)],
        ),
      ),
    );
  }
}
