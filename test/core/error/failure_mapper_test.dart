import 'package:flutter_test/flutter_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/error/failure_mapper.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/core/l10n/app_localizations_en.dart';
import 'package:busmod/core/l10n/app_localizations_vi.dart';

void main() {
  final AppLocalizations l10n = AppLocalizationsEn();

  test('network Failure → message mạng', () {
    expect(
      mapFailureToMessage(const Failure.network(), l10n),
      l10n.errorNetwork,
    );
  });

  test('unauthorized Failure → message hết phiên', () {
    expect(
      mapFailureToMessage(const Failure.unauthorized(), l10n),
      l10n.errorUnauthorized,
    );
  });

  test('server/unknown/cache never leak the raw technical message', () {
    const raw = 'DioException [bad response] SocketException 500 stack';
    for (final l in [l10n, AppLocalizationsVi()]) {
      final messages = [
        mapFailureToMessage(const Failure.server(message: raw, code: 500), l),
        mapFailureToMessage(const Failure.unknown(raw), l),
        mapFailureToMessage(const Failure.cache(), l),
      ];
      expect(messages, [l.errorServer, l.errorUnknown, l.errorCache]);
      for (final m in messages) {
        expect(m, isNotEmpty);
        expect(m, isNot(contains('Exception')));
      }
    }
  });

  test('server 404 -> mod no longer available (en + vi)', () {
    for (final l in [l10n, AppLocalizationsVi()]) {
      expect(
        mapFailureToMessage(const Failure.server(code: 404), l),
        l.errorModNotAvailable,
      );
    }
    expect(l10n.errorModNotAvailable, 'This mod is no longer available');
    expect(
      AppLocalizationsVi().errorModNotAvailable,
      'Mod này không còn khả dụng',
    );
  });

  group('FileSystemException carried by Failure.unknown', () {
    const full =
        "FileSystemException: writeFrom failed, path = '/x/a.zip' "
        '(OS Error: No space left on device, errno = 28)';
    const other =
        "FileSystemException: Cannot open file, path = '/x/a.zip' "
        '(OS Error: Permission denied, errno = 13)';

    test('ENOSPC -> errorStorageFull (en + vi)', () {
      for (final l in [l10n, AppLocalizationsVi()]) {
        expect(
          mapFailureToMessage(const Failure.unknown(full), l),
          l.errorStorageFull,
        );
      }
    });

    test('other file errors -> errorCache, never raw text', () {
      expect(
        mapFailureToMessage(const Failure.unknown(other), l10n),
        l10n.errorCache,
      );
    });
  });
}
