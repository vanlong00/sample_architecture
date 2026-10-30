import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:busmod/core/network/cache_config.dart';
import 'package:busmod/core/network/interceptors/error_interceptor.dart';

/// Adapter that counts real network hits. `fail = true` simulates offline.
/// [status] and [body] change the "server" answer between two calls.
class _CountingAdapter implements HttpClientAdapter {
  int calls = 0;
  bool fail = false;
  int status = 200;
  String body = '{"ok":true}';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    if (fail) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('CacheTtlInterceptor', () {
    Response<dynamic> run(String path, {String method = 'GET'}) {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(
          path: path,
          baseUrl: 'https://x.test',
          method: method,
        ),
        statusCode: 200,
      );
      CacheTtlInterceptor().onResponse(response, ResponseInterceptorHandler());
      return response;
    }

    test('gắn max-age = kCacheTtl cho mọi GET', () {
      expect(
        run('/pack-tags').headers.value('cache-control'),
        'max-age=${kCacheTtl.inSeconds}',
      );
      expect(
        run('/pack-items/search').headers.value('cache-control'),
        'max-age=${kCacheTtl.inSeconds}',
      );
    });

    test('không chạm request khác GET', () {
      expect(
        run('/pack-tags', method: 'POST').headers.value('cache-control'),
        isNull,
      );
    });

    test('maxStale phải dài hơn TTL, không thì mất bản dự phòng offline', () {
      expect(kCacheMaxStale, greaterThan(kCacheTtl));
    });
  });

  group('cache trên Dio thật (MemCacheStore)', () {
    late _CountingAdapter adapter;
    late Dio dio;

    setUp(() {
      adapter = _CountingAdapter();
      dio = Dio(BaseOptions(baseUrl: 'https://x.test'))
        ..httpClientAdapter = adapter
        // Same order as `buildDio`.
        ..interceptors.add(CacheTtlInterceptor())
        ..interceptors.add(
          DioCacheInterceptor(options: buildCacheOptions(MemCacheStore())),
        )
        ..interceptors.add(ErrorInterceptor());
    });

    test('lần thứ hai đọc cache, KHÔNG gửi request', () async {
      await dio.get<dynamic>('/pack-tags');
      await dio.get<dynamic>('/pack-tags');
      expect(adapter.calls, 1);
    });

    test('search cũng được cache', () async {
      await dio.get<dynamic>('/pack-items/search', queryParameters: {'q': 'a'});
      await dio.get<dynamic>('/pack-items/search', queryParameters: {'q': 'a'});
      expect(adapter.calls, 1);
    });

    test('forceRefreshOptions bỏ qua cache và ghi lại bản mới', () async {
      await dio.get<dynamic>('/pack-tags');
      await dio.get<dynamic>('/pack-tags', options: forceRefreshOptions());
      expect(adapter.calls, 2);
      // The freshly written copy still serves the next normal read.
      await dio.get<dynamic>('/pack-tags');
      expect(adapter.calls, 2);
    });

    test('query khác nhau là hai entry cache khác nhau', () async {
      await dio.get<dynamic>('/pack-items/1', queryParameters: {'filter': 'a'});
      await dio.get<dynamic>('/pack-items/1', queryParameters: {'filter': 'b'});
      expect(adapter.calls, 2);
    });

    test('offline vẫn trả bản đã cache thay vì Failure', () async {
      await dio.get<dynamic>('/pack-tags');
      adapter.fail = true;
      final again = await dio.get<dynamic>('/pack-tags');
      expect(again.data, {'ok': true});
    });

    test('offline mà chưa có cache thì vẫn lỗi qua ErrorInterceptor', () async {
      adapter.fail = true;
      await expectLater(
        dio.get<dynamic>('/pack-tags'),
        throwsA(isA<DioException>()),
      );
    });
  });
}
