import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../data/models/mod_download_record.dart';
import '../bloc/downloaded_cubit.dart';
import '../bloc/downloaded_state.dart';
import '../widgets/downloaded_tile.dart';
import '../widgets/import_action.dart';

class DownloadedPage extends StatefulWidget {
  const DownloadedPage({super.key});

  @override
  State<DownloadedPage> createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<DownloadedCubit>();
    if (cubit.state is DownloadedInitial) cubit.load();
  }

  Future<void> _delete(ModDownloadRecord record) async {
    final l10n = context.l10n;
    final cubit = context.read<DownloadedCubit>();
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.deleteConfirmTitle,
      message: l10n.deleteConfirmBody(record.title),
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final result = await cubit.delete(record);
    if (!mounted) return;
    result.mapLeft(
      (f) =>
          context.showAppSnackBar(mapFailureToMessage(f, l10n), isError: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDownloaded)),
      body: BlocBuilder<DownloadedCubit, DownloadedState>(
        builder: (context, state) => switch (state) {
          DownloadedInitial() || DownloadedLoading() => const LoadingView(),
          DownloadedFailure(:final failure) => ErrorView(
            message: mapFailureToMessage(failure, l10n),
            onRetry: context.read<DownloadedCubit>().load,
          ),
          DownloadedSuccess(:final records) when records.isEmpty => Center(
            child: Text(l10n.downloadedEmpty, textAlign: TextAlign.center),
          ),
          DownloadedSuccess(
            :final records,
            :final totalBytes,
            :final missingIds,
          ) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    l10n.downloadedTotal(formatBytes(totalBytes)),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: records.length,
                    itemBuilder: (context, i) {
                      final record = records[i];
                      return Padding(
                        key: ValueKey(record.sourceId),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DownloadedTile(
                          record: record,
                          missing: missingIds.contains(record.sourceId),
                          onImport: () {
                            final cubit = context.read<DownloadedCubit>();
                            return runImport(
                              context,
                              () => cubit.importToGame(record),
                              onFileMissing: () => cubit.markMissing(record),
                            );
                          },
                          onDelete: () => _delete(record),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}
