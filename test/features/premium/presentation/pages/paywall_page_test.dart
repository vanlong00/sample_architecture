import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/premium/data/models/subscription_plan.dart';
import 'package:busmod/features/premium/data/subscription_service.dart';
import 'package:busmod/features/premium/presentation/bloc/paywall_cubit.dart';
import 'package:busmod/features/premium/presentation/bloc/paywall_state.dart';
import 'package:busmod/features/premium/presentation/bloc/pro_status_cubit.dart';
import 'package:busmod/features/premium/presentation/pages/paywall_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mocktail/mocktail.dart';

class MockPaywallCubit extends MockCubit<PaywallState>
    implements PaywallCubit {}

class MockProStatusCubit extends MockCubit<bool> implements ProStatusCubit {}

final _monthly = SubscriptionPlanOption(
  plan: SubscriptionPlan.monthly,
  details: ProductDetails(
    id: SubscriptionPlan.productId,
    title: 't',
    description: 'd',
    price: r'$3.99',
    rawPrice: 3.99,
    currencyCode: 'USD',
  ),
  price: r'$3.99',
);

void main() {
  setUpAll(() => registerFallbackValue(SubscriptionPlan.monthly));

  late MockPaywallCubit paywall;
  late MockProStatusCubit pro;
  late StreamController<PaywallState> stream;
  late ValueNotifier<PlansStatus> status;

  setUp(() {
    paywall = MockPaywallCubit();
    pro = MockProStatusCubit();
    stream = StreamController<PaywallState>.broadcast();
    status = ValueNotifier(PlansStatus.ready);
    when(() => paywall.plans).thenReturn([_monthly]);
    when(() => paywall.plansStatus).thenReturn(status);
    when(() => paywall.reloadPlans()).thenAnswer((_) async {});
    when(() => paywall.startPlan(any())).thenAnswer((_) async {});
    when(() => paywall.restore()).thenAnswer((_) async {});
    whenListen(pro, const Stream<bool>.empty(), initialState: false);
    whenListen(paywall, stream.stream, initialState: const PaywallState.idle());
  });

  tearDown(() => stream.close());

  Future<void> pump(WidgetTester t) async {
    final router = GoRouter(
      initialLocation: '/pro',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('home')),
        ),
        GoRoute(path: '/pro', builder: (_, _) => const PaywallPage()),
      ],
    );
    // Make `/pro` poppable.
    router.go('/');
    await t.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PaywallCubit>.value(value: paywall),
          BlocProvider<ProStatusCubit>.value(value: pro),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
        ),
      ),
    );
    unawaited(router.push('/pro'));
    await t.pump();
    await t.pump(const Duration(seconds: 1));
  }

  FilledButton subscribeButton(WidgetTester t) =>
      t.widget<FilledButton>(find.byType(FilledButton));

  testWidgets('shows title, benefit and price; subscribe calls startPlan', (
    t,
  ) async {
    await pump(t);
    expect(find.text('Busmod Pro'), findsOneWidget);
    expect(find.text('Remove all ads'), findsOneWidget);
    expect(find.text(r'$3.99'), findsOneWidget);
    await t.tap(find.text('Subscribe'));
    verify(() => paywall.startPlan(SubscriptionPlan.monthly)).called(1);
  });

  testWidgets('restore calls restore', (t) async {
    await pump(t);
    await t.tap(find.text('Restore purchases'));
    verify(() => paywall.restore()).called(1);
  });

  testWidgets('subscribe disabled when no plans, still loading: no message', (
    t,
  ) async {
    when(() => paywall.plans).thenReturn(const []);
    status.value = PlansStatus.loading;
    await pump(t);
    expect(subscribeButton(t).onPressed, isNull);
    expect(find.text('Store unavailable. Try again later.'), findsNothing);
  });

  testWidgets('unavailable store shows message and Retry reloads', (t) async {
    when(() => paywall.plans).thenReturn(const []);
    status.value = PlansStatus.unavailable;
    await pump(t);
    expect(subscribeButton(t).onPressed, isNull);
    expect(find.text('Store unavailable. Try again later.'), findsOneWidget);
    await t.tap(find.text('Retry'));
    verify(() => paywall.reloadPlans()).called(1);
  });

  testWidgets('unavailable with plans still cached: no dead Subscribe', (
    t,
  ) async {
    status.value = PlansStatus.unavailable; // plans stay [_monthly]
    await pump(t);
    expect(subscribeButton(t).onPressed, isNull);
    expect(find.text('Store unavailable. Try again later.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('plans arriving later enable Subscribe', (t) async {
    when(() => paywall.plans).thenReturn(const []);
    status.value = PlansStatus.loading;
    await pump(t);
    when(() => paywall.plans).thenReturn([_monthly]);
    status.value = PlansStatus.ready;
    await t.pump();
    expect(subscribeButton(t).onPressed, isNotNull);
    expect(find.text(r'$3.99'), findsOneWidget);
  });

  testWidgets('buttons disabled with progress while purchasing', (t) async {
    whenListen(
      paywall,
      stream.stream,
      initialState: const PaywallState.purchasing(),
    );
    await pump(t);
    expect(subscribeButton(t).onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('buttons update when state turns restoring', (t) async {
    await pump(t);
    stream.add(const PaywallState.restoring());
    await t.pump();
    await t.pump();
    expect(subscribeButton(t).onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('owned state hides purchase button', (t) async {
    whenListen(pro, const Stream<bool>.empty(), initialState: true);
    await pump(t);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.text('You are Pro'), findsOneWidget);
  });

  testWidgets('purchased shows snackbar and pops', (t) async {
    await pump(t);
    stream.add(const PaywallState.purchased());
    await t.pump();
    await t.pump(const Duration(seconds: 1));
    expect(find.text('home'), findsOneWidget);
    expect(find.text('Welcome to Pro!'), findsWidgets);
    expect(find.text('Purchases restored'), findsNothing);
  });

  testWidgets('restored shows "Purchases restored" and pops', (t) async {
    await pump(t);
    stream.add(const PaywallState.restored());
    await t.pump();
    await t.pump(const Duration(seconds: 1));
    expect(find.text('home'), findsOneWidget);
    expect(find.text('Purchases restored'), findsWidgets);
  });

  for (final (state, text) in [
    (const PaywallState.info('x'), 'Nothing to restore'),
    (const PaywallState.error('boom'), 'Purchase failed'),
    (
      const PaywallState.error('boom', fromRestore: true),
      'Could not restore purchases. Try again later.',
    ),
  ]) {
    testWidgets('${state.runtimeType} shows "$text"', (t) async {
      await pump(t);
      stream.add(state);
      await t.pump();
      await t.pump();
      expect(find.text(text), findsOneWidget);
      expect(find.text('boom'), findsNothing);
    });
  }

  testWidgets('idle shows no snackbar', (t) async {
    await pump(t);
    stream.add(const PaywallState.idle());
    await t.pump();
    expect(find.byType(SnackBar), findsNothing);
  });
}
