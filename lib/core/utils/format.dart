/// Human-readable size (B/KB/MB/GB, 1024 base, 1 decimal). Locale-neutral:
/// always uses '.' as the decimal separator.
String formatBytes(int bytes) {
  if (bytes < 1024) return '${bytes < 0 ? 0 : bytes} B';
  const units = ['KB', 'MB', 'GB'];
  var value = bytes / 1024;
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${value.toStringAsFixed(1)} ${units[unit]}';
}
