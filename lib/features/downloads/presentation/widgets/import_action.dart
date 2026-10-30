import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart' hide State;

import '../../../../core/ads/ads_service.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../data/repositories/download_repository.dart';
import 'pbsu_missing_dialog.dart';

/// Runs an import [action] and always tells the user how it went.
/// [onFileMissing] fires only when the file is verifiably gone from disk
/// (`Right(fileMissing)`); a storage error is just a failed import.
Future<void> runImport(
  BuildContext context,
  Future<Either<Failure, ImportOutcome>> Function() action, {
  VoidCallback? onFileMissing,
}) async {
  // Import leaves the app for PBSU: do not show an app-open ad on return.
  maybeAdsService()?.suppressNextAppOpen();
  final result = await action();
  if (!context.mounted) return;
  final l10n = context.l10n;
  // Any Left (a storage error included) is a failed import, not a missing file.
  final outcome = result.getOrElse((_) => ImportOutcome.failed);
  switch (outcome) {
    case ImportOutcome.sent:
      context.showAppSnackBar(l10n.importSent);
    case ImportOutcome.notInstalled:
      await showPbsuMissingDialog(context);
    case ImportOutcome.chooserOpened:
      context.showAppSnackBar(l10n.importChooserHint);
    case ImportOutcome.failed:
      context.showAppSnackBar(l10n.importFailed, isError: true);
    case ImportOutcome.fileMissing:
      context.showAppSnackBar(l10n.ctaFileMissing, isError: true);
      onFileMissing?.call();
  }
}

/// Ignores taps while [run] is in flight (no double PBSU intent).
class ImportGuard extends StatefulWidget {
  const ImportGuard({required this.run, required this.builder, super.key});

  final Future<void> Function() run;

  /// `onPressed` is `null` while an import is running.
  final Widget Function(BuildContext context, VoidCallback? onPressed) builder;

  @override
  State<ImportGuard> createState() => _ImportGuardState();
}

class _ImportGuardState extends State<ImportGuard> {
  bool _importing = false;

  Future<void> _onPressed() async {
    setState(() => _importing = true);
    try {
      await widget.run();
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _importing ? null : _onPressed);
}
