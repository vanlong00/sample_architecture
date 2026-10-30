import 'package:busmod/bootstrap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'installErrorHooks reports Flutter and uncaught async errors as fatal',
    () {
      final prevFlutter = FlutterError.onError;
      final prevPlatform = PlatformDispatcher.instance.onError;
      final prevPrint = debugPrint;
      final prints = <String>[];
      debugPrint = (message, {wrapWidth}) => prints.add(message ?? '');
      addTearDown(() {
        debugPrint = prevPrint;
        FlutterError.onError = prevFlutter;
        PlatformDispatcher.instance.onError = prevPlatform;
      });

      installErrorHooks();

      bool reported(String what) =>
          prints.any((p) => p.contains('[Error fatal]') && p.contains(what));

      FlutterError.onError!(
        FlutterErrorDetails(exception: StateError('framework boom')),
      );
      expect(reported('framework boom'), isTrue);

      final handled = PlatformDispatcher.instance.onError!(
        StateError('async boom'),
        StackTrace.current,
      );
      expect(handled, isTrue);
      expect(reported('async boom'), isTrue);
    },
  );
}
