import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ads/ads_service.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../mods/data/models/mod_detail.dart';
import '../../data/models/mod_download_record.dart';
import '../bloc/mod_download_cubit.dart';
import '../bloc/mod_download_state.dart';
import 'import_action.dart';

const _buttonSize = Size.fromHeight(48);

/// Download / progress / import control of the mod detail page.
/// Reads the [ModDownloadCubit] provided above it.
class DownloadCta extends StatelessWidget {
  const DownloadCta({required this.mod, super.key});

  final ModDetail mod;

  @override
  Widget build(BuildContext context) {
    if (!mod.isDownloadable) return const SizedBox.shrink();
    return BlocBuilder<ModDownloadCubit, ModDownloadState>(
      builder: (context, state) => switch (state) {
        ModDownloadChecking() => const _Checking(),
        ModDownloadIdle() => _DownloadButton(mod: mod),
        ModDownloadDownloading(:final received, :final total) => _Progress(
          received: received,
          total: total,
        ),
        ModDownloadDownloaded(:final record) => _ImportButton(record: record),
        ModDownloadFileMissing() => _Retry(
          message: context.l10n.ctaFileMissing,
          label: context.l10n.ctaRedownload,
          onPressed: () => context.read<ModDownloadCubit>().start(mod),
        ),
        ModDownloadFailure(:final failure, :final previous) => _Failed(
          mod: mod,
          failure: failure,
          previous: previous,
        ),
        ModDownloadCheckFailure(:final failure) => _Retry(
          message: mapFailureToMessage(failure, context.l10n),
          label: context.l10n.retry,
          onPressed: () => context.read<ModDownloadCubit>().check(mod.sourceId),
        ),
      },
    );
  }
}

/// Disabled placeholder until the stored state is known (never "Download").
class _Checking extends StatelessWidget {
  const _Checking();

  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(minimumSize: _buttonSize),
    onPressed: null,
    child: const SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({required this.mod});

  final ModDetail mod;

  Future<void> _download(BuildContext context) async {
    final cubit = context.read<ModDownloadCubit>();
    try {
      await maybeAdsService()?.showInterstitialAd();
    } catch (_) {
      // An ad problem must never block the download.
    }
    if (cubit.isClosed) return;
    await cubit.start(mod);
  }

  // Guarded: a double tap while the interstitial loads must not count the
  // ad (frequency cap) twice.
  @override
  Widget build(BuildContext context) => ImportGuard(
    run: () => _download(context),
    builder: (context, onPressed) => FilledButton(
      style: FilledButton.styleFrom(minimumSize: _buttonSize),
      onPressed: onPressed,
      child: Text(context.l10n.ctaDownload),
    ),
  );
}

class _Progress extends StatelessWidget {
  const _Progress({required this.received, required this.total});

  final int received;
  final int total;

  @override
  Widget build(BuildContext context) {
    final known = total > 0;
    final percent = known ? (received * 100 ~/ total).clamp(0, 100) : 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: known ? percent / 100 : null),
        if (known)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              context.l10n.ctaDownloading(percent),
              textAlign: TextAlign.center,
            ),
          ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: _buttonSize),
          onPressed: context.read<ModDownloadCubit>().cancel,
          child: Text(context.l10n.ctaCancel),
        ),
      ],
    );
  }
}

class _ImportButton extends StatelessWidget {
  const _ImportButton({required this.record});

  final ModDownloadRecord record;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ModDownloadCubit>();
    return ImportGuard(
      run: () => runImport(
        context,
        () => cubit.importToGame(record),
        // Moves the CTA to fileMissing.
        onFileMissing: () => cubit.check(record.sourceId),
      ),
      builder: (context, onPressed) => FilledButton(
        style: FilledButton.styleFrom(minimumSize: _buttonSize),
        onPressed: onPressed,
        child: Text(context.l10n.ctaImport),
      ),
    );
  }
}

/// Failed download. 404 (file gone from the CDN): no Retry, it cannot work.
/// A failed re-download keeps Import for the [previous] copy; a failed first
/// download offers only Retry.
class _Failed extends StatelessWidget {
  const _Failed({
    required this.mod,
    required this.failure,
    required this.previous,
  });

  final ModDetail mod;
  final Failure failure;
  final ModDownloadRecord? previous;

  @override
  Widget build(BuildContext context) {
    final message = mapFailureToMessage(failure, context.l10n);
    final f = failure;
    final canRetry = !(f is ServerFailure && f.code == 404);
    final retry = canRetry
        ? _Retry(
            message: previous == null ? message : null,
            label: context.l10n.retry,
            onPressed: () => context.read<ModDownloadCubit>().start(mod),
            filled: previous == null,
          )
        : null;
    final prev = previous;
    if (prev == null) {
      return retry ??
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(message, textAlign: TextAlign.center),
          );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(message, textAlign: TextAlign.center),
        ),
        _ImportButton(record: prev),
        if (retry != null) ...[const SizedBox(height: 8), retry],
      ],
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({
    required this.message,
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  /// `null` when the caller already shows the message.
  final String? message;
  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (message != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(message!, textAlign: TextAlign.center),
        ),
      if (filled)
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: _buttonSize),
          onPressed: onPressed,
          child: Text(label),
        )
      else
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: _buttonSize),
          onPressed: onPressed,
          child: Text(label),
        ),
    ],
  );
}
