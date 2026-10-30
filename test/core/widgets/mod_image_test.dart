import 'package:busmod/core/widgets/mod_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pump(WidgetTester t, String? url) => t.pumpWidget(
  MaterialApp(
    home: SizedBox(width: 160, height: 90, child: ModImage(url: url)),
  ),
);

void main() {
  for (final url in <String?>[
    null,
    '',
    '   ',
    'http://[bad',
    'ftp://cdn.example.com/a.jpg',
    'javascript:alert(1)',
    '/relative/a.jpg',
    '//cdn.example.com/a.jpg',
    'https://www.mediafire.com/a.jpg',
    'https://WWW.MediaFire.COM./a.jpg',
    'https://f000.backblazeb2.com/file/a.jpg',
    'https://cdn.example.com@www.backblaze.com/a.jpg',
  ]) {
    testWidgets('placeholder, no request, for ${url ?? 'null'}', (t) async {
      await pump(t, url);
      expect(find.byType(CachedNetworkImage), findsNothing);
      expect(find.byType(Image), findsNothing);
      expect(find.byIcon(Icons.directions_bus_outlined), findsOneWidget);
    });
  }

  testWidgets('a normal https CDN url builds the image widget', (t) async {
    await pump(t, 'https://cdn.example.com/a.jpg');
    expect(find.byType(CachedNetworkImage), findsOneWidget);
    // Let the (failing, test-env) load settle into the error placeholder.
    await t.pump(const Duration(seconds: 1));
  });

  testWidgets('decodes/stores at the displayed pixel width', (t) async {
    await t.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(
            width: 160,
            height: 90,
            child: ModImage(url: 'https://cdn.example.com/a.jpg'),
          ),
        ),
      ),
    );
    final dpr = t.view.devicePixelRatio;
    final img = t.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(img.memCacheWidth, (160 * dpr).round());
    expect(img.maxWidthDiskCache, (160 * dpr).round());
    await t.pump(const Duration(seconds: 1));
  });
}
