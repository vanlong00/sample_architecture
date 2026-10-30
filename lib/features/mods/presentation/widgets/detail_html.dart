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

final _imgTag = RegExp(
  r'''<\s*/?\s*img\b(?:"[^"]*"|'[^']*'|[^>"'])*>?''',
  caseSensitive: false,
);

/// Removes every `<img>` tag. Loops so `<im<img>g>` cannot reassemble one.
String sanitizeModHtml(String html) {
  var out = html;
  for (var prev = ''; prev != out;) {
    prev = out;
    out = out.replaceAll(_imgTag, '');
  }
  return out;
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
