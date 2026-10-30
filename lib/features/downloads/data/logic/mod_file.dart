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

/// F1: the one rule for "this mod can be downloaded". [storageUrl] must be an
/// http(s) URL with a real host that is not a blocked third-party source and
/// name a file with a safe extension. Shared by the model (`isMirrored`) and
/// the repository (checked before any network call).
// ponytail: http allowed because dev servers are plain http; tighten with AppConfig if needed.
bool isAllowedStorageUrl(String? storageUrl) {
  if (storageUrl == null || fileExtensionOf(storageUrl) == null) return false;
  final uri = Uri.tryParse(storageUrl);
  if (uri == null || uri.host.isEmpty) return false;
  if (uri.scheme != 'https' && uri.scheme != 'http') return false;
  return !isBlockedHost(uri);
}

final _safeExt = RegExp(r'^[A-Za-z0-9]+$');

/// Single file per mod: a re-download overwrites it.
String modRelPath(int sourceId, String ext) => 'mods/$sourceId.$ext';

// T1b/T11 spike locks real MIME per extension
const Map<String, String> kImportMimeByExt = {'zip': '*/*', 'rar': '*/*'};

String importMimeFor(String ext) =>
    kImportMimeByExt[ext.toLowerCase()] ?? '*/*';
