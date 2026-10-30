import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_links.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../premium/presentation/bloc/paywall_cubit.dart';
import '../../../premium/presentation/bloc/paywall_state.dart';
import '../../../premium/presentation/bloc/pro_status_cubit.dart';
import '../bloc/locale_cubit.dart';
import '../bloc/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        // The paywall page (pushed on top) handles its own feedback.
        if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
        switch (state) {
          case PaywallPurchased():
            context.showAppSnackBar(l10n.proPurchased);
          case PaywallRestored():
            context.showAppSnackBar(l10n.proRestored);
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
        appBar: AppBar(title: Text(l10n.navSettings)),
        body: ListView(
          children: [
            _SectionHeader(l10n.settingsTheme),
            const _ThemeSection(),
            _SectionHeader(l10n.settingsLanguage),
            const _LanguageSection(),
            const Divider(),
            const _ProTile(),
            const _RestoreTile(),
            const Divider(),
            _LinkTile(title: l10n.settingsPrivacy, url: privacyUrl),
            _LinkTile(title: l10n.settingsTerms, url: termsUrl),
            const _VersionTile(),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = {
      ThemeMode.system: l10n.themeSystem,
      ThemeMode.light: l10n.themeLight,
      ThemeMode.dark: l10n.themeDark,
    };
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) => RadioGroup<ThemeMode>(
        groupValue: mode,
        onChanged: (m) {
          if (m != null) context.read<ThemeCubit>().setMode(m);
        },
        child: Column(
          children: [
            for (final e in labels.entries)
              RadioListTile<ThemeMode>(value: e.key, title: Text(e.value)),
          ],
        ),
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection();

  // Language names are shown in their own language on purpose (no l10n).
  static const _languages = [
    (Locale('en'), 'English'),
    (Locale('vi'), 'Tiếng Việt'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) => RadioGroup<Locale>(
        groupValue: Locale(locale.languageCode),
        onChanged: (l) {
          if (l != null) context.read<LocaleCubit>().setLocale(l);
        },
        child: Column(
          children: [
            for (final (value, name) in _languages)
              RadioListTile<Locale>(value: value, title: Text(name)),
          ],
        ),
      ),
    );
  }
}

class _ProTile extends StatelessWidget {
  const _ProTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProStatusCubit, bool>(
      builder: (context, isPro) => ListTile(
        leading: const Icon(Icons.workspace_premium_outlined),
        title: Text(l10n.settingsPro),
        subtitle: isPro ? Text(l10n.proActive) : null,
        trailing: isPro
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : const Icon(Icons.chevron_right),
        onTap: isPro ? null : () => context.push(Routes.pro),
      ),
    );
  }
}

class _RestoreTile extends StatelessWidget {
  const _RestoreTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaywallCubit, PaywallState>(
      buildWhen: (p, c) =>
          (p is PaywallPurchasing) != (c is PaywallPurchasing) ||
          (p is PaywallRestoring) != (c is PaywallRestoring),
      builder: (context, state) {
        final busy = _busy(state);
        return ListTile(
          leading: const Icon(Icons.restore),
          title: Text(context.l10n.settingsRestore),
          trailing: state is PaywallRestoring
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
          onTap: busy ? null : context.read<PaywallCubit>().restore,
        );
      },
    );
  }

  static bool _busy(PaywallState s) =>
      s is PaywallRestoring || s is PaywallPurchasing;
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => unawaited(_open()),
    );
  }

  // ponytail: failures are swallowed; nothing useful to tell the user.
  Future<void> _open() async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}

class _VersionTile extends StatefulWidget {
  const _VersionTile();

  @override
  State<_VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<_VersionTile> {
  late final Future<PackageInfo> _info = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _info,
      builder: (context, snap) {
        final info = snap.data;
        if (info == null) return const SizedBox.shrink();
        return ListTile(
          title: Text(context.l10n.settingsVersion(info.version)),
        );
      },
    );
  }
}
