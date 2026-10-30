import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/utils/blocked_hosts.dart';

/// Tags never rendered (images and anything else that fetches remote media).
const _blockedTags = {
  'img',
  'picture',
  'source',
  'svg',
  'video',
  'audio',
  'iframe',
};

// One `[\s/]*` (not `\s*/?\s*`): adjacent optional runs backtrack
// quadratically on long whitespace.
final _imgTag = RegExp(
  r'''<[\s/]*img\b(?:"[^"]*"|'[^']*'|[^>"'])*>?''',
  caseSensitive: false,
);

bool _isSpace(int c) =>
    (c >= 9 && c <= 13) ||
    c == 0x20 ||
    c == 0xa0 ||
    c == 0x1680 ||
    (c >= 0x2000 && c <= 0x200a) ||
    c == 0x2028 ||
    c == 0x2029 ||
    c == 0x202f ||
    c == 0x205f ||
    c == 0x3000 ||
    c == 0xfeff;

/// Removes every `<img>` tag in a single linear pass (the input is crawled
/// third-party HTML and this runs on the UI thread).
///
/// Removing a tag can join the text around it into a new one (`<im<img>g>`).
/// So the scan tracks the trailing chain of open fragments
/// (`<[\s/]*i?m?` repeated, only a `<` may follow a fragment) and drops the
/// whole chain together with a tag removed right after it.
String sanitizeModHtml(String html) {
  final out = <int>[];
  var chain = -1; // start in [out] of the open fragment chain, or -1.
  var live = false; // the last `<` is still an open fragment.
  var state = 0; // 0: only spaces/slashes so far, 1: saw i, 2: saw im.
  var i = 0;
  while (i < html.length) {
    final c = html.codeUnitAt(i);
    if (c == 0x3c) {
      final m = _imgTag.matchAsPrefix(html, i);
      if (m != null) {
        i = m.end;
        if (chain >= 0) out.length = chain;
        chain = -1;
        live = false;
        continue;
      }
      if (!live) chain = out.length;
      live = true;
      state = 0;
    } else if (live) {
      if (state == 0 && (_isSpace(c) || c == 0x2f)) {
        // still only spaces/slashes
      } else if (state == 0 && (c | 0x20) == 0x69) {
        state = 1;
      } else if (state == 1 && (c | 0x20) == 0x6d) {
        state = 2;
      } else {
        live = false;
        chain = -1;
      }
    }
    out.add(c);
    i++;
  }
  return String.fromCharCodes(out);
}

/// The uri a description link may open, or null (non-http(s), relative,
/// malformed, or blocked host).
Uri? safeLinkTarget(String? href) {
  final uri = Uri.tryParse(href?.trim() ?? '');
  if (uri == null || uri.host.isEmpty) return null;
  if (uri.scheme != 'http' && uri.scheme != 'https') return null;
  return isBlockedHost(uri) ? null : uri;
}

/// Mod description. Hidden when [html] is null/blank. Never fetches images and
/// never opens links to the original hosts (F1).
class DetailHtml extends StatefulWidget {
  const DetailHtml({required this.html, super.key});

  final String? html;

  @override
  State<DetailHtml> createState() => _DetailHtmlState();
}

class _DetailHtmlState extends State<DetailHtml> {
  String? _source;
  String _clean = '';

  /// Sanitized once per html string, not on every build.
  String _sanitized(String raw) {
    if (raw != _source) {
      _source = raw;
      _clean = sanitizeModHtml(raw);
    }
    return _clean;
  }

  @override
  Widget build(BuildContext context) {
    final raw = widget.html;
    if (raw == null || raw.trim().isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            context.l10n.detailDescription,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Html(
          data: _sanitized(raw),
          doNotRenderTheseTags: _blockedTags,
          onLinkTap: (url, _, _) => unawaited(_open(url)),
          style: {
            'body': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
          },
        ),
      ],
    );
  }

  // ponytail: launch failures are swallowed; nothing useful to tell the user.
  static Future<void> _open(String? href) async {
    final uri = safeLinkTarget(href);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}
