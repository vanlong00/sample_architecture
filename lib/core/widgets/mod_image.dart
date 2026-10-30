import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/blocked_hosts.dart';

/// Network image that falls back to a themed placeholder (loading, error, or
/// a url we must not fetch). Fills its parent.
///
/// F1: no request is made for a null/empty/unparsable url, a non-http(s)
/// scheme, or a blocked source host (see [isBlockedHost]).
class ModImage extends StatelessWidget {
  const ModImage({required this.url, super.key});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Icon(Icons.directions_bus_outlined, color: scheme.outline),
    );
    final uri = Uri.tryParse(url?.trim() ?? '');
    final loadable =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty &&
        !isBlockedHost(uri);
    if (!loadable) return placeholder;
    return CachedNetworkImage(
      imageUrl: uri.toString(),
      fit: BoxFit.cover,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}
