import '../../../../core/utils/blocked_hosts.dart';

/// Extension of the file named by [storageUrl] (no dot, case preserved
/// byte-for-byte), or `null` when there is none (F2: download is refused).
/// Query and fragment are ignored. Only `[A-Za-z0-9]+` is accepted so the
/// result is always safe to put in a file name.
String? fileExtensionOf(String storageUrl) {
  final path = Uri.tryParse(storageUrl)?.path;
  if (path == null) return null;
  final name = path.substring(path.lastIndexOf('/') + 1);
  final ext = name.substring(name.lastIndexOf('.') + 1);
  if (!name.contains('.') || !_safeExt.hasMatch(ext)) return null;
  return ext;
}

/// Cleartext http is refused unless the app is run with
/// `--dart-define=ALLOW_HTTP_STORAGE=true` (dev servers). Android's
/// network_security_config does not apply to dart:io, so the app must refuse
/// cleartext itself. Same pattern as `BASE_URL` in `AppConfig`; defaults to
/// secure.
// ponytail: compile-time define, not AppConfig: the mods models call the
// predicate without DI. Move to AppConfig if the models ever get it.
const kAllowHttpStorage = bool.fromEnvironment('ALLOW_HTTP_STORAGE');

/// F1: the one rule for "this mod can be downloaded". [storageUrl] must be an
/// https URL (http only when [allowHttp]) with a real host that is not a
/// blocked third-party source and name a file with a safe extension. Shared by
/// the model (`isMirrored`), the repository (checked before any network call)
/// and every redirect hop of the remote data source.
bool isAllowedStorageUrl(
  String? storageUrl, {
  bool allowHttp = kAllowHttpStorage,
}) {
  if (storageUrl == null || fileExtensionOf(storageUrl) == null) return false;
  final uri = Uri.tryParse(storageUrl);
  if (uri == null || uri.host.isEmpty) return false;
  if (uri.scheme != 'https' && !(allowHttp && uri.scheme == 'http')) {
    return false;
  }
  return !isBlockedHost(uri);
}

final _safeExt = RegExp(r'^[A-Za-z0-9]+$');

/// Single file per mod: a re-download overwrites it.
String modRelPath(int sourceId, String ext) => 'mods/$sourceId.$ext';

// T1b/T11 spike locks real MIME per extension
const Map<String, String> kImportMimeByExt = {'zip': '*/*', 'rar': '*/*'};

String importMimeFor(String ext) =>
    kImportMimeByExt[ext.toLowerCase()] ?? '*/*';
