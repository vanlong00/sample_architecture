// ignore_for_file: depend_on_referenced_packages
import 'package:busmod/core/config/app_links.dart';
import 'package:busmod/features/downloads/data/datasources/pbsu_launcher_datasource.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_file_platform_interface/open_file_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/pbsu');
  final ds = PbsuLauncherDataSource(channel: channel);
  final calls = <MethodCall>[];

  void handle(Future<Object?> Function(MethodCall) h) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (c) {
          calls.add(c);
          return h(c);
        });
  }

  setUp(calls.clear);
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );

  test('isInstalled sends the PBSU package and returns the result', () async {
    handle((_) async => true);
    expect(await ds.isInstalled(), isTrue);
    expect(calls.single.method, 'isInstalled');
    expect(calls.single.arguments, {'packageName': kPbsuPackage});
  });

  test('isInstalled null result is false', () async {
    handle((_) async => null);
    expect(await ds.isInstalled(), isFalse);
  });

  test('launch sends path, mime and package', () async {
    handle((_) async => null);
    await ds.launch(path: '/f/mods/1.zip', mime: 'application/zip');
    expect(calls.single.method, 'launch');
    expect(calls.single.arguments, {
      'path': '/f/mods/1.zip',
      'mime': 'application/zip',
      'packageName': kPbsuPackage,
    });
  });

  test('launch propagates PlatformException', () async {
    handle((_) async => throw PlatformException(code: 'ACTIVITY_NOT_FOUND'));
    expect(
      ds.launch(path: '/p', mime: '*/*'),
      throwsA(
        isA<PlatformException>().having(
          (e) => e.code,
          'code',
          'ACTIVITY_NOT_FOUND',
        ),
      ),
    );
  });

  test('isInstalled propagates PlatformException', () async {
    handle((_) async => throw PlatformException(code: 'BAD_ARGS'));
    expect(ds.isInstalled(), throwsA(isA<PlatformException>()));
  });

  group('openWithChooser', () {
    Future<bool> run(OpenResult r) {
      OpenFilePlatform.platform = _FakeOpenFile(r);
      return ds.openWithChooser(path: '/p', mime: '*/*');
    }

    test('done -> true', () async {
      expect(await run(OpenResult(type: ResultType.done)), isTrue);
    });

    test('no app / error -> false', () async {
      expect(await run(OpenResult(type: ResultType.noAppToOpen)), isFalse);
      expect(await run(OpenResult(type: ResultType.error)), isFalse);
    });

    test('forwards path and mime', () async {
      final fake = _FakeOpenFile(OpenResult(type: ResultType.done));
      OpenFilePlatform.platform = fake;
      await ds.openWithChooser(path: '/a.zip', mime: 'application/zip');
      expect(fake.last, ('/a.zip', 'application/zip'));
    });
  });
}

class _FakeOpenFile extends OpenFilePlatform {
  _FakeOpenFile(this._result);
  final OpenResult _result;
  (String?, String?)? last;

  @override
  Future<OpenResult> open(
    String? filePath, {
    String? type,
    bool isIOSAppOpen = false,
    String linuxDesktopName = 'xdg',
    bool linuxUseGio = false,
    bool linuxByProcess = false,
  }) async {
    last = (filePath, type);
    return _result;
  }
}
