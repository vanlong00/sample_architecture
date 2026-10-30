/// F1: hosts of the original third-party sources; the app never contacts them.
const _blockedDomains = ['mediafire.com', 'backblazeb2.com', 'backblaze.com'];

/// True if [uri]'s host is, or is a subdomain of, a blocked source host.
/// Uses the parsed host, so `evil.com@www.mediafire.com` is decided by the
/// real host (`www.mediafire.com`).
bool isBlockedHost(Uri uri) {
  var host = uri.host.toLowerCase();
  if (host.endsWith('.')) host = host.substring(0, host.length - 1);
  return _blockedDomains.any((d) => host == d || host.endsWith('.$d'));
}
