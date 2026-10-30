import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/presentation/widgets/mod_paged_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ModCard card(int id) => ModCard(sourceId: id, type: ModType.bus, title: 't$id');

void main() {
  testWidgets(
    'load-more trigger re-arms after a request that added no visible item',
    (t) async {
      final items = [card(1), card(2)]; // same list: page was fully filtered
      var requests = 0;
      Future<void> pump({required bool loadingMore}) => t.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ModPagedList(
              items: items,
              hasMore: true,
              loadingMore: loadingMore,
              onLoadMore: () => requests++,
              onRefresh: () async {},
              onTap: (_) {},
            ),
          ),
        ),
      );

      await pump(loadingMore: false);
      await t.pump();
      expect(requests, 1);

      await pump(loadingMore: false); // rebuild before the cubit reacts
      await t.pump();
      expect(requests, 1, reason: 'not requested twice for the same page');

      await pump(loadingMore: true);
      await t.pump();
      await pump(loadingMore: false); // finished, items unchanged
      await t.pump();
      expect(requests, 2, reason: 'next page must be requested again');
    },
  );
}
