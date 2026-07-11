# Thiết kế Kiến trúc Codebase Flutter

**Ngày:** 2026-07-11
**Quy mô:** App vừa, 1 team nhỏ — cân bằng giữa cấu trúc sạch và tốc độ phát triển.

## 1. Tổng quan Stack

| Mối quan tâm | Lựa chọn |
|---|---|
| State management | BLoC/Cubit + Freezed |
| Kiến trúc | Clean Architecture rút gọn (feature-first, 2 lớp: presentation / data — bỏ domain riêng) |
| Networking | Dio + Retrofit |
| Dependency Injection | get_it + injectable |
| Routing | go_router |
| Local storage | Hive (cache thường) + flutter_secure_storage (token) |
| Error handling | fpdart `Either<Failure, T>` ở tầng repository |
| Nền tảng khác | Theming + Dark mode, Localization (i18n), Environment/flavor (dev/staging/prod) |

**Nguyên tắc chủ đạo:** mỗi feature độc lập, mỗi lớp có một trách nhiệm rõ ràng, giao tiếp qua interface rõ ràng, và có thể hiểu + test riêng.

## 2. Cấu trúc thư mục

```
lib/
├── main_dev.dart              # entrypoint cho flavor dev
├── main_staging.dart          # entrypoint cho flavor staging
├── main_prod.dart             # entrypoint cho flavor prod
├── bootstrap.dart             # khởi tạo chung (DI, Hive, BlocObserver) + runApp
│
├── core/                      # code dùng chung toàn app, không thuộc feature nào
│   ├── config/
│   │   ├── env.dart           # AppEnv (dev/staging/prod), baseUrl, flags
│   │   └── app_config.dart
│   ├── di/
│   │   ├── injector.dart      # cấu hình get_it
│   │   └── injector.config.dart   # (sinh bởi injectable)
│   ├── error/
│   │   ├── failure.dart       # Failure (Freezed union): server/network/cache/unauthorized/unknown
│   │   └── exceptions.dart    # Exception nội bộ tầng data
│   ├── network/
│   │   ├── dio_client.dart    # Dio factory + interceptors
│   │   └── interceptors/      # auth, logging, error-mapping
│   ├── storage/
│   │   ├── hive_service.dart          # bọc Hive (cache thường)
│   │   └── secure_storage_service.dart # bọc secure storage (token)
│   ├── router/
│   │   ├── app_router.dart    # cấu hình go_router
│   │   └── routes.dart        # tên/đường dẫn route
│   ├── theme/
│   │   ├── app_theme.dart     # light + dark ThemeData
│   │   └── app_colors.dart
│   ├── l10n/                  # file .arb + code sinh ra
│   └── widgets/               # widget dùng chung (loading, error view, buttons...)
│
└── features/
    └── <feature>/             # ví dụ: auth, home, profile
        ├── data/
        │   ├── datasources/   # remote (Retrofit API) + local (Hive)
        │   ├── models/        # DTO (Freezed + json_serializable), đóng luôn vai trò entity
        │   └── repositories/  # abstract interface + impl → trả Either<Failure, T>
        └── presentation/
            ├── bloc/          # bloc/cubit + state + event (Freezed)
            ├── pages/         # màn hình
            └── widgets/       # widget riêng của feature
```

**Ghi chú thiết kế:**
- Bỏ domain layer: **repository interface** đặt ngay trong `data/repositories/` (abstract class + impl cùng chỗ). BLoC gọi thẳng repository. Model DTO đóng luôn vai trò entity.
- `core/` chứa mọi thứ hạ tầng và dùng chung; `features/` chỉ chứa logic nghiệp vụ.
- Thư mục `test/` gương theo `lib/`: `test/features/<feature>/…`.

## 3. Luồng dữ liệu và trách nhiệm từng lớp

```
UI (Page)
  │  đọc state qua BlocBuilder / gửi event qua context.read<Bloc>()
  ▼
BLoC / Cubit  ──────────────► emit State (Freezed union: initial/loading/success/failure)
  │  gọi repository
  ▼
Repository (abstract + impl)  ──► trả Future<Either<Failure, T>>
  │  chọn nguồn dữ liệu, map Exception → Failure
  ├──► RemoteDataSource (Retrofit + Dio)  → gọi API, trả DTO
  └──► LocalDataSource (Hive / SecureStorage) → cache
```

**Quy tắc từng lớp:**

- **DataSource**: chỉ nói chuyện với 1 nguồn (API hoặc Hive). Ném `Exception` (ServerException, CacheException…) khi lỗi. Không biết gì về `Failure` hay `Either`.
- **Repository impl**: bọc lời gọi datasource trong try/catch (qua helper chung `_guard`), map Exception → Failure, trả `Either<Failure, T>`. Là nơi duy nhất quyết định lấy từ remote hay cache.
- **BLoC/Cubit**: gọi repository, dùng `result.fold(onFailure, onSuccess)` để emit state. Không bao giờ tự try/catch hay gọi Dio trực tiếp.
- **UI**: chỉ đọc state và bắn event. Không chứa logic nghiệp vụ.

**State pattern (Freezed union)** — ví dụ màn hình load dữ liệu:

```dart
@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.success(List<Article> items) = _Success;
  const factory HomeState.failure(Failure failure) = _Failure;
}
```

UI dùng `state.when(initial:…, loading:…, success:…, failure:…)` — buộc xử lý đủ mọi trạng thái.

**Cubit hay Bloc?** Quy tắc: **Cubit mặc định** cho phần lớn màn hình (ít boilerplate, gọi method trực tiếp); dùng **Bloc (event-driven)** chỉ cho luồng phức tạp nhiều sự kiện (form nhiều bước, search có debounce).

## 4. Error handling (fpdart Either)

`Failure` là Freezed union tập trung ở `core/error/failure.dart`:

```dart
@freezed
class Failure with _$Failure {
  const factory Failure.server({String? message, int? code}) = ServerFailure;
  const factory Failure.network() = NetworkFailure;          // mất mạng
  const factory Failure.cache() = CacheFailure;
  const factory Failure.unauthorized() = UnauthorizedFailure; // 401
  const factory Failure.unknown([String? message]) = UnknownFailure;
}
```

- **DataSource** ném `Exception`. **Repository** bắt và map sang `Failure` qua helper chung `_guard` để không lặp try/catch.
- Một `ErrorInterceptor` trong Dio chuẩn hoá lỗi HTTP → `ServerException`/`UnauthorizedException` trước khi tới repository.
- UI hiển thị lỗi qua `mapFailureToMessage(failure)` tập trung (đã localize) — mỗi loại `Failure` ra một thông báo người dùng phù hợp.

## 5. Dependency Injection (get_it + injectable)

- Đánh annotation `@injectable` / `@LazySingleton` lên class → chạy `build_runner` sinh `injector.config.dart`.
- Lifetime:
  - DataSource & Repository: `LazySingleton`.
  - Cubit/Bloc: `@injectable` (factory) — mỗi màn hình một instance mới.
- Dio, Hive box, storage service, và `AppConfig` (theo môi trường) cung cấp qua `@module`.
- Test có thể override đăng ký để inject mock.

## 6. Networking (Dio + Retrofit)

Chuỗi interceptor theo thứ tự:

```
Request →  AuthInterceptor      (gắn Bearer token từ SecureStorage)
        →  LoggingInterceptor    (chỉ bật ở flavor dev)
        →  [gọi server]
Response ← ErrorInterceptor      (map HTTP status → Exception, xử lý 401)
```

- API mô tả bằng interface Retrofit (`@RestApi`), sinh code client qua `build_runner`.
- `baseUrl` lấy từ `AppConfig` (theo flavor) — không hard-code.
- 401 → `ErrorInterceptor` phát tín hiệu để router điều hướng về màn login. **Bản đầu không làm token-refresh tự động** (giữ đơn giản; thêm sau nếu cần).

## 7. Environment / Flavor (dev / staging / prod)

- 3 entrypoint: `main_dev.dart`, `main_staging.dart`, `main_prod.dart` — mỗi file set `AppEnv` rồi gọi `bootstrap()`.
- `AppConfig` (cung cấp qua DI `@module` theo env) giữ `baseUrl`, `enableLogging`, tên app…
- Chạy: `flutter run -t lib/main_dev.dart --flavor dev` (kèm cấu hình flavor native: Android `build.gradle`, iOS scheme).
- Không hard-code secret trong source; giá trị theo env (không nhạy cảm) nằm trong `env.dart`. Nếu cần secret thật, dùng `--dart-define`.

## 8. Theming + Dark mode

- `AppTheme.light` và `AppTheme.dark` (Material 3 + `ColorScheme`), màu tập trung ở `app_colors.dart`.
- `themeMode` do `ThemeCubit` quản lý, lưu lựa chọn vào Hive → nhớ giữa các lần mở app.

## 9. Localization (i18n)

- `flutter_localizations` + file `.arb` trong `core/l10n/` (mặc định `en`, `vi`).
- Bật `generate: true` trong `pubspec.yaml` → sinh `AppLocalizations`, dùng `context.l10n.xxx`.
- Ngôn ngữ hiện tại do `LocaleCubit` quản lý và lưu Hive.

## 10. Testing

- **Unit test**: repository (mock datasource), cubit/bloc (mock repository) bằng `mocktail` + `bloc_test`.
- **Widget test**: page (bơm bloc giả).
- DI override trong test để inject mock.
- Cấu trúc test gương theo `lib/`.

## 11. Dependencies dự kiến (pubspec)

**Chính:** `flutter_bloc`, `freezed_annotation`, `json_annotation`, `dio`, `retrofit`, `get_it`, `injectable`, `go_router`, `hive`, `hive_flutter`, `flutter_secure_storage`, `fpdart`, `flutter_localizations` (SDK).

**Dev:** `build_runner`, `freezed`, `json_serializable`, `retrofit_generator`, `injectable_generator`, `hive_generator`, `mocktail`, `bloc_test`.

## 12. Phạm vi bản đầu (YAGNI)

Cố ý **chưa** làm trong bản đầu, thêm khi có nhu cầu thực:
- Token-refresh tự động (chỉ điều hướng về login khi 401).
- Domain layer riêng (usecase/entity tách biệt).
- CSDL quan hệ (Drift) — dùng Hive là đủ.
