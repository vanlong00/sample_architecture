import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../features/downloads/presentation/bloc/downloaded_cubit.dart';
import '../../features/downloads/presentation/bloc/mod_download_cubit.dart';
import '../../features/downloads/presentation/pages/downloaded_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/mods/presentation/bloc/mod_detail_cubit.dart';
import '../../features/mods/presentation/bloc/search_bloc.dart';
import '../../features/mods/presentation/pages/home_page.dart';
import '../../features/mods/presentation/pages/mod_detail_page.dart';
import '../../features/mods/presentation/pages/search_page.dart';
import '../../features/premium/presentation/pages/paywall_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/bloc/splash_cubit.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../analytics/telemetry.dart';
import '../di/injector.dart';
import 'routes.dart';
import 'shell_scaffold.dart';

StatefulShellBranch _branch(String path, Widget Function() build) =>
    StatefulShellBranch(
      routes: [GoRoute(path: path, builder: (context, state) => build())],
    );

@lazySingleton
class AppRouter {
  final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  late final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.splash,
    observers: telemetryObservers,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<SplashCubit>(),
          child: const SplashPage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ShellScaffold(shell: shell),
        branches: [
          _branch(Routes.home, () => const HomePage()),
          _branch(
            Routes.search,
            () => BlocProvider(
              create: (_) => getIt<SearchBloc>(),
              child: const SearchPage(),
            ),
          ),
          _branch(
            Routes.downloads,
            () => BlocProvider(
              create: (_) => getIt<DownloadedCubit>()..load(),
              child: const DownloadedPage(),
            ),
          ),
          _branch(Routes.favorites, () => const FavoritesPage()),
          _branch(Routes.settings, () => const SettingsPage()),
        ],
      ),
      GoRoute(
        path: Routes.mod,
        parentNavigatorKey: _rootKey,
        redirect: (context, state) =>
            int.tryParse(state.pathParameters['sourceId'] ?? '') == null
            ? Routes.home
            : null,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['sourceId']!);
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<ModDetailCubit>()..load(id)),
              BlocProvider(create: (_) => getIt<ModDownloadCubit>()..check(id)),
            ],
            child: ModDetailPage(sourceId: id),
          );
        },
      ),
      // Pushed only from Settings; uses the app-level PaywallCubit.
      GoRoute(
        path: Routes.pro,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const PaywallPage(),
      ),
    ],
  );
}
