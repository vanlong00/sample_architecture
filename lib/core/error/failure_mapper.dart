import 'package:busmod/core/l10n/app_localizations.dart';

import 'failure.dart';

String mapFailureToMessage(Failure failure, AppLocalizations l10n) {
  return failure.when(
    // 404: the mod is gone / hidden (not mirrored); retrying cannot help.
    server: (message, code) =>
        code == 404 ? l10n.errorModNotAvailable : l10n.errorServer,
    network: () => l10n.errorNetwork,
    cache: () => l10n.errorCache,
    unauthorized: () => l10n.errorUnauthorized,
    unknown: (message) => l10n.errorUnknown,
  );
}
