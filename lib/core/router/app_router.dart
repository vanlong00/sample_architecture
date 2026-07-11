import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injector.dart';
import '../../features/articles/presentation/bloc/articles_cubit.dart';
import '../../features/articles/presentation/pages/articles_page.dart';
import 'routes.dart';

@lazySingleton
class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: Routes.articles,
    routes: [
      GoRoute(
        path: Routes.articles,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<ArticlesCubit>(),
          child: const ArticlesPage(),
        ),
      ),
    ],
  );
}
