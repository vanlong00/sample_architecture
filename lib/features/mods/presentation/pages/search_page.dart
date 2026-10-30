import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../data/models/mod_type.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/mod_paged_list.dart';
import '../widgets/mod_type_label.dart';

/// Search tab. Expects a [SearchBloc] provided above it (the router does).
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Restore the text if the bloc outlives this page (e.g. tab switch).
    final query = switch (context.read<SearchBloc>().state) {
      SearchInitial() => '',
      SearchLoading(:final query) ||
      SearchSuccess(:final query) ||
      SearchFailure(:final query) => query,
    };
    _controller = TextEditingController(text: query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQuery(String text) =>
      context.read<SearchBloc>().add(SearchEvent.queryChanged(text));

  void _clear() {
    _controller.clear();
    _onQuery('');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: _SearchField(
              controller: _controller,
              onChanged: _onQuery,
              onClear: _clear,
            ),
          ),
          const _TypeChips(),
          const Expanded(child: _SearchBody()),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: l10n.searchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  // Tooltip doubles as the accessibility label.
                  tooltip: l10n.searchClear,
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                ),
        ),
      ),
    );
  }
}

ModType? _typeOf(SearchState s) => switch (s) {
  SearchInitial(:final type) ||
  SearchLoading(:final type) ||
  SearchSuccess(:final type) ||
  SearchFailure(:final type) => type,
};

class _TypeChips extends StatelessWidget {
  const _TypeChips();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = context.select<SearchBloc, ModType?>(
      (b) => _typeOf(b.state),
    );
    void select(ModType? type) =>
        context.read<SearchBloc>().add(SearchEvent.typeChanged(type));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        spacing: 8,
        children: [
          ChoiceChip(
            label: Text(l10n.searchAllTypes),
            selected: selected == null,
            onSelected: (_) => select(null),
          ),
          for (final type in ModType.values)
            ChoiceChip(
              label: Text(modTypeLabel(type, l10n)),
              selected: selected == type,
              onSelected: (_) => select(type),
            ),
        ],
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<SearchBloc>();
    bloc.add(const SearchEvent.refresh());
    // Resolves once the re-run (loading) settles.
    await bloc.stream
        .skipWhile((s) => s is! SearchLoading)
        .firstWhere((s) => s is! SearchLoading, orElse: () => bloc.state);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) => switch (state) {
        SearchInitial() => _Prompt(text: l10n.searchHint),
        SearchLoading() => const LoadingView(),
        SearchSuccess(items: final items) when items.isEmpty => _Prompt(
          text: l10n.searchEmpty,
        ),
        SearchSuccess() => ModPagedList(
          items: state.items,
          hasMore: state.hasMore,
          loadingMore: state.loadingMore,
          loadMoreFailure: state.loadMoreFailure,
          onLoadMore: () =>
              context.read<SearchBloc>().add(const SearchEvent.loadMore()),
          onRefresh: () => _refresh(context),
          onTap: (card) => context.push(Routes.modDetailOf(card.sourceId)),
        ),
        SearchFailure(:final failure) => ErrorView(
          message: mapFailureToMessage(failure, l10n),
          onRetry: () =>
              context.read<SearchBloc>().add(const SearchEvent.retry()),
        ),
      },
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
