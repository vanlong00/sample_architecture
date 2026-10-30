import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/favorites/data/models/favorite_record.dart';
import 'package:busmod/features/favorites/presentation/widgets/favorite_tile.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const record = FavoriteRecord(
  sourceId: 7,
  title: 'Volvo B7R',
  type: ModType.truck,
  savedAtMs: 1,
);

Widget app(Widget home, {String locale = 'en'}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: Locale(locale),
  home: Scaffold(body: home),
);

void main() {
  testWidgets('shows title and localized type; fires callbacks', (t) async {
    var taps = 0;
    var removes = 0;
    await t.pumpWidget(
      app(
        FavoriteTile(
          record: record,
          onTap: () => taps++,
          onRemove: () => removes++,
        ),
      ),
    );
    expect(find.text('Volvo B7R'), findsOneWidget);
    expect(find.text('Truck'), findsOneWidget);

    await t.tap(find.text('Volvo B7R'));
    expect(taps, 1);
    await t.tap(find.byTooltip('Remove Volvo B7R from favorites'));
    expect(removes, 1);
    expect(taps, 1);
  });

  testWidgets('type is localized to vi', (t) async {
    await t.pumpWidget(
      app(
        FavoriteTile(record: record, onTap: () {}, onRemove: () {}),
        locale: 'vi',
      ),
    );
    expect(find.text('Xe tải'), findsOneWidget);
  });

  testWidgets('remove button is at least 48dp', (t) async {
    await t.pumpWidget(
      app(FavoriteTile(record: record, onTap: () {}, onRemove: () {})),
    );
    final size = t.getSize(find.byType(IconButton));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });
}
