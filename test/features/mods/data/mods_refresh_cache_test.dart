// Real Dio (cache + TTL interceptors) + real retrofit data source + real
// repository: pull to refresh must hit the network and update the cache,
// every other read must be served from the cache.
import 'dart:convert';
import 'dart:typed_data';

import 'package:busmod/core/config/app_config.dart';
import 'package:busmod/core/config/env.dart';
import 'package:busmod/core/network/dio_client.dart';
import 'package:busmod/features/mods/data/datasources/mods_remote_datasource.dart';
import 'package:busmod/features/mods/data/models/mod_query.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_list_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_list_state.dart';
import 'package:busmod/features/mods/presentation/bloc/search_bloc.dart';
import 'package:busmod/features/mods/presentation/bloc/search_event.dart';
import 'package:busmod/features/mods/presentation/bloc/search_state.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

/// Serves one card whose id changes with [id], so a stale cache is visible.
class _Server implements HttpClientAdapter {
  int calls = 0;
  int id = 1;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    return ResponseBody.fromString(
      jsonEncode([
        {
          'sourceId': id,
          'type': 'bus',
          'title': 't$id',
          'download': {'storageUrl': 'https://cdn.test/$id.zip'},
        },
      ]),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _config = AppConfig(
  env: AppEnv.dev,
  baseUrl: 'https://api.busmod.test',
  enableLogging: false,
  appName: 'Busmod (Test)',
);

void main() {
  late _Server server;
  late ModsRepositoryImpl repo;
  const bus = ModQuery(type: ModType.bus);

  setUp(() {
    server = _Server();
    final dio = buildDio(_config, MemCacheStore())..httpClientAdapter = server;
    repo = ModsRepositoryImpl(ModsRemoteDataSource(dio));
  });

  List<int> ids(page) => [for (final c in page.items) c.sourceId as int];

  test(
    'list: normal read is cached, forceRefresh hits network + updates cache',
    () async {
      final first = (await repo.list(
        bus,
        skip: 0,
      )).getOrElse((f) => fail('$f'));
      server.id = 2;
      final cached = (await repo.list(
        bus,
        skip: 0,
      )).getOrElse((f) => fail('$f'));
      expect(server.calls, 1);
      expect(ids(cached), ids(first));

      final fresh = (await repo.list(
        bus,
        skip: 0,
        forceRefresh: true,
      )).getOrElse((f) => fail('$f'));
      expect(server.calls, 2);
      expect(ids(fresh), [2]);

      final after = (await repo.list(
        bus,
        skip: 0,
      )).getOrElse((f) => fail('$f'));
      expect(server.calls, 2);
      expect(ids(after), [2]);
    },
  );

  test('search: normal read is cached, forceRefresh hits network', () async {
    await repo.search(query: 'volvo', skip: 0);
    server.id = 2;
    await repo.search(query: 'volvo', skip: 0);
    expect(server.calls, 1);
    final fresh = (await repo.search(
      query: 'volvo',
      skip: 0,
      forceRefresh: true,
    )).getOrElse((f) => fail('$f'));
    expect(server.calls, 2);
    expect(ids(fresh), [2]);
    await repo.search(query: 'volvo', skip: 0);
    expect(server.calls, 2);
  });

  test(
    'ModListCubit.refresh shows the server change, load stays cached',
    () async {
      final cubit = ModListCubit(repo, ModType.bus);
      await cubit.load();
      server.id = 2;
      await cubit.load();
      expect(server.calls, 1);
      expect(ids(cubit.state as ModListSuccess), [1]);
      await cubit.refresh();
      expect(server.calls, 2);
      expect(ids(cubit.state as ModListSuccess), [2]);
      await cubit.close();
    },
  );

  test('SearchBloc refresh shows the server change', () async {
    final bloc = SearchBloc(repo)..add(const SearchEvent.queryChanged('volvo'));
    await Future<void>.delayed(
      SearchBloc.debounce + const Duration(milliseconds: 200),
    );
    server.id = 2;
    expect(server.calls, 1);
    bloc.add(const SearchEvent.refresh());
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(server.calls, 2);
    expect(ids(bloc.state as SearchSuccess), [2]);
    await bloc.close();
  });
}
