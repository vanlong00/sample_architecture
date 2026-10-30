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
    unknown: (message) => _unknownMessage(message, l10n),
  );
}

// guard() turns an unclassified error (e.g. the FileSystemException dio.download
// throws on a full disk, wrapped in a DioException) into Failure.unknown
// carrying only `error.toString()`, so the storage case is recognised from that
// text. Making guard/the repository emit a typed storage failure is outside
// this file; until then this is the only place it can be told apart.
final _noSpace = RegExp(
  r'errno = 28\b|no space left|not enough space',
  caseSensitive: false,
);

String _unknownMessage(String? message, AppLocalizations l10n) {
  if (message == null || !message.contains('FileSystemException')) {
    return l10n.errorUnknown;
  }
  return _noSpace.hasMatch(message) ? l10n.errorStorageFull : l10n.errorCache;
}
