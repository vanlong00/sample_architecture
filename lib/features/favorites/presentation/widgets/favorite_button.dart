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
        // The tooltip is the accessible name; IconButton keeps its tap action
        // and exposes the `selected` (toggled) state.
        return IconButton(
          tooltip: label,
          isSelected: isFavorite,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: const Icon(Icons.favorite_border),
          selectedIcon: const Icon(Icons.favorite),
          onPressed: () => context.read<FavoritesCubit>().toggle(mod),
        );
      },
    );
  }
}
