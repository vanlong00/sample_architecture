import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/mods/presentation/widgets/detail_html.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class FakeLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  final launched = <String>[];

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    expect(options.mode, PreferredLaunchMode.externalApplication);
    return true;
  }
}

void main() {
  group('sanitizeModHtml', () {
    test('removes img in all spellings', () {
      const cases = [
        '<img src="a.png">',
        '<img src="a.png" alt="x>y" width=10>',
        "<img src='a.png'/>",
        '<img/>',
        '<IMG SRC="a.png">',
        '<ImG\n  src="a.png"\n>',
        '< img src="a.png">',
        '</img>',
        '<img src=a.png',
      ];
      for (final c in cases) {
        expect(
          sanitizeModHtml('a${c}b').toLowerCase(),
          isNot(contains('<img')),
        );
        expect(sanitizeModHtml('a${c}b'), contains('a'));
      }
      expect(sanitizeModHtml('a<img src="x">b'), 'ab');
      expect(sanitizeModHtml('a<img src="x>y" alt=\'>\'>b'), 'ab');
    });

    test('cannot reassemble an img tag', () {
      expect(
        sanitizeModHtml('<im<img>g src=x>').toLowerCase(),
        isNot(contains('<img')),
      );
    });

    test('reassembly through spaces, slashes and partial names', () {
      for (final c in [
        '<<img>img>',
        '< <img> img>',
        '</<img>img>',
        '<i<img>mg>',
        '<im<img>g>',
        '<im<im<img>g>g>g',
        '< im<img>g>',
      ]) {
        expect(
          sanitizeModHtml('a${c}b').toLowerCase(),
          isNot(matches(RegExp(r'<[\s/]*img'))),
          reason: c,
        );
      }
    });

    test('hostile input is linear (200 KB under 200 ms each)', () {
      final inputs = {
        'lt-space': '<${' ' * 200000}',
        'lt-space-repeat': '< ' * 100000,
        'nested-reassembly': '${'<im' * 25000}<img>${'g>' * 25000}',
        'unterminated-quote': '<img "' * 33000,
        'attr-run': '<img ${'a ' * 100000}',
        'img-spam': '<img>' * 40000,
        'frag-spam': '< ${'i<img>' * 28000}',
      };
      for (final e in inputs.entries) {
        final sw = Stopwatch()..start();
        sanitizeModHtml(e.value);
        expect(
          sw.elapsedMilliseconds,
          lessThan(200),
          reason: '${e.key}: ${sw.elapsedMilliseconds} ms',
        );
      }
    });

    test('keeps other markup and nested links', () {
      const html =
          '<p>hi <a href="https://x.com"><b>go</b> <img src="i"></a></p>';
      expect(
        sanitizeModHtml(html),
        '<p>hi <a href="https://x.com"><b>go</b> </a></p>',
      );
      expect(sanitizeModHtml('<image>x</image>'), '<image>x</image>');
    });

    test('malformed html does not throw', () {
      for (final c in [
        '',
        '<',
        '<<<>>>',
        '<img',
        '<img "',
        '<a href="x',
        '</',
        '<img src="x',
      ]) {
        expect(() => sanitizeModHtml(c), returnsNormally);
      }
    });
  });

  group('safeLinkTarget', () {
    test('accepts http(s) only', () {
      expect(safeLinkTarget('https://example.com/a'), isNotNull);
      expect(safeLinkTarget('HTTP://example.com'), isNotNull);
      expect(safeLinkTarget('javascript:alert(1)'), isNull);
      expect(safeLinkTarget('mailto:a@b.com'), isNull);
      expect(safeLinkTarget('tel:123'), isNull);
      expect(safeLinkTarget('intent://x#Intent;end'), isNull);
      expect(safeLinkTarget('/relative/path'), isNull);
      expect(safeLinkTarget('relative.html'), isNull);
      expect(safeLinkTarget('//example.com'), isNull);
      expect(safeLinkTarget('https://'), isNull);
      expect(safeLinkTarget('http://[bad'), isNull);
      expect(safeLinkTarget(null), isNull);
      expect(safeLinkTarget('  '), isNull);
    });

    test('rejects blocked hosts, incl. userinfo tricks', () {
      expect(safeLinkTarget('https://www.mediafire.com/x'), isNull);
      expect(safeLinkTarget('https://f001.backblazeb2.com/x'), isNull);
      expect(safeLinkTarget('https://evil.com@www.mediafire.com/x'), isNull);
      expect(safeLinkTarget('https://mediafire.com@evil.com/x'), isNotNull);
    });
  });

  group('DetailHtml widget', () {
    late FakeLauncher launcher;
    setUp(() {
      launcher = FakeLauncher();
      UrlLauncherPlatform.instance = launcher;
    });

    Future<void> pump(WidgetTester t, String? html) => t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: SingleChildScrollView(child: DetailHtml(html: html)),
        ),
      ),
    );

    // Fires the tap recognizer of the link span whose text is [text].
    Future<void> tapText(WidgetTester t, String text) async {
      var fired = false;
      void walk(InlineSpan span) {
        if (span is! TextSpan) return;
        final r = span.recognizer;
        if (span.text == text && r is TapGestureRecognizer) {
          r.onTap?.call();
          fired = true;
        }
        span.children?.forEach(walk);
      }

      for (final rt in t.widgetList<RichText>(find.byType(RichText))) {
        walk(rt.text);
      }
      expect(fired, isTrue, reason: 'no link span "$text"');
      await t.pumpAndSettle();
    }

    testWidgets('hidden when null or blank', (t) async {
      await pump(t, null);
      expect(find.byType(Html), findsNothing);
      expect(find.text('Description'), findsNothing);
      await pump(t, '  \n ');
      expect(find.byType(Html), findsNothing);
    });

    testWidgets('renders title and text, no images', (t) async {
      await pump(
        t,
        '<p>Hello world</p><img src="https://x.test/a.png"><IMG SRC="b.png"/>',
      );
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Hello world', findRichText: true), findsOneWidget);
      expect(find.byType(Image), findsNothing);
      expect(find.byType(RawImage), findsNothing);
    });

    testWidgets('blocks mediafire and backblaze taps', (t) async {
      await pump(
        t,
        '<a href="https://www.mediafire.com/file/x">mf</a> '
        '<a href="http://download1.mediafire.com/x">mf2</a> '
        '<a href="https://f000.backblazeb2.com/f">b2</a> '
        '<a href="https://www.backblaze.com/">bb</a>',
      );
      for (final s in ['mf', 'mf2', 'b2', 'bb']) {
        await tapText(t, s);
      }
      expect(launcher.launched, isEmpty);
    });

    testWidgets('ignores non-http schemes and relative links', (t) async {
      await pump(
        t,
        '<a href="javascript:alert(1)">js</a> <a href="mailto:a@b.c">mail</a> '
        '<a href="/rel">rel</a>',
      );
      for (final s in ['js', 'mail', 'rel']) {
        await tapText(t, s);
      }
      expect(launcher.launched, isEmpty);
    });

    testWidgets('launches other http(s) links externally', (t) async {
      await pump(t, '<a href="https://example.com/docs">docs</a>');
      await tapText(t, 'docs');
      expect(launcher.launched, ['https://example.com/docs']);
    });
  });
}
