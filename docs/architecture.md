# Hướng dẫn kiến trúc

Tài liệu này mô tả kiến trúc **đã được xây dựng thật sự** trong `lib/` (không phải chỉ là kế hoạch). Tham chiếu gốc: spec thiết kế
[`docs/superpowers/specs/2026-07-11-flutter-architecture-design.md`](superpowers/specs/2026-07-11-flutter-architecture-design.md).
Nếu có khác biệt giữa spec và code, tài liệu này lấy code làm chuẩn.

## 1. Cấu trúc thư mục thực tế

```
lib/
├── main_dev.dart / main_staging.dart / main_prod.dart   # entrypoint theo flavor, set AppEnv rồi gọi bootstrap()
├── bootstrap.dart      # configureDependencies() + runApp(App())
├── app.dart            # MaterialApp.router + BlocProvider ThemeCubit/LocaleCubit + AppLocalizations
├── core/
│   ├── config/         # env.dart (AppEnv), app_config.dart (AppConfig.fromEnv)
│   ├── di/             # injector.dart (@module RegisterModule) + injector.config.dart (sinh bởi injectable)
│   ├── error/          # exceptions.dart, failure.dart (Failure sealed), guard.dart, failure_mapper.dart
│   ├── network/        # dio_client.dart + interceptors/ (auth, logging, error)
│   ├── storage/        # hive_service.dart, secure_storage_service.dart
│   ├── router/         # app_router.dart, routes.dart (go_router)
│   ├── theme/          # app_theme.dart (light/dark, Material 3), app_colors.dart
│   ├── l10n/           # app_en.arb, app_vi.arb, app_localizations*.dart (sinh bởi flutter gen-l10n), l10n_ext.dart
│   └── widgets/        # LoadingView, ErrorView
└── features/
    ├── settings/       # ThemeCubit + LocaleCubit (đọc/ghi Hive trong constructor)
    └── articles/       # feature mẫu end-to-end
        ├── data/
        │   ├── models/         # article_model.dart — Freezed (abstract class) + json_serializable
        │   ├── datasources/    # articles_remote_datasource.dart — Retrofit @RestApi, @lazySingleton
        │   └── repositories/   # articles_repository.dart — abstract + impl @LazySingleton(as:)
        └── presentation/
            ├── bloc/    # articles_cubit.dart + articles_state.dart (Freezed sealed union)
            ├── pages/   # ArticlesPage — state.when(...)
            └── widgets/
```

`test/` gương theo `lib/` (vd. `test/features/articles/data/repositories/...`).

## 2. Trách nhiệm từng lớp

| Lớp | Trách nhiệm | KHÔNG được làm |
|---|---|---|
| **DataSource** | Nói chuyện với đúng **một** nguồn (Retrofit API hoặc Hive/SecureStorage). Ném `Exception` (`ServerException`, `NetworkException`, `UnauthorizedException`, `CacheException` — định nghĩa ở `core/error/exceptions.dart`) khi lỗi. | Không biết `Failure`/`Either`. Không catch lỗi để "xử lý êm" — cứ ném ra ngoài. |
| **Repository** | abstract interface + impl. Gọi datasource qua `guard(() => ...)` (`core/error/guard.dart`), trả `Future<Either<Failure, T>>`. Là nơi duy nhất quyết định remote hay cache. | Không bao giờ `throw` ra khỏi repository — luôn trả `Either`. |
| **Cubit/Bloc** | Gọi repository, `result.fold(onFailure, onSuccess)` để emit state (Freezed sealed union). | Không tự try/catch, không gọi `Dio`/Hive trực tiếp. |
| **UI (Page/Widget)** | Đọc state qua `state.when(...)`, bắn action/event, hiển thị `LoadingView`/`ErrorView`. | Không chứa logic nghiệp vụ, không tự gọi repository. |

Quy tắc **Cubit mặc định**; chỉ dùng **Bloc** (event-driven) cho luồng nhiều sự kiện (form nhiều bước, search debounce). Trong bộ khung hiện tại, `ArticlesCubit`, `ThemeCubit`, `LocaleCubit` đều là Cubit — chưa có ví dụ Bloc (chưa cần).

## 3. Luồng dữ liệu

```
UI (Page)  →  Cubit/Bloc  →  Repository            →  DataSource          →  API / Hive
   ▲              │         guard(): Exception→Failure   throw Exception
 state.when   emit State         Either<Failure, T>
```

Ví dụ cụ thể trong `articles`:

1. `ArticlesPage` build với `BlocBuilder<ArticlesCubit, ArticlesState>` → gọi `context.read<ArticlesCubit>().load()`.
2. `ArticlesCubit.load()` emit `ArticlesState.loading()`, gọi `ArticlesRepository.fetchArticles()`.
3. `ArticlesRepositoryImpl.fetchArticles()` bọc lời gọi `ArticlesRemoteDataSource.getArticles()` trong `guard(...)`.
4. `ArticlesRemoteDataSource` (Retrofit `@RestApi`) gọi API qua `Dio`; nếu Dio ném `DioException` (đã được `ErrorInterceptor` chuẩn hoá — xem §5), `guard` map nó thành `Failure` tương ứng và trả `Left(failure)`; thành công trả `Right(List<Article>)`.
5. Cubit `fold`: `onFailure` → emit `ArticlesState.failure(failure)`; `onSuccess` → emit `ArticlesState.success(items)`.
6. UI: `state.when(initial: ..., loading: () => LoadingView(), success: (items) => ..., failure: (f) => ErrorView(message: mapFailureToMessage(f, context.l10n)))`.

### State pattern (Freezed sealed union)

```dart
sealed class ArticlesState with _$ArticlesState {
  const factory ArticlesState.initial() = _Initial;
  const factory ArticlesState.loading() = _Loading;
  const factory ArticlesState.success(List<Article> items) = _Success;
  const factory ArticlesState.failure(Failure failure) = _Failure;
}
```

UI dùng `state.when(...)` — buộc xử lý đủ 4 nhánh, trình biên dịch báo lỗi nếu thiếu nhánh.

**Lưu ý Freezed 3.x (đã áp dụng trong code):**
- Union type (nhiều factory constructor khác nhau, dùng `.when`) → khai báo `sealed class`, vd. `Failure` (`core/error/failure.dart`), `ArticlesState`.
- Data class thuần (một constructor, chỉ chứa field) → khai báo `abstract class`, vd. `Article` (`article_model.dart`).

## 4. Error handling — luồng đầy đủ

```
DataSource                 ném Exception (ServerException / NetworkException / UnauthorizedException / CacheException)
     ▲
Dio ErrorInterceptor       map HTTP status → Exception tương ứng, reject lại DioException(error: mapped)
     │ (chỉ áp dụng lỗi từ network; lỗi từ Hive/local ném thẳng CacheException)
     ▼
Repository → guard(fn)     bắt DioException/ServerException/UnauthorizedException/NetworkException/CacheException/khác
                            → map sang Failure (core/error/failure.dart), trả Either<Failure, T>
     ▼
Cubit → result.fold(...)   emit ArticlesState.failure(failure) hoặc .success(...)
     ▼
UI → mapFailureToMessage(failure, context.l10n)   trả chuỗi đã localize (en/vi) tương ứng từng loại Failure
```

`Failure` (`core/error/failure.dart`, `sealed class`):

```dart
sealed class Failure with _$Failure {
  const factory Failure.server({String? message, int? code}) = ServerFailure;
  const factory Failure.network() = NetworkFailure;
  const factory Failure.cache() = CacheFailure;
  const factory Failure.unauthorized() = UnauthorizedFailure;
  const factory Failure.unknown([String? message]) = UnknownFailure;
}
```

`ErrorInterceptor` (`core/network/interceptors/error_interceptor.dart`) chạy trong chuỗi interceptor của `Dio` (`dio_client.dart`), ở bước `onError`: status `null` → `NetworkException`; `401` → `UnauthorizedException`; status khác → `ServerException(message, code)`. Interceptor reject lại `DioException` với `error` đã được thay bằng exception nội bộ, để `guard()` ở tầng repository nhận đúng loại và map sang `Failure`.

`mapFailureToMessage` (`core/error/failure_mapper.dart`) dùng `failure.when(...)` để trả về chuỗi localized tương ứng (`l10n.errorServer`, `errorNetwork`, `errorCache`, `errorUnauthorized`, `errorUnknown`) — **không bao giờ** hiển thị `message`/`code` kỹ thuật thô cho người dùng.

## 5. Dependency Injection (get_it + injectable)

Cấu hình ở `lib/core/di/injector.dart`, sinh `injector.config.dart` qua `build_runner`.

| Thành phần | Lifetime | Cách khai báo |
|---|---|---|
| DataSource (vd. `ArticlesRemoteDataSource`) | `@LazySingleton` | annotation trực tiếp trên class impl (hoặc factory Retrofit) |
| Repository impl (vd. `ArticlesRepositoryImpl`) | `@LazySingleton(as: ArticlesRepository)` | impl đăng ký dưới interface abstract |
| Cubit/Bloc (vd. `ArticlesCubit`, `ThemeCubit`, `LocaleCubit`) | `@injectable` (factory) | mỗi lần resolve tạo instance mới — đúng cho vòng đời màn hình |
| Hạ tầng (Dio, Hive service, secure storage, AppConfig) | qua `@module abstract class RegisterModule` | `injector.dart`: `secureStorage`, `secureStorageService`, `hiveService` (đều `@lazySingleton`), `dio(AppConfig, SecureStorageService)` (`@lazySingleton`) |
| `AppConfig` | `registerSingleton` thủ công (không qua annotation) | `configureDependencies(env)` gọi `getIt.registerSingleton<AppConfig>(AppConfig.fromEnv(env))` **trước** `getIt.init()`, vì các factory khác (vd. `dio(...)`) cần `AppConfig` đã sẵn sàng |

`configureDependencies(AppEnv env)` (async) thực hiện theo thứ tự: đăng ký `AppConfig` → `getIt.init()` (chạy code sinh, đăng ký toàn bộ graph còn lại) → `await getIt<HiveService>().init()` (mở box Hive, cần platform channel `path_provider`).

Sau khi thêm/sửa bất kỳ class nào có annotation DI, **phải** chạy lại:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
(Không dùng `dart run build_runner ...` trần trên máy có standalone Dart cũ trong PATH — xem README/CLAUDE.md.)

## 6. Networking (Dio + Retrofit)

Interceptor chain thực tế (`core/network/dio_client.dart`, thứ tự thêm vào `Dio.interceptors`):

```
Request  →  AuthInterceptor     (gắn Bearer token đọc từ SecureStorageService)
         →  LoggingInterceptor   (bật/tắt theo AppConfig, chủ yếu dev)
         →  [gọi server]
Response ←  ErrorInterceptor     (onError: map HTTP status → Exception nội bộ)
```

- `baseUrl` lấy từ `AppConfig.fromEnv(env)` theo flavor — không hard-code trong feature.
- API mô tả bằng interface Retrofit `@RestApi` (vd. `ArticlesRemoteDataSource`), client sinh code qua `build_runner`.
- 401 → `UnauthorizedException` → `Failure.unauthorized()` → UI hiển thị `l10n.errorUnauthorized`. Bản đầu **chưa** làm token-refresh tự động hay auto-redirect sang login (YAGNI, xem spec §12) — đây là phần mở rộng có thể thêm sau nếu cần.

## 7. Theme + Localization (i18n)

- **Theme**: `AppTheme.light` / `AppTheme.dark` (Material 3, `ColorScheme`), màu tập trung ở `app_colors.dart`. `ThemeCubit` (`features/settings`) quản lý `ThemeMode`, đọc/ghi lựa chọn vào Hive (box settings) — đọc đồng bộ ngay trong constructor.
- **Locale**: `LocaleCubit` tương tự — quản lý `Locale` hiện tại (`en`/`vi`), đọc/ghi Hive trong constructor.
- Vì cả hai Cubit đọc Hive **đồng bộ trong constructor**, chúng yêu cầu Hive box đã được mở trước khi `getIt` resolve chúng lần đầu — đây là lý do `app_smoke_test.dart` phải chạy như integration test (xem §8).
- **l10n**: dùng đường dẫn **thật** (không phải synthetic `flutter_gen`):
  ```dart
  import 'package:sample_architecture/core/l10n/app_localizations.dart';
  ```
  File `.arb` nguồn: `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_vi.arb`. `flutter gen-l10n` sinh `app_localizations.dart` + `app_localizations_en.dart` + `app_localizations_vi.dart` vào cùng thư mục `core/l10n/` (cấu hình qua `l10n.yaml` / `generate: true` trong `pubspec.yaml`, output đặt lại về `core/l10n` thay vì thư mục mặc định). UI truy cập qua `context.l10n` (extension trong `l10n_ext.dart`, export lại `AppLocalizations`).

## 8. Testing

- **Unit**: repository (mock datasource bằng `mocktail`), cubit/bloc (mock repository, dùng `bloc_test`).
- **Widget**: page (bơm cubit giả qua `BlocProvider.value`).
- Framework: `mocktail` + `bloc_test`. Cấu trúc test gương theo `lib/` (`test/features/<feature>/...`).
- **`test/app_smoke_test.dart`** đánh dấu `@Tags(['integration'])` và test bên trong dùng `skip: true` dưới `flutter test` thường. Lý do: `App.build()` resolve `ThemeCubit`/`LocaleCubit` qua `getIt` ngay khi dựng widget tree, và constructor của cả hai đọc Hive **đồng bộ** (`HiveService.read(...)` → `Hive.box(...)`). Dưới `flutter test` thường không có platform channel `path_provider` nên `Hive.initFlutter()` không hoàn tất, không có box nào được mở → constructor ném lỗi/hang, khiến `tester.pumpAndSettle()` không bao giờ ổn định. Đây là rào cản platform-channel thật, không phải bug logic — coverage của từng lớp (HiveService, ThemeCubit, LocaleCubit, ArticlesCubit, ArticlesPage, injector, router) đã có đầy đủ ở các unit/widget test độc lập (Tasks 2–13), mock hoặc cô lập Hive/DI ở đúng lớp của nó. Chạy file này thật sự (không skip) cần một lane tích hợp có platform channel thật, vd. `flutter test --tags integration` trên thiết bị/emulator thật hoặc `flutter drive`.

## 9. Quy ước đặt tên & tổ chức

- Feature mới: `lib/features/<feature>/data/{models,datasources,repositories}` + `presentation/{bloc,pages,widgets}`.
- Model: `<feature>_model.dart`, class Freezed (`abstract class` nếu chỉ 1 constructor) + `@JsonSerializable`/`fromJson`/`toJson`.
- DataSource: `<feature>_remote_datasource.dart`, interface Retrofit `@RestApi`, impl sinh qua `build_runner`, đăng ký `@lazySingleton`.
- Repository: `<feature>_repository.dart` chứa cả abstract interface + impl (`<Feature>RepositoryImpl`) trong cùng file, impl đăng ký `@LazySingleton(as: <Feature>Repository)`.
- Cubit: `<feature>_cubit.dart` + `<feature>_state.dart` (state Freezed sealed union `initial/loading/success/failure`), Cubit đăng ký `@injectable`.
- Page: `<feature>_page.dart`, render bằng `state.when(...)`, dùng `LoadingView`/`ErrorView` (`core/widgets/`) + `mapFailureToMessage`.
- File sinh (`*.freezed.dart`, `*.g.dart`, `injector.config.dart`, `app_localizations*.dart` khi sinh bởi `flutter gen-l10n`) — không sửa tay, không review, sinh lại bằng lệnh tương ứng.

## 10. Phạm vi cố ý chưa làm (YAGNI)

Giữ nguyên như spec §12 — chưa có nhu cầu thực nên chưa làm:
- Token-refresh tự động khi 401 (hiện chỉ map thành `Failure.unauthorized()`, chưa tự động điều hướng/làm mới token).
- Domain layer riêng (usecase/entity tách khỏi model).
- CSDL quan hệ (Drift) — Hive với box untyped (`dynamic`) lưu trực tiếp kiểu nguyên thuỷ là đủ cho nhu cầu cache/settings hiện tại; vì vậy **không cần** `hive_generator`/`TypeAdapter` codegen (xem `pubspec.yaml`, phần dev_dependencies, ghi chú tại sao `hive_generator` bị bỏ qua có chủ đích).
