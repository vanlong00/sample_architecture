import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../bloc/splash_cubit.dart';
import '../bloc/splash_state.dart';

/// Boot screen. Starts [SplashCubit] on the first frame and leaves for home
/// once the cubit reports ready.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<SplashCubit>();
      cubit.start();
      // BlocListener ignores the state it is built with.
      if (cubit.state is SplashReady) _goHome();
    });
  }

  void _goHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<SplashCubit, SplashState>(
      listenWhen: (_, current) => current is SplashReady,
      listener: (_, _) => _goHome(),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.appTitle,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Semantics(
                label: context.l10n.appTitle,
                child: const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
