import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/telemetry.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../data/models/subscription_plan.dart';
import '../../data/subscription_service.dart';
import '../bloc/paywall_cubit.dart';
import '../bloc/paywall_state.dart';
import '../bloc/pro_status_cubit.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  @override
  void initState() {
    super.initState();
    logEvent('paywall_view');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<PaywallCubit, PaywallState>(
      listenWhen: (_, s) =>
          s is PaywallPurchased ||
          s is PaywallRestored ||
          s is PaywallInfo ||
          s is PaywallPending ||
          s is PaywallError,
      listener: (context, state) {
        switch (state) {
          case PaywallPurchased():
            context.showAppSnackBar(l10n.proPurchased);
            if (context.canPop()) context.pop();
          case PaywallRestored():
            context.showAppSnackBar(l10n.proRestored);
            if (context.canPop()) context.pop();
          case PaywallInfo():
            context.showAppSnackBar(l10n.proNothingToRestore);
          case PaywallPending():
            context.showAppSnackBar(l10n.proPending);
          case PaywallError():
            context.showAppSnackBar(
              state.fromRestore
                  ? l10n.proRestoreFailed
                  : l10n.proPurchaseFailed,
              isError: true,
            );
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.proTitle)),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(l10n.proBenefitNoAds),
            ),
            const SizedBox(height: 24),
            const _Actions(),
          ],
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isPro = context.select((ProStatusCubit c) => c.state);
    if (isPro) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.workspace_premium),
        title: Text(l10n.proActive),
      );
    }
    final cubit = context.read<PaywallCubit>();
    return ValueListenableBuilder<PlansStatus>(
      valueListenable: cubit.plansStatus,
      builder: (context, plans, _) => _buildActions(context, plans),
    );
  }

  Widget _buildActions(BuildContext context, PlansStatus plansStatus) {
    final l10n = context.l10n;
    final monthly = context
        .read<PaywallCubit>()
        .plans
        .where((o) => o.plan == SubscriptionPlan.monthly)
        .firstOrNull;
    // Never leave Subscribe live while the store is down: a tap would be dead.
    final unavailable = plansStatus == PlansStatus.unavailable;
    return BlocBuilder<PaywallCubit, PaywallState>(
      buildWhen: (p, c) =>
          (p is PaywallPurchasing) != (c is PaywallPurchasing) ||
          (p is PaywallRestoring) != (c is PaywallRestoring),
      builder: (context, state) {
        final busy = _busy(state);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (unavailable)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Text(l10n.proStoreUnavailable, textAlign: TextAlign.center),
                    TextButton(
                      onPressed: context.read<PaywallCubit>().reloadPlans,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            if (monthly != null && !unavailable)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  monthly.price,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            FilledButton(
              onPressed: monthly == null || unavailable || busy
                  ? null
                  : () => context.read<PaywallCubit>().startPlan(
                      SubscriptionPlan.monthly,
                    ),
              child: state is PaywallPurchasing
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.proSubscribe),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: busy ? null : context.read<PaywallCubit>().restore,
              child: state is PaywallRestoring
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.settingsRestore),
            ),
          ],
        );
      },
    );
  }

  static bool _busy(PaywallState s) =>
      s is PaywallRestoring || s is PaywallPurchasing;
}
