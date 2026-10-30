import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/analytics/telemetry.dart';
import 'core/config/env.dart';
import 'core/di/injector.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    recordError(error, stackTrace, reason: 'Bloc ${bloc.runtimeType}');
    super.onError(bloc, error, stackTrace);
  }
}

/// Routes framework and uncaught async errors to [recordError]. Debug builds
/// keep the console dump.
void installErrorHooks() {
  FlutterError.onError = (details) {
    if (kDebugMode) FlutterError.dumpErrorToConsole(details);
    recordError(
      details.exception,
      details.stack ?? StackTrace.empty,
      reason: details.context?.toDescription() ?? 'FlutterError',
      fatal: true,
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    recordError(error, stack, reason: 'PlatformDispatcher', fatal: true);
    return true;
  };
}

Future<void> bootstrap(AppEnv env) async {
  WidgetsFlutterBinding.ensureInitialized();
  installErrorHooks();
  Bloc.observer = AppBlocObserver();
  await configureDependencies(env);
  runApp(const App());
}
