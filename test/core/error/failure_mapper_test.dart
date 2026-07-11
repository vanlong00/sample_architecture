import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/core/error/failure_mapper.dart';
import 'package:sample_architecture/core/l10n/app_localizations.dart';
import 'package:sample_architecture/core/l10n/app_localizations_en.dart';

void main() {
  final AppLocalizations l10n = AppLocalizationsEn();

  test('network Failure → message mạng', () {
    expect(mapFailureToMessage(const Failure.network(), l10n), l10n.errorNetwork);
  });

  test('unauthorized Failure → message hết phiên', () {
    expect(
      mapFailureToMessage(const Failure.unauthorized(), l10n),
      l10n.errorUnauthorized,
    );
  });
}
