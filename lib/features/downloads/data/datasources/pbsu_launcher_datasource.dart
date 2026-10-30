import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:open_file/open_file.dart';

import '../../../../core/config/app_links.dart';

/// Only file that talks to PBSU natively (own MethodChannel, see
/// `PbsuLauncher.kt`) or to `open_file`. Platform errors propagate untouched;
/// the repository decides the fallback.
@lazySingleton
class PbsuLauncherDataSource {
  PbsuLauncherDataSource({@ignoreParam MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.pamg.busmod/pbsu');

  final MethodChannel _channel;

  Future<bool> isInstalled() async =>
      await _channel.invokeMethod<bool>('isInstalled', {
        'packageName': kPbsuPackage,
      }) ??
      false;

  /// ACTION_VIEW straight to PBSU. Throws [PlatformException] on failure.
  Future<void> launch({required String path, required String mime}) =>
      _channel.invokeMethod<void>('launch', {
        'path': path,
        'mime': mime,
        'packageName': kPbsuPackage,
      });

  /// System chooser fallback. `true` when a handler opened the file.
  Future<bool> openWithChooser({
    required String path,
    required String mime,
  }) async => (await OpenFile.open(path, type: mime)).type == ResultType.done;
}
