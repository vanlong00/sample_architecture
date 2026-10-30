import 'package:busmod/core/ads/ad_network.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

class _MockStore extends Mock implements LocalStore {}

void main() {
  group('networkFor', () {
    for (final c in ['RU', 'KZ', 'KG', 'UZ', 'ru', 'kz']) {
      test('$c -> yandex', () => expect(networkFor(c), AdNetwork.yandex));
    }
    for (final c in ['VN', 'US', 'XX', '', null]) {
      test('$c -> admob', () => expect(networkFor(c), AdNetwork.admob));
    }
  });

  group('parseCountry', () {
    test('map and raw json', () {
      expect(parseCountry({'cf-ipcountry': 'vn'}), 'VN');
      expect(parseCountry('{"cf-ipcountry":"RU"}'), 'RU');
    });
    test('rejects unknown, tor, garbage', () {
      expect(parseCountry({'cf-ipcountry': 'XX'}), isNull);
      expect(parseCountry({'cf-ipcountry': 'T1'}), isNull);
      expect(parseCountry('not json'), isNull);
      expect(parseCountry({'cf-ipcountry': 'RUS'}), isNull);
      expect(parseCountry(null), isNull);
    });
  });

  group('AdCountryLookup', () {
    late _MockDio dio;
    late _MockStore store;
    late AdCountryLookup lookup;

    setUp(() {
      dio = _MockDio();
      store = _MockStore();
      lookup = AdCountryLookup(dio, store);
      when(
        () => store.write<String>(any(), any(), any()),
      ).thenAnswer((_) async {});
    });

    Response<Object?> ok(Object? data) => Response<Object?>(
      requestOptions: RequestOptions(path: AdCountryLookup.url),
      data: data,
    );

    test('RU response -> RU -> yandex, and cached', () async {
      when(
        () => dio.get<Object?>(AdCountryLookup.url),
      ).thenAnswer((_) async => ok({'cf-ipcountry': 'RU'}));

      final country = await lookup.country();

      expect(networkFor(country), AdNetwork.yandex);
      verify(
        () => store.write<String>(StoreBoxes.settings, 'ads_country', 'RU'),
      ).called(1);
    });

    test('lookup failure and empty cache -> null -> admob', () async {
      when(() => dio.get<Object?>(AdCountryLookup.url)).thenThrow(
        DioException(requestOptions: RequestOptions(path: AdCountryLookup.url)),
      );
      when(() => store.read<String>(any(), any())).thenReturn(null);

      final country = await lookup.country();

      expect(country, isNull);
      expect(networkFor(country), AdNetwork.admob);
    });

    test('lookup failure with unreadable store -> admob', () async {
      when(
        () => dio.get<Object?>(AdCountryLookup.url),
      ).thenThrow(Exception('offline'));
      when(() => store.read<String>(any(), any())).thenThrow(StateError('x'));

      expect(networkFor(await lookup.country()), AdNetwork.admob);
    });

    test('failure falls back to cached country', () async {
      when(
        () => dio.get<Object?>(AdCountryLookup.url),
      ).thenThrow(Exception('offline'));
      when(() => store.read<String>(any(), any())).thenReturn('KZ');

      expect(networkFor(await lookup.country()), AdNetwork.yandex);
    });
  });
}
