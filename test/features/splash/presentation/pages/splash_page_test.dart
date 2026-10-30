import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:busmod/features/splash/presentation/bloc/splash_state.dart';
import 'package:busmod/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSplashCubit extends MockCubit<SplashState> implements SplashCubit {}

void main() {
  late MockSplashCubit cubit;
  late int homeBuilds;

  setUp(() {
    cubit = MockSplashCubit();
    homeBuilds = 0;
    when(() => cubit.start()).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
    MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => BlocProvider<SplashCubit>.value(
              value: cubit,
              child: const SplashPage(),
            ),
          ),
          GoRoute(
            path: '/home',
            builder: (_, _) {
              homeBuilds++;
              return const Text('home-stub');
            },
          ),
        ],
      ),
    ),
  );

  testWidgets('calls start() exactly once on first frame', (tester) async {
    whenListen(
      cubit,
      const Stream<SplashState>.empty(),
      initialState: const SplashState.initial(),
    );
    await pump(tester);
    await tester.pump();
    verify(() => cubit.start()).called(1);
  });

  testWidgets('loading shows title and progress, no navigation', (
    tester,
  ) async {
    whenListen(
      cubit,
      const Stream<SplashState>.empty(),
      initialState: const SplashState.loading(),
    );
    await pump(tester);
    await tester.pump();
    expect(find.text('Busmod'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('home-stub'), findsNothing);
    expect(homeBuilds, 0);
  });

  testWidgets('initial then ready navigates to /home once', (tester) async {
    whenListen(
      cubit,
      Stream.fromIterable(const [SplashState.loading(), SplashState.ready()]),
      initialState: const SplashState.initial(),
    );
    await pump(tester);
    await tester.pumpAndSettle();
    expect(find.text('home-stub'), findsOneWidget);
    expect(homeBuilds, 1);
    verify(() => cubit.start()).called(1);
  });

  testWidgets('already ready navigates once', (tester) async {
    whenListen(
      cubit,
      const Stream<SplashState>.empty(),
      initialState: const SplashState.ready(),
    );
    await pump(tester);
    await tester.pumpAndSettle();
    expect(find.text('home-stub'), findsOneWidget);
    expect(homeBuilds, 1);
  });
}
