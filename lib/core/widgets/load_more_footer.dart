import 'package:flutter/material.dart';

import '../error/failure.dart';
import '../error/failure_mapper.dart';
import '../l10n/l10n_ext.dart';

/// Bottom row of a paged list: spinner while [loading], message + retry button
/// when [error] is set (a `Failure` is localized, anything else is generic),
/// otherwise nothing.
class LoadMoreFooter extends StatelessWidget {
  const LoadMoreFooter({
    required this.loading,
    required this.onRetry,
    this.error,
    super.key,
  });

  final bool loading;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final error = this.error;
    if (error != null) {
      final l10n = context.l10n;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error is Failure
                  ? mapFailureToMessage(error, l10n)
                  : l10n.errorUnknown,
              textAlign: TextAlign.center,
            ),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      );
    }
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
