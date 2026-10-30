import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../mods/data/models/mod_detail.dart';
import '../bloc/favorites_cubit.dart';
import '../bloc/favorites_state.dart';

/// Heart toggle for [mod]. Reads the app-level [FavoritesCubit].
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.mod, super.key});

  final ModDetail mod;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<FavoritesCubit, FavoritesState, bool>(
      selector: (state) => state.isFavorite(mod.sourceId),
      builder: (context, isFavorite) {
        final label = isFavorite ? l10n.favoriteRemove : l10n.favoriteAdd;
        return Semantics(
          button: true,
          label: label,
          excludeSemantics: true,
          child: IconButton(
            tooltip: label,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => context.read<FavoritesCubit>().toggle(mod),
          ),
        );
      },
    );
  }
}
