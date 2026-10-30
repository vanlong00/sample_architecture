import 'package:flutter/material.dart';

extension AppSnackBarX on BuildContext {
  /// Replaces any visible snackbar with a floating one.
  void showAppSnackBar(String message, {bool isError = false}) {
    final scheme = Theme.of(this).colorScheme;
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: isError ? TextStyle(color: scheme.onError) : null,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? scheme.error : null,
        ),
      );
  }
}
