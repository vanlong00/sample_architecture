@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/app.dart';
import 'package:sample_architecture/core/config/env.dart';
import 'package:sample_architecture/core/di/injector.dart';
import 'package:sample_architecture/features/articles/data/datasources/articles_remote_datasource.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';

class MockRemote extends Mock implements ArticlesRemoteDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await getIt.reset();
    // If Hive.initFlutter() partially succeeded (e.g. in an environment where
    // the path_provider channel is available), clean up any on-disk state so
    // tests don't leak into one another.
    try {
      await Hive.deleteFromDisk();
    } catch (_) {
      // No Hive state to clean up (init never completed); ignore.
    }
  });

  // Previously skipped: App.build() eagerly resolves ThemeCubit/LocaleCubit
  // via getIt, and both constructors used to call HiveService.read(...) ->
  // Hive.box(...) synchronously, which threw because no Hive box was ever
  // opened (Hive.initFlutter() never completes under plain `flutter test`,
  // which has no path_provider platform channel). That left ArticlesCubit
  // stuck in its initial/loading state and pumpAndSettle() never settled.
  //
  // Fixed by making ThemeCubit._load/LocaleCubit._load tolerate a missing
  // Hive box (try/catch falling back to defaults), so the cubits construct
  // fine even when Hive was never initialized. The remaining try/catch below
  // around configureDependencies still tolerates the same Hive.initFlutter()
  // platform-channel failure during DI setup.
  testWidgets(
    'app khoi dong va hien thi bai viet tu datasource (mock)',
    (tester) async {
      // configureDependencies registers AppConfig and calls getIt.init()
      // BEFORE `await getIt<HiveService>().init()`. Hive.initFlutter() needs
      // the path_provider platform channel, which is unavailable in plain
      // `flutter test` and throws. Because registration happens first, the
      // DI container is fully populated even when Hive init throws, so we
      // tolerate only that failure here (same approach as Task 6's
      // injector_test.dart) and then proceed to override the datasource and
      // pump the real App widget.
      try {
        await configureDependencies(AppEnv.dev);
      } on Object {
        // Expected: Hive.initFlutter() platform channel unavailable in
        // plain `flutter test`. Storage/Hive init behavior itself is
        // covered by Task 4's tests.
      }

      // Override the remote datasource with a mock so the app never touches
      // the network (or the Dio/AuthInterceptor/secure_storage chain, since
      // the mock bypasses Dio entirely).
      final mock = MockRemote();
      when(() => mock.getArticles()).thenAnswer(
        (_) async => const [Article(id: 1, title: 'Smoke', body: 'ok')],
      );
      getIt.unregister<ArticlesRemoteDataSource>();
      getIt.registerFactory<ArticlesRemoteDataSource>(() => mock);

      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Smoke'), findsOneWidget);
    },
  );
}
