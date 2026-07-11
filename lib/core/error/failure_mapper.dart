import 'package:sample_architecture/core/l10n/app_localizations.dart';

import 'failure.dart';

String mapFailureToMessage(Failure failure, AppLocalizations l10n) {
  return failure.when(
    server: (message, code) => l10n.errorServer,
    network: () => l10n.errorNetwork,
    cache: () => l10n.errorCache,
    unauthorized: () => l10n.errorUnauthorized,
    unknown: (message) => l10n.errorUnknown,
  );
}
