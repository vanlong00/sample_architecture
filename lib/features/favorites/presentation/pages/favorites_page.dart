import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/favorites_cubit.dart';
import '../bloc/favorites_state.dart';
import '../widgets/favorite_tile.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<FavoritesCubit>();
    if (cubit.state is FavoritesInitial) cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navFavorites)),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) => switch (state) {
          FavoritesInitial() || FavoritesLoading() => const LoadingView(),
          FavoritesFailure(:final failure) => ErrorView(
            message: mapFailureToMessage(failure, l10n),
            onRetry: context.read<FavoritesCubit>().load,
          ),
          FavoritesSuccess(:final items) when items.isEmpty => Center(
            child: Text(l10n.favoritesEmpty, textAlign: TextAlign.center),
          ),
          FavoritesSuccess(:final items) => ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final record = items[i];
              return Padding(
                key: ValueKey(record.sourceId),
                padding: const EdgeInsets.only(bottom: 12),
                child: FavoriteTile(
                  record: record,
                  onTap: () =>
                      context.push(Routes.modDetailOf(record.sourceId)),
                  onRemove: () =>
                      context.read<FavoritesCubit>().remove(record.sourceId),
                ),
              );
            },
          ),
        },
      ),
    );
  }
}
