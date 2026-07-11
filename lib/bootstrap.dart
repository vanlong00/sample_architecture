import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/config/env.dart';
import 'core/di/injector.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('[Bloc error] ${bloc.runtimeType}: $error');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(AppEnv env) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await configureDependencies(env);
  runApp(const App());
}
