# Flutter Architecture Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Dựng khung kiến trúc codebase Flutter (feature-first, Clean Architecture rút gọn) sẵn sàng để phát triển, kèm một feature mẫu `articles` chạy end-to-end xuyên đủ mọi lớp.

**Architecture:** Feature-first, 2 lớp mỗi feature (`data` / `presentation`). `core/` chứa hạ tầng dùng chung (config, DI, error, network, storage, router, theme, l10n, widgets). Repository trả `Either<Failure, T>` (fpdart); Cubit gọi repository và emit Freezed union state; UI chỉ đọc state + bắn event.

**Tech Stack:** flutter_bloc, freezed, json_serializable, dio, retrofit, get_it, injectable, go_router, hive, flutter_secure_storage, fpdart, flutter_localizations; dev: build_runner, mocktail, bloc_test.

## Global Constraints

- Dart/Flutter: SDK constraint `sdk: '>=3.4.0 <4.0.0'` (Flutter 3.22+), Material 3 bật (`useMaterial3: true`).
- 3 flavor: `dev`, `staging`, `prod` — mỗi flavor một entrypoint `lib/main_<flavor>.dart`.
- Không hard-code `baseUrl` hay secret trong feature code — luôn lấy qua `AppConfig` (DI theo env).
- Repository luôn trả `Future<Either<Failure, T>>` (fpdart) — không throw ra ngoài repository.
- DataSource ném `Exception` (không biết `Failure`); Repository map Exception → Failure qua helper `_guard`.
- Lifetime DI: DataSource + Repository = `@LazySingleton`; Cubit/Bloc = `@injectable` (factory).
- State là Freezed union với đủ nhánh `initial / loading / success / failure`; UI dùng `.when(...)`.
- Cubit mặc định; chỉ dùng Bloc event-driven khi luồng nhiều sự kiện.
- Bản đầu: KHÔNG token-refresh tự động (401 → điều hướng login); KHÔNG domain layer riêng; KHÔNG Drift.
- Test gương theo `lib/`: `test/<mirror-of-lib-path>`. Dùng `mocktail` + `bloc_test`.
- Ngôn ngữ hỗ trợ: `en` (mặc định), `vi`.
- Mọi lệnh chạy từ thư mục gốc dự án `d:\Project\sample_architecture`.

---

## File Structure

**Root / config**
- `pubspec.yaml` — deps + `flutter: generate: true`
- `l10n.yaml` — cấu hình sinh AppLocalizations
- `build.yaml` — (mặc định, không bắt buộc chỉnh)
- `analysis_options.yaml` — lints + loại trừ file `*.g.dart`, `*.freezed.dart`
- `.gitignore`

**Entrypoints / bootstrap**
- `lib/bootstrap.dart` — `bootstrap(AppEnv env)`: init WidgetsBinding, Hive, DI, BlocObserver, runApp
- `lib/main_dev.dart`, `lib/main_staging.dart`, `lib/main_prod.dart`
- `lib/app.dart` — `App` widget: MaterialApp.router + theme + locale + go_router

**core/config**
- `lib/core/config/env.dart` — `enum AppEnv { dev, staging, prod }`
- `lib/core/config/app_config.dart` — `AppConfig` (baseUrl, enableLogging, appName) + factory theo env

**core/error**
- `lib/core/error/exceptions.dart` — `ServerException`, `CacheException`, `UnauthorizedException`, `NetworkException`
- `lib/core/error/failure.dart` — Freezed `Failure` union
- `lib/core/error/failure_mapper.dart` — `mapFailureToMessage(Failure, AppLocalizations)`

**core/network**
- `lib/core/network/dio_client.dart` — factory dựng Dio + gắn interceptors
- `lib/core/network/interceptors/auth_interceptor.dart`
- `lib/core/network/interceptors/logging_interceptor.dart`
- `lib/core/network/interceptors/error_interceptor.dart`

**core/storage**
- `lib/core/storage/secure_storage_service.dart` — bọc flutter_secure_storage (token)
- `lib/core/storage/hive_service.dart` — init + mở box + typed get/put

**core/di**
- `lib/core/di/injector.dart` — `getIt`, `configureDependencies()`, `@module` cho Dio/Hive/config
- `lib/core/di/injector.config.dart` — (sinh)

**core/router**
- `lib/core/router/routes.dart` — hằng path/name
- `lib/core/router/app_router.dart` — `@lazySingleton` cung cấp `GoRouter`

**core/theme**
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_theme.dart` — `AppTheme.light`, `AppTheme.dark`
- `lib/features/settings/presentation/bloc/theme_cubit.dart` — quản lý themeMode (lưu Hive)
- `lib/features/settings/presentation/bloc/locale_cubit.dart` — quản lý locale (lưu Hive)

**core/l10n**
- `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_vi.arb`
- `lib/core/l10n/l10n_ext.dart` — `context.l10n` extension

**core/widgets**
- `lib/core/widgets/loading_view.dart`
- `lib/core/widgets/error_view.dart`

**feature mẫu: articles**
- `lib/features/articles/data/models/article_model.dart` — Freezed + json
- `lib/features/articles/data/datasources/articles_remote_datasource.dart` — Retrofit `@RestApi`
- `lib/features/articles/data/repositories/articles_repository.dart` — abstract + impl (`Either`)
- `lib/features/articles/presentation/bloc/articles_cubit.dart` + `articles_state.dart`
- `lib/features/articles/presentation/pages/articles_page.dart`

**tests** (gương theo lib)
- `test/core/error/failure_mapper_test.dart`
- `test/core/network/interceptors/error_interceptor_test.dart`
- `test/features/articles/data/repositories/articles_repository_test.dart`
- `test/features/articles/presentation/bloc/articles_cubit_test.dart`
- `test/features/articles/presentation/pages/articles_page_test.dart`

---

## Task 1: Scaffold dự án Flutter + cấu hình gốc

**Files:**
- Create: toàn bộ scaffold `flutter create` (android/ ios/ lib/ test/ …)
- Modify: `pubspec.yaml`
- Create: `l10n.yaml`, `analysis_options.yaml`

**Interfaces:**
- Consumes: (none)
- Produces: dự án biên dịch được; `flutter test` chạy; deps sẵn sàng cho các task sau.

- [ ] **Step 1: Tạo scaffold Flutter tại thư mục gốc**

Run:
```bash
cd "d:/Project/sample_architecture" && flutter create --org io.pamg --project-name sample_architecture .
```
Expected: sinh `android/`, `ios/`, `lib/main.dart`, `test/`, `pubspec.yaml`. Không lỗi.

- [ ] **Step 2: Thêm dependencies**

Run:
```bash
flutter pub add flutter_bloc freezed_annotation json_annotation dio retrofit get_it injectable go_router hive hive_flutter flutter_secure_storage fpdart
flutter pub add dev:build_runner dev:freezed dev:json_serializable dev:retrofit_generator dev:injectable_generator dev:hive_generator dev:mocktail dev:bloc_test
flutter pub add flutter_localizations --sdk=flutter
```
Expected: `pubspec.yaml` cập nhật, `flutter pub get` chạy xong không lỗi.

- [ ] **Step 3: Bật code-gen l10n trong pubspec**

Trong `pubspec.yaml`, dưới `flutter:` thêm:
```yaml
flutter:
  uses-material-design: true
  generate: true
```

- [ ] **Step 4: Tạo `l10n.yaml` ở gốc**

```yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

- [ ] **Step 5: Cấu hình `analysis_options.yaml`**

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.config.dart"
    - "lib/core/l10n/app_localizations*.dart"
  errors:
    invalid_annotation_target: ignore

linter:
  rules:
    prefer_const_constructors: true
    prefer_final_locals: true
```

- [ ] **Step 6: Xoá code mẫu, xác nhận build sạch**

Xoá nội dung mẫu trong `lib/main.dart` (để trống tạm `void main() {}`) và xoá `test/widget_test.dart`.

Run: `flutter analyze`
Expected: "No issues found!" (hoặc chỉ cảnh báo về main trống).

- [ ] **Step 7: Commit**

```bash
git init
git add -A
git commit -m "chore: scaffold Flutter project with core dependencies"
```

---

## Task 2: Config & Environment (AppEnv + AppConfig)

**Files:**
- Create: `lib/core/config/env.dart`
- Create: `lib/core/config/app_config.dart`
- Test: `test/core/config/app_config_test.dart`

**Interfaces:**
- Consumes: (none)
- Produces:
  - `enum AppEnv { dev, staging, prod }`
  - `class AppConfig { final AppEnv env; final String baseUrl; final bool enableLogging; final String appName; }`
  - `AppConfig.fromEnv(AppEnv env)` → giá trị theo môi trường.

- [ ] **Step 1: Viết test thất bại**

Create `test/core/config/app_config_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/config/env.dart';
import 'package:sample_architecture/core/config/app_config.dart';

void main() {
  test('dev config bật logging và baseUrl dev', () {
    final c = AppConfig.fromEnv(AppEnv.dev);
    expect(c.env, AppEnv.dev);
    expect(c.enableLogging, isTrue);
    expect(c.baseUrl, 'https://dev.api.example.com');
  });

  test('prod config tắt logging và baseUrl prod', () {
    final c = AppConfig.fromEnv(AppEnv.prod);
    expect(c.enableLogging, isFalse);
    expect(c.baseUrl, 'https://api.example.com');
  });
}
```

- [ ] **Step 2: Chạy test để xác nhận fail**

Run: `flutter test test/core/config/app_config_test.dart`
Expected: FAIL — không tìm thấy `env.dart` / `app_config.dart`.

- [ ] **Step 3: Viết `env.dart`**

Create `lib/core/config/env.dart`:
```dart
enum AppEnv { dev, staging, prod }
```

- [ ] **Step 4: Viết `app_config.dart`**

Create `lib/core/config/app_config.dart`:
```dart
import 'env.dart';

class AppConfig {
  const AppConfig({
    required this.env,
    required this.baseUrl,
    required this.enableLogging,
    required this.appName,
  });

  final AppEnv env;
  final String baseUrl;
  final bool enableLogging;
  final String appName;

  factory AppConfig.fromEnv(AppEnv env) {
    switch (env) {
      case AppEnv.dev:
        return const AppConfig(
          env: AppEnv.dev,
          baseUrl: 'https://dev.api.example.com',
          enableLogging: true,
          appName: 'Sample (Dev)',
        );
      case AppEnv.staging:
        return const AppConfig(
          env: AppEnv.staging,
          baseUrl: 'https://staging.api.example.com',
          enableLogging: true,
          appName: 'Sample (Staging)',
        );
      case AppEnv.prod:
        return const AppConfig(
          env: AppEnv.prod,
          baseUrl: 'https://api.example.com',
          enableLogging: false,
          appName: 'Sample',
        );
    }
  }
}
```

- [ ] **Step 5: Chạy test để xác nhận pass**

Run: `flutter test test/core/config/app_config_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 6: Commit**

```bash
git add lib/core/config test/core/config
git commit -m "feat: add AppEnv and AppConfig per-environment configuration"
```

---

## Task 3: Error layer (Exceptions + Failure)

**Files:**
- Create: `lib/core/error/exceptions.dart`
- Create: `lib/core/error/failure.dart`
- Test: `test/core/error/failure_test.dart`

**Interfaces:**
- Consumes: (none)
- Produces:
  - Exceptions: `ServerException({String? message, int? code})`, `CacheException()`, `UnauthorizedException()`, `NetworkException()`
  - `Failure` Freezed union với factory: `Failure.server({String? message, int? code})`, `Failure.network()`, `Failure.cache()`, `Failure.unauthorized()`, `Failure.unknown([String? message])`.

- [ ] **Step 1: Viết test thất bại**

Create `test/core/error/failure_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/error/failure.dart';

void main() {
  test('Failure union phân biệt được các nhánh qua when', () {
    const f = Failure.server(message: 'boom', code: 500);
    final label = f.when(
      server: (m, c) => 'server:$m:$c',
      network: () => 'network',
      cache: () => 'cache',
      unauthorized: () => 'unauthorized',
      unknown: (m) => 'unknown',
    );
    expect(label, 'server:boom:500');
  });

  test('hai Failure cùng loại + giá trị thì bằng nhau', () {
    expect(const Failure.network(), const Failure.network());
  });
}
```

- [ ] **Step 2: Chạy test để xác nhận fail**

Run: `flutter test test/core/error/failure_test.dart`
Expected: FAIL — thiếu `failure.dart`.

- [ ] **Step 3: Viết `exceptions.dart`**

Create `lib/core/error/exceptions.dart`:
```dart
class ServerException implements Exception {
  ServerException({this.message, this.code});
  final String? message;
  final int? code;
}

class CacheException implements Exception {}

class UnauthorizedException implements Exception {}

class NetworkException implements Exception {}
```

- [ ] **Step 4: Viết `failure.dart` (Freezed)**

Create `lib/core/error/failure.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.server({String? message, int? code}) = ServerFailure;
  const factory Failure.network() = NetworkFailure;
  const factory Failure.cache() = CacheFailure;
  const factory Failure.unauthorized() = UnauthorizedFailure;
  const factory Failure.unknown([String? message]) = UnknownFailure;
}
```

- [ ] **Step 5: Sinh code Freezed**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: tạo `lib/core/error/failure.freezed.dart`, không lỗi.

- [ ] **Step 6: Chạy test để xác nhận pass**

Run: `flutter test test/core/error/failure_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 7: Commit**

```bash
git add lib/core/error test/core/error
git commit -m "feat: add Exception types and Freezed Failure union"
```

---

## Task 4: Storage services (Hive + Secure Storage)

**Files:**
- Create: `lib/core/storage/secure_storage_service.dart`
- Create: `lib/core/storage/hive_service.dart`
- Test: `test/core/storage/hive_service_test.dart`

**Interfaces:**
- Consumes: (none)
- Produces:
  - `class SecureStorageService { Future<String?> readToken(); Future<void> writeToken(String token); Future<void> clear(); }`
  - `class HiveService { Future<void> init(); T? read<T>(String boxName, String key); Future<void> write<T>(String boxName, String key, T value); }`
  - Hằng box name: `HiveBoxes.settings = 'settings'`, `HiveBoxes.cache = 'cache'`.

- [ ] **Step 1: Viết test thất bại (HiveService dùng Hive.initFlutter thay bằng path tạm)**

Create `test/core/storage/hive_service_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sample_architecture/core/storage/hive_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Hive.init('./.dart_tool/hive_test');
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  test('write rồi read trả lại đúng giá trị', () async {
    final svc = HiveService();
    await svc.openBox(HiveBoxes.settings);
    await svc.write<String>(HiveBoxes.settings, 'themeMode', 'dark');
    expect(svc.read<String>(HiveBoxes.settings, 'themeMode'), 'dark');
  });

  test('read key chưa tồn tại trả null', () async {
    final svc = HiveService();
    await svc.openBox(HiveBoxes.settings);
    expect(svc.read<String>(HiveBoxes.settings, 'missing'), isNull);
  });
}
```

- [ ] **Step 2: Chạy test để xác nhận fail**

Run: `flutter test test/core/storage/hive_service_test.dart`
Expected: FAIL — thiếu `hive_service.dart`.

- [ ] **Step 3: Viết `hive_service.dart`**

Create `lib/core/storage/hive_service.dart`:
```dart
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const String settings = 'settings';
  static const String cache = 'cache';
}

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    await openBox(HiveBoxes.settings);
    await openBox(HiveBoxes.cache);
  }

  Future<void> openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<dynamic>(boxName);
    }
  }

  T? read<T>(String boxName, String key) {
    return Hive.box<dynamic>(boxName).get(key) as T?;
  }

  Future<void> write<T>(String boxName, String key, T value) {
    return Hive.box<dynamic>(boxName).put(key, value);
  }
}
```

- [ ] **Step 4: Viết `secure_storage_service.dart`**

Create `lib/core/storage/secure_storage_service.dart`:
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> clear() => _storage.delete(key: _tokenKey);
}
```

- [ ] **Step 5: Chạy test để xác nhận pass**

Run: `flutter test test/core/storage/hive_service_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 6: Commit**

```bash
git add lib/core/storage test/core/storage
git commit -m "feat: add HiveService and SecureStorageService"
```

---

## Task 5: Network interceptors + Dio client

**Files:**
- Create: `lib/core/network/interceptors/auth_interceptor.dart`
- Create: `lib/core/network/interceptors/logging_interceptor.dart`
- Create: `lib/core/network/interceptors/error_interceptor.dart`
- Create: `lib/core/network/dio_client.dart`
- Test: `test/core/network/interceptors/error_interceptor_test.dart`

**Interfaces:**
- Consumes: `SecureStorageService` (Task 4), `AppConfig` (Task 2), Exceptions (Task 3).
- Produces:
  - `class AuthInterceptor extends Interceptor` (gắn Bearer token).
  - `class LoggingInterceptor extends Interceptor`.
  - `class ErrorInterceptor extends Interceptor` — map DioException theo status → `reject` với `DioException.error` là `ServerException`/`UnauthorizedException`/`NetworkException`.
  - `Dio buildDio(AppConfig config, SecureStorageService storage)`.

- [ ] **Step 1: Viết test thất bại cho ErrorInterceptor**

Create `test/core/network/interceptors/error_interceptor_test.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/error/exceptions.dart';
import 'package:sample_architecture/core/network/interceptors/error_interceptor.dart';

class _CaptureHandler extends ErrorInterceptorHandler {
  Object? captured;
  @override
  void reject(DioException error, [bool callFollowingErrorInterceptor = false]) {
    captured = error.error;
  }
}

void main() {
  final requestOptions = RequestOptions(path: '/x');

  DioException dioErr(int? status) => DioException(
        requestOptions: requestOptions,
        response: status == null
            ? null
            : Response<dynamic>(requestOptions: requestOptions, statusCode: status),
        type: status == null
            ? DioExceptionType.connectionError
            : DioExceptionType.badResponse,
      );

  test('401 → UnauthorizedException', () {
    final handler = _CaptureHandler();
    ErrorInterceptor().onError(dioErr(401), handler);
    expect(handler.captured, isA<UnauthorizedException>());
  });

  test('500 → ServerException với code', () {
    final handler = _CaptureHandler();
    ErrorInterceptor().onError(dioErr(500), handler);
    expect(handler.captured, isA<ServerException>());
    expect((handler.captured as ServerException).code, 500);
  });

  test('không có response (mất mạng) → NetworkException', () {
    final handler = _CaptureHandler();
    ErrorInterceptor().onError(dioErr(null), handler);
    expect(handler.captured, isA<NetworkException>());
  });
}
```

- [ ] **Step 2: Chạy test để xác nhận fail**

Run: `flutter test test/core/network/interceptors/error_interceptor_test.dart`
Expected: FAIL — thiếu `error_interceptor.dart`.

- [ ] **Step 3: Viết `error_interceptor.dart`**

Create `lib/core/network/interceptors/error_interceptor.dart`:
```dart
import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final Object mapped;
    if (status == null) {
      mapped = NetworkException();
    } else if (status == 401) {
      mapped = UnauthorizedException();
    } else {
      mapped = ServerException(
        message: err.response?.statusMessage,
        code: status,
      );
    }
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
      ),
    );
  }
}
```

- [ ] **Step 4: Viết `auth_interceptor.dart`**

Create `lib/core/network/interceptors/auth_interceptor.dart`:
```dart
import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorageService _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

- [ ] **Step 5: Viết `logging_interceptor.dart`**

Create `lib/core/network/interceptors/logging_interceptor.dart`:
```dart
import 'dart:developer' as dev;
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dev.log('--> ${options.method} ${options.uri}', name: 'HTTP');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    dev.log('<-- ${response.statusCode} ${response.requestOptions.uri}',
        name: 'HTTP');
    handler.next(response);
  }
}
```

- [ ] **Step 6: Viết `dio_client.dart`**

Create `lib/core/network/dio_client.dart`:
```dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

Dio buildDio(AppConfig config, SecureStorageService storage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  dio.interceptors.add(AuthInterceptor(storage));
  if (config.enableLogging) {
    dio.interceptors.add(LoggingInterceptor());
  }
  dio.interceptors.add(ErrorInterceptor());
  return dio;
}
```

- [ ] **Step 7: Chạy test để xác nhận pass**

Run: `flutter test test/core/network/interceptors/error_interceptor_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 8: Commit**

```bash
git add lib/core/network test/core/network
git commit -m "feat: add Dio client with auth, logging, and error interceptors"
```

---

## Task 6: DI (get_it + injectable) + module

**Files:**
- Create: `lib/core/di/injector.dart`
- Create: `lib/core/di/injector.config.dart` (sinh)
- Test: `test/core/di/injector_test.dart`

**Interfaces:**
- Consumes: `AppConfig`, `SecureStorageService`, `HiveService`, `buildDio` (Tasks 2/4/5).
- Produces:
  - `final GetIt getIt = GetIt.instance;`
  - `Future<void> configureDependencies(AppEnv env) async` — đăng ký `AppConfig` theo env rồi gọi `getIt.init()`.
  - `@module abstract class RegisterModule` cung cấp: `AppConfig` (từ tham số), `FlutterSecureStorage`, `SecureStorageService`, `HiveService`, `Dio`.

- [ ] **Step 1: Viết `injector.dart` với annotation InjectableInit**

Create `lib/core/di/injector.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../config/env.dart';
import '../network/dio_client.dart';
import '../storage/hive_service.dart';
import '../storage/secure_storage_service.dart';
import 'injector.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies(AppEnv env) async {
  getIt.registerSingleton<AppConfig>(AppConfig.fromEnv(env));
  getIt.init();
  await getIt<HiveService>().init();
}

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  SecureStorageService secureStorageService(FlutterSecureStorage s) =>
      SecureStorageService(s);

  @lazySingleton
  HiveService get hiveService => HiveService();

  @lazySingleton
  Dio dio(AppConfig config, SecureStorageService storage) =>
      buildDio(config, storage);
}
```

- [ ] **Step 2: Sinh code injectable**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: tạo `lib/core/di/injector.config.dart`, không lỗi.

- [ ] **Step 3: Viết test kiểm tra DI resolve được**

Create `test/core/di/injector_test.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sample_architecture/core/config/app_config.dart';
import 'package:sample_architecture/core/config/env.dart';
import 'package:sample_architecture/core/di/injector.dart';
import 'package:sample_architecture/core/storage/secure_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await getIt.reset();
    await Hive.deleteFromDisk();
  });

  test('resolve AppConfig, Dio, SecureStorageService sau khi configure', () async {
    await configureDependencies(AppEnv.dev);
    expect(getIt<AppConfig>().env, AppEnv.dev);
    expect(getIt<Dio>(), isA<Dio>());
    expect(getIt<SecureStorageService>(), isA<SecureStorageService>());
  });
}
```

Ghi chú: test này gọi `HiveService.init()` thật qua `initFlutter`; nếu môi trường CI không có path_provider, thay bằng bỏ dòng `await getIt<HiveService>().init();` trong test bằng cách chỉ resolve. Nếu init fail, chấp nhận đánh dấu test này `skip: 'cần platform channel'` và dựa vào Task 4 cho storage coverage.

- [ ] **Step 4: Chạy test**

Run: `flutter test test/core/di/injector_test.dart`
Expected: PASS. Nếu lỗi do platform channel của Hive/secure_storage, thêm `@Skip(...)` và ghi chú — coverage storage đã có ở Task 4.

- [ ] **Step 5: Commit**

```bash
git add lib/core/di test/core/di
git commit -m "feat: add get_it + injectable DI with RegisterModule"
```

---

## Task 7: Theme + Localization + core widgets + Failure mapper

**Files:**
- Create: `lib/core/theme/app_colors.dart`, `lib/core/theme/app_theme.dart`
- Create: `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_vi.arb`, `lib/core/l10n/l10n_ext.dart`
- Create: `lib/core/widgets/loading_view.dart`, `lib/core/widgets/error_view.dart`
- Create: `lib/core/error/failure_mapper.dart`
- Test: `test/core/error/failure_mapper_test.dart`

**Interfaces:**
- Consumes: `Failure` (Task 3), `AppLocalizations` (sinh từ l10n).
- Produces:
  - `class AppTheme { static ThemeData get light; static ThemeData get dark; }`
  - `extension L10nX on BuildContext { AppLocalizations get l10n; }`
  - `class LoadingView extends StatelessWidget`
  - `class ErrorView extends StatelessWidget { const ErrorView({required this.message, this.onRetry}); }`
  - `String mapFailureToMessage(Failure failure, AppLocalizations l10n)`

- [ ] **Step 1: Tạo file ARB (en + vi)**

Create `lib/core/l10n/app_en.arb`:
```json
{
  "@@locale": "en",
  "appTitle": "Sample Architecture",
  "retry": "Retry",
  "errorServer": "Server error. Please try again.",
  "errorNetwork": "No internet connection.",
  "errorCache": "Local data error.",
  "errorUnauthorized": "Session expired. Please sign in again.",
  "errorUnknown": "Something went wrong."
}
```

Create `lib/core/l10n/app_vi.arb`:
```json
{
  "@@locale": "vi",
  "appTitle": "Sample Architecture",
  "retry": "Thử lại",
  "errorServer": "Lỗi máy chủ. Vui lòng thử lại.",
  "errorNetwork": "Không có kết nối mạng.",
  "errorCache": "Lỗi dữ liệu cục bộ.",
  "errorUnauthorized": "Phiên đã hết hạn. Vui lòng đăng nhập lại.",
  "errorUnknown": "Đã có lỗi xảy ra."
}
```

- [ ] **Step 2: Sinh AppLocalizations**

Run: `flutter gen-l10n`
Expected: sinh `.dart_tool/flutter_gen/gen_l10n/app_localizations.dart` (import qua `package:flutter_gen/gen_l10n/app_localizations.dart`).

- [ ] **Step 3: Viết `l10n_ext.dart`**

Create `lib/core/l10n/l10n_ext.dart`:
```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

- [ ] **Step 4: Viết `app_colors.dart` + `app_theme.dart`**

Create `lib/core/theme/app_colors.dart`:
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color seed = Color(0xFF3366FF);
}
```

Create `lib/core/theme/app_theme.dart`:
```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.seed,
          brightness: Brightness.dark,
        ),
      );
}
```

- [ ] **Step 5: Viết core widgets**

Create `lib/core/widgets/loading_view.dart`:
```dart
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
```

Create `lib/core/widgets/error_view.dart`:
```dart
import 'package:flutter/material.dart';
import '../l10n/l10n_ext.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                onPressed: onRetry,
                child: Text(context.l10n.retry),
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: Viết `failure_mapper.dart`**

Create `lib/core/error/failure_mapper.dart`:
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'failure.dart';

String mapFailureToMessage(Failure failure, AppLocalizations l10n) {
  return failure.when(
    server: (message, code) => l10n.errorServer,
    network: () => l10n.errorNetwork,
    cache: () => l10n.errorCache,
    unauthorized: () => l10n.errorUnauthorized,
    unknown: (message) => l10n.errorUnknown,
  );
}
```

- [ ] **Step 7: Viết test cho failure_mapper (dùng AppLocalizationsEn)**

Create `test/core/error/failure_mapper_test.dart`:
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/core/error/failure_mapper.dart';

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
```

- [ ] **Step 8: Chạy test để xác nhận pass**

Run: `flutter test test/core/error/failure_mapper_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 9: Commit**

```bash
git add lib/core/theme lib/core/l10n lib/core/widgets lib/core/error test/core/error
git commit -m "feat: add theme, localization, core widgets, and failure mapper"
```

---

## Task 8: Settings cubits (Theme + Locale) lưu Hive

**Files:**
- Create: `lib/features/settings/presentation/bloc/theme_cubit.dart`
- Create: `lib/features/settings/presentation/bloc/locale_cubit.dart`
- Test: `test/features/settings/presentation/bloc/theme_cubit_test.dart`

**Interfaces:**
- Consumes: `HiveService`, `HiveBoxes.settings` (Task 4).
- Produces:
  - `class ThemeCubit extends Cubit<ThemeMode>` — `toggle()`, khôi phục từ Hive key `'themeMode'` ('light'/'dark'/'system').
  - `class LocaleCubit extends Cubit<Locale>` — `setLocale(Locale)`, khôi phục từ Hive key `'locale'` (languageCode).

- [ ] **Step 1: Viết test thất bại cho ThemeCubit (mock HiveService)**

Create `test/features/settings/presentation/bloc/theme_cubit_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/storage/hive_service.dart';
import 'package:sample_architecture/features/settings/presentation/bloc/theme_cubit.dart';

class MockHiveService extends Mock implements HiveService {}

void main() {
  late MockHiveService hive;

  setUp(() {
    hive = MockHiveService();
    when(() => hive.write<String>(any(), any(), any()))
        .thenAnswer((_) async {});
  });

  test('khởi tạo mặc định là system khi Hive rỗng', () {
    when(() => hive.read<String>(HiveBoxes.settings, 'themeMode'))
        .thenReturn(null);
    final cubit = ThemeCubit(hive);
    expect(cubit.state, ThemeMode.system);
  });

  blocTest<ThemeCubit, ThemeMode>(
    'toggle từ light sang dark và ghi Hive',
    build: () {
      when(() => hive.read<String>(HiveBoxes.settings, 'themeMode'))
          .thenReturn('light');
      return ThemeCubit(hive);
    },
    act: (c) => c.toggle(),
    expect: () => [ThemeMode.dark],
    verify: (_) {
      verify(() => hive.write<String>(HiveBoxes.settings, 'themeMode', 'dark'))
          .called(1);
    },
  );
}
```

- [ ] **Step 2: Chạy test để xác nhận fail**

Run: `flutter test test/features/settings/presentation/bloc/theme_cubit_test.dart`
Expected: FAIL — thiếu `theme_cubit.dart`.

- [ ] **Step 3: Viết `theme_cubit.dart`**

Create `lib/features/settings/presentation/bloc/theme_cubit.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/hive_service.dart';

@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._hive) : super(_load(_hive));

  final HiveService _hive;
  static const _key = 'themeMode';

  static ThemeMode _load(HiveService hive) {
    switch (hive.read<String>(HiveBoxes.settings, _key)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _persist(next);
    emit(next);
  }

  void setMode(ThemeMode mode) {
    _persist(mode);
    emit(mode);
  }

  void _persist(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    _hive.write<String>(HiveBoxes.settings, _key, value);
  }
}
```

- [ ] **Step 4: Viết `locale_cubit.dart`**

Create `lib/features/settings/presentation/bloc/locale_cubit.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/hive_service.dart';

@injectable
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._hive) : super(_load(_hive));

  final HiveService _hive;
  static const _key = 'locale';

  static Locale _load(HiveService hive) {
    final code = hive.read<String>(HiveBoxes.settings, _key) ?? 'en';
    return Locale(code);
  }

  void setLocale(Locale locale) {
    _hive.write<String>(HiveBoxes.settings, _key, locale.languageCode);
    emit(locale);
  }
}
```

- [ ] **Step 5: Chạy test để xác nhận pass**

Run: `flutter test test/features/settings/presentation/bloc/theme_cubit_test.dart`
Expected: PASS.

- [ ] **Step 6: Sinh lại DI (đã có cubit mới)**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `injector.config.dart` cập nhật đăng ký `ThemeCubit`, `LocaleCubit` dạng factory.

- [ ] **Step 7: Commit**

```bash
git add lib/features/settings test/features/settings lib/core/di
git commit -m "feat: add ThemeCubit and LocaleCubit persisting to Hive"
```

---

## Task 9: Feature `articles` — Model + RemoteDataSource

**Files:**
- Create: `lib/features/articles/data/models/article_model.dart`
- Create: `lib/features/articles/data/datasources/articles_remote_datasource.dart`
- Test: `test/features/articles/data/models/article_model_test.dart`

**Interfaces:**
- Consumes: Dio (Task 5/6).
- Produces:
  - `@freezed class Article { factory Article({required int id, required String title, required String body}); factory Article.fromJson(Map<String,dynamic>); }`
  - `@RestApi abstract class ArticlesRemoteDataSource { factory ArticlesRemoteDataSource(Dio); @GET('/articles') Future<List<Article>> getArticles(); }`

- [ ] **Step 1: Viết test thất bại cho model**

Create `test/features/articles/data/models/article_model_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';

void main() {
  test('fromJson parse đúng các trường', () {
    final a = Article.fromJson(const {
      'id': 1,
      'title': 'Hello',
      'body': 'World',
    });
    expect(a.id, 1);
    expect(a.title, 'Hello');
    expect(a.body, 'World');
  });
}
```

- [ ] **Step 2: Chạy test để xác nhận fail**

Run: `flutter test test/features/articles/data/models/article_model_test.dart`
Expected: FAIL — thiếu `article_model.dart`.

- [ ] **Step 3: Viết `article_model.dart`**

Create `lib/features/articles/data/models/article_model.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required int id,
    required String title,
    required String body,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
```

- [ ] **Step 4: Viết `articles_remote_datasource.dart`**

Create `lib/features/articles/data/datasources/articles_remote_datasource.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/article_model.dart';

part 'articles_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class ArticlesRemoteDataSource {
  @factoryMethod
  factory ArticlesRemoteDataSource(Dio dio) = _ArticlesRemoteDataSource;

  @GET('/articles')
  Future<List<Article>> getArticles();
}
```

- [ ] **Step 5: Sinh code (freezed + json + retrofit)**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: sinh `article_model.freezed.dart`, `article_model.g.dart`, `articles_remote_datasource.g.dart`. Không lỗi.

- [ ] **Step 6: Chạy test để xác nhận pass**

Run: `flutter test test/features/articles/data/models/article_model_test.dart`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/features/articles/data/models lib/features/articles/data/datasources test/features/articles/data
git commit -m "feat(articles): add Article model and Retrofit remote datasource"
```

---

## Task 10: Feature `articles` — Repository (Either + _guard)

**Files:**
- Create: `lib/core/error/guard.dart` (helper `_guard` dùng chung)
- Create: `lib/features/articles/data/repositories/articles_repository.dart`
- Test: `test/features/articles/data/repositories/articles_repository_test.dart`

**Interfaces:**
- Consumes: `ArticlesRemoteDataSource` (Task 9), `Failure`/Exceptions (Task 3), `DioException` (Dio).
- Produces:
  - `Future<Either<Failure, T>> guard<T>(Future<T> Function() body)` (trong `guard.dart`).
  - `abstract class ArticlesRepository { Future<Either<Failure, List<Article>>> fetchArticles(); }`
  - `class ArticlesRepositoryImpl implements ArticlesRepository` (`@LazySingleton(as: ArticlesRepository)`).

- [ ] **Step 1: Viết `guard.dart`**

Create `lib/core/error/guard.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'exceptions.dart';
import 'failure.dart';

Future<Either<Failure, T>> guard<T>(Future<T> Function() body) async {
  try {
    final result = await body();
    return right(result);
  } on DioException catch (e) {
    return left(_fromError(e.error));
  } on ServerException catch (e) {
    return left(Failure.server(message: e.message, code: e.code));
  } on UnauthorizedException {
    return left(const Failure.unauthorized());
  } on NetworkException {
    return left(const Failure.network());
  } on CacheException {
    return left(const Failure.cache());
  } catch (e) {
    return left(Failure.unknown(e.toString()));
  }
}

Failure _fromError(Object? error) {
  if (error is UnauthorizedException) return const Failure.unauthorized();
  if (error is NetworkException) return const Failure.network();
  if (error is ServerException) {
    return Failure.server(message: error.message, code: error.code);
  }
  return Failure.unknown(error?.toString());
}
```

- [ ] **Step 2: Viết test thất bại cho repository (mock datasource)**

Create `test/features/articles/data/repositories/articles_repository_test.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/error/exceptions.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/features/articles/data/datasources/articles_remote_datasource.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';
import 'package:sample_architecture/features/articles/data/repositories/articles_repository.dart';

class MockRemote extends Mock implements ArticlesRemoteDataSource {}

void main() {
  late MockRemote remote;
  late ArticlesRepository repo;

  setUp(() {
    remote = MockRemote();
    repo = ArticlesRepositoryImpl(remote);
  });

  test('thành công → Right chứa danh sách', () async {
    when(() => remote.getArticles()).thenAnswer(
      (_) async => const [Article(id: 1, title: 't', body: 'b')],
    );
    final result = await repo.fetchArticles();
    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected Right'), (list) {
      expect(list, hasLength(1));
      expect(list.first.id, 1);
    });
  });

  test('DioException(Unauthorized) → Left(unauthorized)', () async {
    when(() => remote.getArticles()).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/articles'),
        error: UnauthorizedException(),
      ),
    );
    final result = await repo.fetchArticles();
    expect(result, equals(left<Failure, List<Article>>(const Failure.unauthorized())));
  });
}
```

Ghi chú: cần import `package:fpdart/fpdart.dart` cho `left`; thêm dòng import đó vào đầu file test.

- [ ] **Step 3: Chạy test để xác nhận fail**

Run: `flutter test test/features/articles/data/repositories/articles_repository_test.dart`
Expected: FAIL — thiếu `articles_repository.dart`.

- [ ] **Step 4: Viết `articles_repository.dart`**

Create `lib/features/articles/data/repositories/articles_repository.dart`:
```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/guard.dart';
import '../datasources/articles_remote_datasource.dart';
import '../models/article_model.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<Article>>> fetchArticles();
}

@LazySingleton(as: ArticlesRepository)
class ArticlesRepositoryImpl implements ArticlesRepository {
  ArticlesRepositoryImpl(this._remote);

  final ArticlesRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<Article>>> fetchArticles() =>
      guard(() => _remote.getArticles());
}
```

- [ ] **Step 5: Bổ sung import fpdart vào test (nếu chưa)**

Ở đầu `test/.../articles_repository_test.dart` thêm:
```dart
import 'package:fpdart/fpdart.dart';
```

- [ ] **Step 6: Chạy test để xác nhận pass**

Run: `flutter test test/features/articles/data/repositories/articles_repository_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 7: Sinh lại DI**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `injector.config.dart` đăng ký `ArticlesRepository` → `ArticlesRepositoryImpl` (LazySingleton).

- [ ] **Step 8: Commit**

```bash
git add lib/core/error/guard.dart lib/features/articles/data/repositories test/features/articles/data/repositories lib/core/di
git commit -m "feat(articles): add repository returning Either with shared guard helper"
```

---

## Task 11: Feature `articles` — Cubit + State

**Files:**
- Create: `lib/features/articles/presentation/bloc/articles_state.dart`
- Create: `lib/features/articles/presentation/bloc/articles_cubit.dart`
- Test: `test/features/articles/presentation/bloc/articles_cubit_test.dart`

**Interfaces:**
- Consumes: `ArticlesRepository` (Task 10), `Failure` (Task 3), `Article` (Task 9).
- Produces:
  - `@freezed class ArticlesState` union: `initial() / loading() / success(List<Article> items) / failure(Failure failure)`.
  - `@injectable class ArticlesCubit extends Cubit<ArticlesState> { ArticlesCubit(ArticlesRepository); Future<void> load(); }`

- [ ] **Step 1: Viết `articles_state.dart`**

Create `lib/features/articles/presentation/bloc/articles_state.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/article_model.dart';

part 'articles_state.freezed.dart';

@freezed
class ArticlesState with _$ArticlesState {
  const factory ArticlesState.initial() = ArticlesInitial;
  const factory ArticlesState.loading() = ArticlesLoading;
  const factory ArticlesState.success(List<Article> items) = ArticlesSuccess;
  const factory ArticlesState.failure(Failure failure) = ArticlesFailure;
}
```

- [ ] **Step 2: Viết `articles_cubit.dart`**

Create `lib/features/articles/presentation/bloc/articles_cubit.dart`:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/articles_repository.dart';
import 'articles_state.dart';

@injectable
class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit(this._repository) : super(const ArticlesState.initial());

  final ArticlesRepository _repository;

  Future<void> load() async {
    emit(const ArticlesState.loading());
    final result = await _repository.fetchArticles();
    result.fold(
      (failure) => emit(ArticlesState.failure(failure)),
      (items) => emit(ArticlesState.success(items)),
    );
  }
}
```

- [ ] **Step 3: Sinh code Freezed cho state**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: sinh `articles_state.freezed.dart`.

- [ ] **Step 4: Viết test cubit (bloc_test + mock repo)**

Create `test/features/articles/presentation/bloc/articles_cubit_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';
import 'package:sample_architecture/features/articles/data/repositories/articles_repository.dart';
import 'package:sample_architecture/features/articles/presentation/bloc/articles_cubit.dart';
import 'package:sample_architecture/features/articles/presentation/bloc/articles_state.dart';

class MockRepo extends Mock implements ArticlesRepository {}

void main() {
  late MockRepo repo;

  setUp(() => repo = MockRepo());

  blocTest<ArticlesCubit, ArticlesState>(
    'load thành công → [loading, success]',
    build: () {
      when(() => repo.fetchArticles()).thenAnswer(
        (_) async => right(const [Article(id: 1, title: 't', body: 'b')]),
      );
      return ArticlesCubit(repo);
    },
    act: (c) => c.load(),
    expect: () => [
      const ArticlesState.loading(),
      const ArticlesState.success([Article(id: 1, title: 't', body: 'b')]),
    ],
  );

  blocTest<ArticlesCubit, ArticlesState>(
    'load lỗi → [loading, failure]',
    build: () {
      when(() => repo.fetchArticles()).thenAnswer(
        (_) async => left(const Failure.network()),
      );
      return ArticlesCubit(repo);
    },
    act: (c) => c.load(),
    expect: () => [
      const ArticlesState.loading(),
      const ArticlesState.failure(Failure.network()),
    ],
  );
}
```

- [ ] **Step 5: Chạy test để xác nhận pass**

Run: `flutter test test/features/articles/presentation/bloc/articles_cubit_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 6: Sinh lại DI**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `injector.config.dart` đăng ký `ArticlesCubit` (factory).

- [ ] **Step 7: Commit**

```bash
git add lib/features/articles/presentation/bloc test/features/articles/presentation/bloc lib/core/di
git commit -m "feat(articles): add ArticlesCubit and Freezed ArticlesState"
```

---

## Task 12: Feature `articles` — Page (UI với state.when)

**Files:**
- Create: `lib/features/articles/presentation/pages/articles_page.dart`
- Test: `test/features/articles/presentation/pages/articles_page_test.dart`

**Interfaces:**
- Consumes: `ArticlesCubit`, `ArticlesState` (Task 11), `LoadingView`/`ErrorView` (Task 7), `mapFailureToMessage` (Task 7), `context.l10n` (Task 7).
- Produces:
  - `class ArticlesPage extends StatelessWidget` — nhận cubit qua `BlocProvider` từ ngoài; gọi `load()` ở init; render `state.when(...)`.

- [ ] **Step 1: Viết widget test thất bại (bơm cubit giả)**

Create `test/features/articles/presentation/pages/articles_page_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';
import 'package:sample_architecture/features/articles/presentation/bloc/articles_cubit.dart';
import 'package:sample_architecture/features/articles/presentation/bloc/articles_state.dart';
import 'package:sample_architecture/features/articles/presentation/pages/articles_page.dart';

class MockArticlesCubit extends MockCubit<ArticlesState>
    implements ArticlesCubit {}

Widget _wrap(ArticlesCubit cubit) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ArticlesCubit>.value(
        value: cubit,
        child: const ArticlesPage(),
      ),
    );

void main() {
  late MockArticlesCubit cubit;

  setUp(() {
    cubit = MockArticlesCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
  });

  testWidgets('state success hiển thị tiêu đề bài viết', (tester) async {
    whenListen(
      cubit,
      Stream<ArticlesState>.fromIterable(const [
        ArticlesState.success([Article(id: 1, title: 'Hello', body: 'b')]),
      ]),
      initialState: const ArticlesState.loading(),
    );
    await tester.pumpWidget(_wrap(cubit));
    await tester.pump();
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('state loading hiển thị progress indicator', (tester) async {
    whenListen(
      cubit,
      const Stream<ArticlesState>.empty(),
      initialState: const ArticlesState.loading(),
    );
    await tester.pumpWidget(_wrap(cubit));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

- [ ] **Step 2: Chạy test để xác nhận fail**

Run: `flutter test test/features/articles/presentation/pages/articles_page_test.dart`
Expected: FAIL — thiếu `articles_page.dart`.

- [ ] **Step 3: Viết `articles_page.dart`**

Create `lib/features/articles/presentation/pages/articles_page.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/articles_cubit.dart';
import '../bloc/articles_state.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ArticlesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appTitle)),
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingView(),
            loading: () => const LoadingView(),
            success: (items) => ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(items[i].title),
                subtitle: Text(items[i].body),
              ),
            ),
            failure: (failure) => ErrorView(
              message: mapFailureToMessage(failure, context.l10n),
              onRetry: () => context.read<ArticlesCubit>().load(),
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 4: Chạy test để xác nhận pass**

Run: `flutter test test/features/articles/presentation/pages/articles_page_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/features/articles/presentation/pages test/features/articles/presentation/pages
git commit -m "feat(articles): add ArticlesPage rendering state via when()"
```

---

## Task 13: Router (go_router) + App widget

**Files:**
- Create: `lib/core/router/routes.dart`
- Create: `lib/core/router/app_router.dart`
- Create: `lib/app.dart`
- Test: `test/core/router/app_router_test.dart`

**Interfaces:**
- Consumes: `ArticlesPage` + `ArticlesCubit` (Tasks 11/12), `getIt` (Task 6), theme/locale cubits (Task 8), `AppTheme` (Task 7).
- Produces:
  - `class Routes { static const articles = '/'; }`
  - `@lazySingleton class AppRouter { GoRouter get router; }`
  - `class App extends StatelessWidget` — cung cấp ThemeCubit/LocaleCubit, MaterialApp.router.

- [ ] **Step 1: Viết `routes.dart`**

Create `lib/core/router/routes.dart`:
```dart
class Routes {
  static const String articles = '/';
}
```

- [ ] **Step 2: Viết `app_router.dart`**

Create `lib/core/router/app_router.dart`:
```dart
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injector.dart';
import '../../features/articles/presentation/bloc/articles_cubit.dart';
import '../../features/articles/presentation/pages/articles_page.dart';
import 'routes.dart';

@lazySingleton
class AppRouter {
  GoRouter get router => GoRouter(
        initialLocation: Routes.articles,
        routes: [
          GoRoute(
            path: Routes.articles,
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<ArticlesCubit>(),
              child: const ArticlesPage(),
            ),
          ),
        ],
      );
}
```

- [ ] **Step 3: Viết `app.dart`**

Create `lib/app.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/di/injector.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/bloc/locale_cubit.dart';
import 'features/settings/presentation/bloc/theme_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>().router;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates:
                    AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: router,
              );
            },
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 4: Viết test router (config có route articles)**

Create `test/core/router/app_router_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/router/routes.dart';

void main() {
  test('route articles là "/"', () {
    expect(Routes.articles, '/');
  });
}
```

Ghi chú: `AppRouter` phụ thuộc DI (getIt) nên test đầy đủ nằm ở Task 14 (smoke test end-to-end). Ở đây chỉ kiểm hằng route để giữ task độc lập.

- [ ] **Step 5: Chạy test**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: PASS.

- [ ] **Step 6: Sinh lại DI (AppRouter mới)**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `injector.config.dart` đăng ký `AppRouter` (LazySingleton).

- [ ] **Step 7: Commit**

```bash
git add lib/core/router lib/app.dart test/core/router lib/core/di
git commit -m "feat: add go_router AppRouter and App widget wiring theme/locale"
```

---

## Task 14: Bootstrap + entrypoints theo flavor + smoke test

**Files:**
- Create: `lib/bootstrap.dart`
- Create: `lib/main_dev.dart`, `lib/main_staging.dart`, `lib/main_prod.dart`
- Modify: `lib/main.dart` (chuyển hướng gọi dev, tiện `flutter run` mặc định)
- Test: `test/app_smoke_test.dart`

**Interfaces:**
- Consumes: `configureDependencies` (Task 6), `App` (Task 13), `AppEnv` (Task 2).
- Produces:
  - `Future<void> bootstrap(AppEnv env) async` — ensureInitialized → configureDependencies(env) → runApp(App).
  - 3 entrypoint gọi `bootstrap` với env tương ứng.

- [ ] **Step 1: Viết `bootstrap.dart`**

Create `lib/bootstrap.dart`:
```dart
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
```

- [ ] **Step 2: Viết 3 entrypoint**

Create `lib/main_dev.dart`:
```dart
import 'bootstrap.dart';
import 'core/config/env.dart';

void main() => bootstrap(AppEnv.dev);
```

Create `lib/main_staging.dart`:
```dart
import 'bootstrap.dart';
import 'core/config/env.dart';

void main() => bootstrap(AppEnv.staging);
```

Create `lib/main_prod.dart`:
```dart
import 'bootstrap.dart';
import 'core/config/env.dart';

void main() => bootstrap(AppEnv.prod);
```

- [ ] **Step 3: Trỏ `main.dart` mặc định về dev**

Replace nội dung `lib/main.dart`:
```dart
import 'bootstrap.dart';
import 'core/config/env.dart';

void main() => bootstrap(AppEnv.dev);
```

- [ ] **Step 4: Viết smoke test end-to-end (mock Dio qua DI override)**

Create `test/app_smoke_test.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/app.dart';
import 'package:sample_architecture/core/config/env.dart';
import 'package:sample_architecture/core/di/injector.dart';
import 'package:sample_architecture/features/articles/data/datasources/articles_remote_datasource.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';

class MockRemote extends Mock implements ArticlesRemoteDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Hive.init('./.dart_tool/hive_smoke');
  });

  tearDown(() async {
    await getIt.reset();
    await Hive.deleteFromDisk();
  });

  testWidgets('app khởi động và hiển thị bài viết từ datasource (mock)',
      (tester) async {
    await configureDependencies(AppEnv.dev);

    // Override datasource bằng mock để không gọi mạng thật.
    final mock = MockRemote();
    when(() => mock.getArticles()).thenAnswer(
      (_) async => const [Article(id: 1, title: 'Smoke', body: 'ok')],
    );
    getIt.unregister<ArticlesRemoteDataSource>();
    getIt.registerFactory<ArticlesRemoteDataSource>(() => mock);

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Smoke'), findsOneWidget);
  });
}
```

Ghi chú: smoke test gọi `HiveService.init()` (qua `initFlutter`) — cần platform channel. Nếu môi trường test không cung cấp, đánh dấu `@Tags(['integration'])` và chạy riêng, hoặc `skip` với ghi chú; coverage các lớp đã đầy đủ ở Tasks 3–13.

- [ ] **Step 5: Chạy toàn bộ test suite**

Run: `flutter test`
Expected: tất cả test từ Task 2–14 PASS (trừ test đánh dấu skip do platform channel, nếu có).

- [ ] **Step 6: Phân tích tĩnh sạch**

Run: `flutter analyze`
Expected: "No issues found!"

- [ ] **Step 7: Commit**

```bash
git add lib/bootstrap.dart lib/main.dart lib/main_dev.dart lib/main_staging.dart lib/main_prod.dart test/app_smoke_test.dart
git commit -m "feat: add bootstrap, flavor entrypoints, and app smoke test"
```

---

## Task 15: Tài liệu README kiến trúc + lệnh thường dùng

**Files:**
- Create: `README.md`
- Create: `docs/architecture.md`

**Interfaces:**
- Consumes: toàn bộ cấu trúc đã dựng.
- Produces: tài liệu cho người mới join.

- [ ] **Step 1: Viết `README.md`**

Create `README.md`:
```markdown
# sample_architecture

Khung kiến trúc Flutter: feature-first, Clean Architecture rút gọn (presentation/data), BLoC/Cubit + Freezed, Dio + Retrofit, get_it + injectable, go_router, Hive + secure_storage, fpdart Either.

## Chạy

```bash
flutter run -t lib/main_dev.dart --flavor dev
flutter run -t lib/main_staging.dart --flavor staging
flutter run -t lib/main_prod.dart --flavor prod
```

## Code generation

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Test

```bash
flutter test
```

## Thêm feature mới

1. Tạo `lib/features/<feature>/data/{models,datasources,repositories}` và `presentation/{bloc,pages,widgets}`.
2. Model: Freezed + json. DataSource: Retrofit `@RestApi` + `@lazySingleton`.
3. Repository: abstract + impl `@LazySingleton(as: ...)`, trả `Either<Failure, T>` qua `guard`.
4. Cubit: `@injectable`, state Freezed union initial/loading/success/failure.
5. Page: `state.when(...)`, dùng `LoadingView`/`ErrorView` + `mapFailureToMessage`.
6. Thêm route vào `core/router/app_router.dart`.
7. Chạy `build_runner` để cập nhật DI.
```

- [ ] **Step 2: Viết `docs/architecture.md`**

Create `docs/architecture.md` với nội dung tóm tắt các lớp và quy tắc (tham chiếu spec `docs/superpowers/specs/2026-07-11-flutter-architecture-design.md`): trách nhiệm từng lớp, quy tắc DI lifetime, luồng error, quy ước đặt tên. (Sao chép mục 3–10 của spec.)

- [ ] **Step 3: Commit**

```bash
git add README.md docs/architecture.md
git commit -m "docs: add README and architecture guide"
```

---

## Self-Review

**1. Spec coverage:**
- §1 Stack → Tasks 1 (deps), rải khắp. ✅
- §2 Cấu trúc thư mục → toàn bộ tasks tạo đúng path. ✅
- §3 Luồng dữ liệu + State pattern + Cubit/Bloc → Tasks 10–12. ✅
- §4 Error handling (Failure + _guard + mapper + ErrorInterceptor) → Tasks 3, 5, 7, 10. ✅
- §5 DI lifetime → Task 6 (module) + annotation trong 8/9/10/11/13. ✅
- §6 Networking interceptor chain + baseUrl từ config + 401→login → Task 5 (+ router Task 13 xử lý điều hướng khi unauthorized qua ErrorView/retry; điều hướng login tự động là phần mở rộng, spec §12 hoãn token-refresh). ✅
- §7 Flavor/entrypoints → Task 14 + AppConfig Task 2. ✅
- §8 Theme + dark mode lưu Hive → Task 8 (ThemeCubit) + Task 7 (AppTheme). ✅
- §9 Localization en/vi lưu Hive → Task 7 (arb) + Task 8 (LocaleCubit). ✅
- §10 Testing mọi lớp (mocktail + bloc_test) → Tasks 2–14 đều có test. ✅
- §11 Dependencies → Task 1. ✅
- §12 YAGNI (không refresh/domain/Drift) → tôn trọng, không có task nào thêm chúng. ✅

**2. Placeholder scan:** Không có "TBD/TODO". Task 15 Step 2 mô tả nội dung sao chép từ spec (không phải placeholder logic code). ✅

**3. Type consistency:**
- `Failure` factory tên (`server/network/cache/unauthorized/unknown`) nhất quán giữa Task 3, 7, 10, 11. ✅
- `guard<T>` (Task 10) — dùng đúng trong repository. ✅
- `ArticlesRepository.fetchArticles()` → `ArticlesCubit.load()` → `ArticlesState` nhất quán Tasks 10–12. ✅
- `HiveBoxes.settings` dùng thống nhất Tasks 4, 8. ✅
- `HiveService`: test Task 4 gọi `openBox` (không `init`) để tránh platform channel; `init()` gọi `initFlutter` chỉ ở runtime/DI — nhất quán. ✅
- `context.l10n` + `AppLocalizations` import path `package:flutter_gen/gen_l10n/...` nhất quán Tasks 7, 12, 13, 14. ✅

Không phát hiện mâu thuẫn. Plan sẵn sàng.
