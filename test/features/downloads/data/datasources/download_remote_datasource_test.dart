import 'dart:io';
import 'dart:typed_data';

import 'package:busmod/core/config/app_config.dart';
import 'package:busmod/core/config/env.dart';
import 'package:busmod/core/error/exceptions.dart';
import 'package:busmod/core/network/dio_client.dart';
import 'package:busmod/features/downloads/data/datasources/download_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

const _config = AppConfig(
  env: AppEnv.prod,
  baseUrl: 'https://api.busmod.test',
  enableLogging: false,
  appName: 'Busmod (Test)',
);

/// Answers from [routes]: absolute URL -> (status, Location for 3xx / body).
class _Adapter implements HttpClientAdapter {
  final routes = <String, (int, String?)>{};
  final requests = <Uri>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options.uri);
    final (status, value) = routes[options.uri.toString()] ?? (404, 'nope');
    if (status >= 300 && status < 400) {
      return ResponseBody.fromString(
        '',
        status,
        headers: {
          if (value != null) 'location': [value],
        },
      );
    }
    return ResponseBody.fromString(value ?? '', status);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _Adapter adapter;
  late DownloadRemoteDataSource ds;
  late Directory dir;
  late String save;

  setUp(() async {
    adapter = _Adapter();
    ds = DownloadRemoteDataSource(
      buildDownloadDio(_config)..httpClientAdapter = adapter,
    );
    dir = await Directory.systemTemp.createTemp('busmod_remote');
    save = '${dir.path}/f.part';
  });
  tearDown(() => dir.delete(recursive: true));

  Future<void> run(String url) => ds.download(url: url, savePath: save);
  Matcher refused() => throwsA(isA<ServerException>());

  test('plain 200 downloads the body', () async {
    adapter.routes['https://cdn.x/a.zip'] = (200, 'DATA');
    await run('https://cdn.x/a.zip');
    expect(File(save).readAsStringSync(), 'DATA');
  });

  test('redirect to the same CDN host is followed', () async {
    adapter.routes['https://cdn.x/a.zip'] = (302, 'https://cdn.x/b/a.zip');
    adapter.routes['https://cdn.x/b/a.zip'] = (200, 'DATA');
    await run('https://cdn.x/a.zip');
    expect(File(save).readAsStringSync(), 'DATA');
    expect(adapter.requests.length, 2);
  });

  test('relative Location resolves against the current URL', () async {
    adapter.routes['https://cdn.x/dir/a.zip'] = (301, '../real/a.zip');
    adapter.routes['https://cdn.x/real/a.zip'] = (307, '/abs/a.zip');
    adapter.routes['https://cdn.x/abs/a.zip'] = (200, 'DATA');
    await run('https://cdn.x/dir/a.zip');
    expect(File(save).readAsStringSync(), 'DATA');
    expect(adapter.requests.map((u) => u.toString()), [
      'https://cdn.x/dir/a.zip',
      'https://cdn.x/real/a.zip',
      'https://cdn.x/abs/a.zip',
    ]);
  });

  test('redirect to a blocked host fails and never requests it', () async {
    adapter.routes['https://cdn.x/a.zip'] = (
      302,
      'https://download.mediafire.com/a.zip',
    );
    adapter.routes['https://download.mediafire.com/a.zip'] = (200, 'EVIL');
    await expectLater(run('https://cdn.x/a.zip'), refused());
    expect(adapter.requests.map((u) => u.host), ['cdn.x']);
  });

  test('redirect to cleartext http / other scheme fails, no request', () async {
    adapter.routes['https://cdn.x/a.zip'] = (302, 'http://cdn.x/a.zip');
    await expectLater(run('https://cdn.x/a.zip'), refused());
    adapter.routes['https://cdn.x/b.zip'] = (302, 'ftp://cdn.x/b.zip');
    await expectLater(run('https://cdn.x/b.zip'), refused());
    expect(adapter.requests.length, 2); // only the two first URLs
  });

  test('3 redirects are followed, a 4th fails', () async {
    for (var i = 0; i < 3; i++) {
      adapter.routes['https://cdn.x/h$i.zip'] = (
        302,
        'https://cdn.x/h${i + 1}.zip',
      );
    }
    adapter.routes['https://cdn.x/h3.zip'] = (200, 'DATA');
    await run('https://cdn.x/h0.zip'); // h0 -> h1 -> h2 -> h3: three hops
    expect(File(save).readAsStringSync(), 'DATA');

    adapter.requests.clear();
    adapter.routes['https://cdn.x/h3.zip'] = (302, 'https://cdn.x/h4.zip');
    await expectLater(run('https://cdn.x/h0.zip'), refused());
    expect(adapter.requests.length, 4); // h4 is never requested
  });

  test('redirect loop fails', () async {
    adapter.routes['https://cdn.x/a.zip'] = (302, 'https://cdn.x/b.zip');
    adapter.routes['https://cdn.x/b.zip'] = (302, 'https://cdn.x/a.zip');
    await expectLater(run('https://cdn.x/a.zip'), refused());
    expect(adapter.requests.length, 4);
  });

  test('3xx without Location, or a non-redirect 3xx (304), fails', () async {
    adapter.routes['https://cdn.x/a.zip'] = (302, null);
    await expectLater(run('https://cdn.x/a.zip'), refused());
    adapter.routes['https://cdn.x/b.zip'] = (304, 'https://cdn.x/c.zip');
    await expectLater(run('https://cdn.x/b.zip'), refused());
  });

  test('error status still surfaces as DioException', () async {
    adapter.routes['https://cdn.x/a.zip'] = (500, 'boom');
    await expectLater(run('https://cdn.x/a.zip'), throwsA(isA<DioException>()));
  });
}
