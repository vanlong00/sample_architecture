import 'dart:ffi';
import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:busmod/core/storage/local_store.dart';

/// IsarCore binary cache directory, shared by all tests and kept across runs.
/// It lives in `.dart_tool/`, which is already gitignored.
const String _cacheDir = '.dart_tool/isar_core';

/// Platform-specific binary file name. Matches the `Abi.remoteName` table in
/// `isar_community` (`lib/src/native/isar_core.dart`).
String get _binaryName => switch (Abi.current()) {
  Abi.macosArm64 || Abi.macosX64 => 'libisar_macos.dylib',
  Abi.linuxX64 => 'libisar_linux_x64.so',
  Abi.windowsArm64 => 'isar_windows_arm64.dll',
  Abi.windowsX64 => 'isar_windows_x64.dll',
  _ => throw UnsupportedError('IsarCore chưa có binary cho ${Abi.current()}'),
};

/// Downloads IsarCore into [_cacheDir] if missing, then returns its path.
///
/// Uses `curl` instead of `Isar.initializeIsarCore(download: true)` because
/// `TestWidgetsFlutterBinding` installs a global `HttpOverrides` that returns
/// 400 for every request, so Isar's built-in download always fails in
/// `flutter test` ("Could not download IsarCore library"). That override cannot
/// be removed: an `HttpClient()` built inside `HttpOverrides.runZoned` calls
/// itself again and overflows the stack. A child process is out of the
/// override's reach. `curl` ships with macOS, Linux, and Windows 10 and later.
Future<String> _ensureIsarCore() async {
  final path = '$_cacheDir/$_binaryName';
  if (File(path).existsSync()) return path;

  Directory(_cacheDir).createSync(recursive: true);
  final url =
      'https://binaries.isar-community.dev/${Isar.version}/$_binaryName';
  final result = await Process.run('curl', [
    '--fail',
    '--location',
    '--silent',
    '--show-error',
    '--output',
    path,
    url,
  ]);
  if (result.exitCode != 0) {
    // Delete the partial file, or the next run thinks the download finished.
    final partial = File(path);
    if (partial.existsSync()) partial.deleteSync();
    throw StateError(
      'Không tải được IsarCore từ $url (exit ${result.exitCode}): '
      '${result.stderr}',
    );
  }
  return path;
}

/// Opens a real [LocalStore] in a temp directory, for tests that need real
/// storage semantics (upsert, type kept on decode, delete) instead of a fake
/// map.
///
/// The first run on a machine needs network access to download IsarCore
/// (~3MB). After that the binary stays in `.dart_tool/isar_core/` and is not
/// downloaded again. Tests that only need read and write semantics should use
/// an in-memory fake and not call this.
/// Loads the IsarCore native library (idempotent).
Future<void> initIsarCoreForTests() async {
  await Isar.initializeIsarCore(
    libraries: {Abi.current(): await _ensureIsarCore()},
  );
}

Future<LocalStore> openTestStore() async {
  await initIsarCoreForTests();
  final dir = await Directory.systemTemp.createTemp('busmod_local_store_test');
  final store = LocalStore();
  await store.init(directory: dir.path);
  return store;
}
