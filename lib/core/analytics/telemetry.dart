import 'package:flutter/widgets.dart';

// Phase 2 swaps these bodies for Crashlytics / Firebase Analytics.

void recordError(
  Object error,
  StackTrace stack, {
  String? reason,
  bool fatal = false,
}) {
  debugPrint('[Error${fatal ? ' fatal' : ''}] ${reason ?? ''} $error\n$stack');
}

void logEvent(String name, [Map<String, Object>? params]) {
  debugPrint('[Event] $name ${params ?? const {}}');
}

List<NavigatorObserver> get telemetryObservers => const [];
