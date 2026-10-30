import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../data/models/filter_option.dart';
import '../../data/models/mod_query.dart';
import '../../data/models/mod_type.dart';
import '../bloc/filter_cubit.dart';
import '../bloc/filter_state.dart';

/// Returns the chosen filter, or null when dismissed.
Future<ModFilter?> showFilterSheet(
  BuildContext context, {
  required ModType type,
  required ModFilter current,
}) => showModalBottomSheet<ModFilter>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => BlocProvider(
    create: (_) => getIt<FilterCubit>()..load(type),
    child: _FilterSheet(type: type, current: current),
  ),
);

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.type, required this.current});

  final ModType type;
  final ModFilter current;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late ModFilter _filter = widget.current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.filterTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FilterCubit, FilterState>(
              builder: (context, state) => switch (state) {
                FilterInitial() || FilterLoading() => const LoadingView(),
                FilterFailure(:final failure) => ErrorView(
                  message: mapFailureToMessage(failure, l10n),
                  onRetry: () => context.read<FilterCubit>().load(widget.type),
                ),
                FilterSuccess(:final options) => ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _FilterSection(
                      title: l10n.filterBodyType,
                      type: widget.type,
                      options: options.categories,
                      selectedId: _filter.categoryId,
                      onSelected: (id) => setState(
                        () => _filter = ModFilter(
                          categoryId: id,
                          manufacturerId: _filter.manufacturerId,
                          countryId: _filter.countryId,
                        ),
                      ),
                    ),
                    _FilterSection(
                      title: l10n.filterManufacturer,
                      type: widget.type,
                      options: options.manufacturers,
                      selectedId: _filter.manufacturerId,
                      onSelected: (id) => setState(
                        () => _filter = ModFilter(
                          categoryId: _filter.categoryId,
                          manufacturerId: id,
                          countryId: _filter.countryId,
                        ),
                      ),
                    ),
                    _FilterSection(
                      title: l10n.filterCountry,
                      type: widget.type,
                      options: options.countries,
                      selectedId: _filter.countryId,
                      onSelected: (id) => setState(
                        () => _filter = ModFilter(
                          categoryId: _filter.categoryId,
                          manufacturerId: _filter.manufacturerId,
                          countryId: id,
                        ),
                      ),
                    ),
                  ],
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => _filter = const ModFilter()),
                    child: Text(l10n.filterReset),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_filter),
                    child: Text(l10n.filterApply),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Single-select chip group with a leading "All" (null id) option.
class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.type,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  final String title;
  final ModType type;
  final List<FilterOption> options;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final visible = options.where((o) => o.countFor(type) > 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text(context.l10n.filterAll),
              selected: selectedId == null,
              onSelected: (_) => onSelected(null),
            ),
            for (final o in visible)
              ChoiceChip(
                label: Text('${o.name} (${o.countFor(type)})'),
                selected: selectedId == o.id,
                onSelected: (_) => onSelected(o.id),
              ),
          ],
        ),
      ],
    );
  }
}
