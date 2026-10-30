import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../downloads/presentation/widgets/download_cta.dart';
import '../../../favorites/presentation/widgets/favorite_button.dart';
import '../../data/models/mod_card.dart';
import '../../data/models/mod_detail.dart';
import '../bloc/mod_detail_cubit.dart';
import '../bloc/mod_detail_state.dart';
import '../widgets/detail_chips.dart';
import '../widgets/detail_gallery.dart';
import '../widgets/detail_html.dart';
import '../widgets/detail_related.dart';
import '../widgets/detail_specs.dart';

/// Mod detail. [ModDetailCubit] (and `ModDownloadCubit`) come from above.
class ModDetailPage extends StatelessWidget {
  const ModDetailPage({required this.sourceId, super.key});

  final int sourceId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModDetailCubit, ModDetailState>(
      builder: (context, state) => switch (state) {
        ModDetailSuccess(:final mod, :final related) => _DetailScaffold(
          mod: mod,
          related: related,
        ),
        ModDetailFailure(:final failure) => Scaffold(
          appBar: AppBar(),
          body: ErrorView(
            message: mapFailureToMessage(failure, context.l10n),
            // 404 = no longer available: retrying the same request is futile.
            onRetry: failure is ServerFailure && failure.code == 404
                ? null
                : () => context.read<ModDetailCubit>().load(sourceId),
          ),
        ),
        _ => Scaffold(appBar: AppBar(), body: const LoadingView()),
      },
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({required this.mod, required this.related});

  final ModDetail mod;
  final List<ModCard> related;

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);
    const pad = EdgeInsets.symmetric(horizontal: 16);
    return Scaffold(
      appBar: AppBar(
        title: Text(mod.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [FavoriteButton(mod: mod)],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailGallery(media: mod.media),
                  gap,
                  Padding(
                    padding: pad,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mod.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        DetailChips(mod: mod),
                        gap,
                        DetailSpecs(specs: mod.specs),
                        gap,
                        DetailHtml(html: mod.contentHtml),
                      ],
                    ),
                  ),
                  DetailRelated(
                    related: related,
                    manufacturerName: mod.manufacturer?.name,
                  ),
                  gap,
                ],
              ),
            ),
          ),
          // Nothing to download (not mirrored): no empty bar.
          if (mod.isDownloadable)
            Material(
              elevation: 3,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: DownloadCta(mod: mod),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
