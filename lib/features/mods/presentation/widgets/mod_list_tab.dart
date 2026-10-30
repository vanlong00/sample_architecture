import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ads/controllers/native_ad_controller.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../data/models/mod_query.dart';
import '../../data/models/mod_type.dart';
import '../bloc/mod_list_cubit.dart';
import '../bloc/mod_list_state.dart';
import 'filter_sheet.dart';
import 'mod_paged_list.dart';

/// One Home tab: sort + filter header over a paged list of [type] mods.
/// Owns its [ModListCubit]; kept alive so tab switches do not reload.
class ModListTab extends StatefulWidget {
  const ModListTab({required this.type, super.key});

  final ModType type;

  @override
  State<ModListTab> createState() => _ModListTabState();
}

class _ModListTabState extends State<ModListTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => getIt<ModListCubit>(param1: widget.type)..load(),
      child: Column(
        children: [
          _Header(type: widget.type),
          const Expanded(child: _Body()),
        ],
      ),
    );
  }
}

ModQuery? _queryOf(ModListState s) => switch (s) {
  ModListInitial() => null,
  ModListLoading(:final query) => query,
  ModListSuccess(:final query) => query,
  ModListFailure(:final query) => query,
};

class _Header extends StatelessWidget {
  const _Header({required this.type});

  final ModType type;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<ModListCubit, ModListState, ModQuery?>(
      selector: _queryOf,
      builder: (context, query) {
        final sort = query?.sort ?? ModSort.popular;
        final cubit = context.read<ModListCubit>();
        final filterActive =
            (query?.filter ?? const ModFilter()) != const ModFilter();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.sortPopular),
                      selected: sort == ModSort.popular,
                      onSelected: (_) => cubit.setSort(ModSort.popular),
                    ),
                    ChoiceChip(
                      label: Text(l10n.sortNewest),
                      selected: sort == ModSort.newest,
                      onSelected: (_) => cubit.setSort(ModSort.newest),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: query == null
                    ? null
                    : () async {
                        final result = await showFilterSheet(
                          context,
                          type: type,
                          current: query.filter,
                        );
                        if (result != null) cubit.setFilter(result);
                      },
                icon: Badge(
                  isLabelVisible: filterActive,
                  smallSize: 8,
                  child: const Icon(Icons.tune),
                ),
                label: Text(l10n.filterTitle),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ModListCubit>();
    return BlocBuilder<ModListCubit, ModListState>(
      builder: (context, state) => switch (state) {
        ModListInitial() || ModListLoading() => const LoadingView(),
        ModListFailure(:final failure) => ErrorView(
          message: mapFailureToMessage(failure, context.l10n),
          onRetry: cubit.load,
        ),
        ModListSuccess() => ModPagedList(
          items: state.items,
          hasMore: state.hasMore,
          loadingMore: state.loadingMore,
          loadMoreFailure: state.loadMoreFailure,
          onLoadMore: cubit.loadMore,
          onRefresh: cubit.refresh,
          onTap: (card) => context.push(Routes.modDetailOf(card.sourceId)),
          adSlot: NativeAdSlot.modList,
        ),
      },
    );
  }
}
