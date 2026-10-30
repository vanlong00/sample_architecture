import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/ads/ads_service.dart';
import '../../../../core/config/app_links.dart';
import '../../../../core/l10n/l10n_ext.dart';

/// Tells the user PBSU is missing and offers the Play Store listing.
Future<void> showPbsuMissingDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => const _PbsuMissingDialog(),
);

class _PbsuMissingDialog extends StatelessWidget {
  const _PbsuMissingDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.pbsuMissingTitle),
      content: Text(l10n.pbsuMissingBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            _openStore();
          },
          child: Text(l10n.pbsuOpenStore),
        ),
      ],
    );
  }
}

Future<bool> _launch(String url) async {
  try {
    return await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } catch (_) {
    return false;
  }
}

/// market:// first (opens the Play app), https if there is no Play Store.
Future<void> _openStore() async {
  maybeAdsService()?.suppressNextAppOpen(); // leaving for the Play Store
  if (!await _launch(pbsuPlayStore)) await _launch(pbsuPlayStoreWeb);
}
