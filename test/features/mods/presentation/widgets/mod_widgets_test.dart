import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/presentation/widgets/mod_card_tile.dart';
import 'package:busmod/features/mods/presentation/widgets/mod_paged_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget app(Widget home) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('en'),
  home: Scaffold(body: home),
);

ModCard card(int i) => ModCard(
  sourceId: i,
  type: ModType.bus,
  title: 'Mod $i',
  manufacturer: const ModRef(id: 'm', name: 'Volvo'),
  download: const ModDownload(sizeBytes: 5 * 1048576),
  stats: const ModStats(downloads: 42),
);

void main() {
  testWidgets('ModCardTile shows info and fires onTap', (t) async {
    var taps = 0;
    await t.pumpWidget(app(ModCardTile(card: card(1), onTap: () => taps++)));
    expect(find.text('Mod 1'), findsOneWidget);
    expect(find.text('Volvo'), findsOneWidget);
    expect(find.textContaining('Bus'), findsOneWidget);
    expect(find.textContaining('5.0 MB'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    await t.tap(find.byType(ModCardTile));
    expect(taps, 1);
  });

  group('ModPagedList', () {
    Widget list({
      List<ModCard>? items,
      bool hasMore = true,
      bool loadingMore = false,
      Object? failure,
      VoidCallback? onLoadMore,
      String? emptyText,
    }) => app(
      ModPagedList(
        items: items ?? [for (var i = 0; i < 30; i++) card(i)],
        hasMore: hasMore,
        loadingMore: loadingMore,
        loadMoreFailure: failure,
        onLoadMore: onLoadMore ?? () {},
        onRefresh: () async {},
        onTap: (_) {},
        emptyText: emptyText,
      ),
    );

    testWidgets('renders items without ad rows when adSlot is null', (t) async {
      await t.pumpWidget(list());
      expect(find.byType(ModCardTile), findsWidgets);
      expect(find.text('Mod 0'), findsOneWidget);
    });

    testWidgets('onLoadMore not fired at the top', (t) async {
      var loads = 0;
      await t.pumpWidget(list(onLoadMore: () => loads++));
      await t.pump();
      expect(loads, 0);
    });

    testWidgets('fires onLoadMore once near the end', (t) async {
      var loads = 0;
      await t.pumpWidget(list(onLoadMore: () => loads++));
      await t.drag(find.byType(ListView), const Offset(0, -20000));
      await t.pump();
      await t.pump();
      expect(loads, 1);
      await t.drag(find.byType(ListView), const Offset(0, -20000));
      await t.pump();
      expect(loads, 1);
    });

    testWidgets('does not fire while loadingMore or on failure', (t) async {
      var loads = 0;
      await t.pumpWidget(list(loadingMore: true, onLoadMore: () => loads++));
      await t.drag(find.byType(ListView), const Offset(0, -20000));
      await t.pump();
      expect(loads, 0);
      await t.pumpWidget(list(failure: 'x', onLoadMore: () => loads++));
      await t.pump();
      expect(loads, 0);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('empty state shows default and custom text', (t) async {
      await t.pumpWidget(list(items: const []));
      expect(find.text('Nothing here yet'), findsOneWidget);
      await t.pumpWidget(list(items: const [], emptyText: 'Custom'));
      expect(find.text('Custom'), findsOneWidget);
    });
  });
}
