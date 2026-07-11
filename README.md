# sample_architecture

Khung kiến trúc codebase **Flutter** cho app quy mô vừa, một team nhỏ — cân bằng giữa cấu trúc sạch và tốc độ phát triển.

Dự án này là một **bộ khung (skeleton) sẵn sàng phát triển**: đầy đủ hạ tầng dùng chung (config, DI, error, network, storage, router, theme, i18n) và một feature mẫu `articles` chạy xuyên suốt mọi lớp để làm mẫu tham chiếu.

---

## Kiến trúc tổng quan

Feature-first + **Clean Architecture rút gọn** (2 lớp mỗi feature, bỏ domain layer riêng):

```
UI (Page)  →  Cubit/Bloc  →  Repository  →  DataSource  →  API / Hive
   ▲              │              │              │
 state.when   emit State   Either<Failure,T>  throw Exception
```

- **DataSource** — nói chuyện với **một** nguồn (API hoặc Hive), ném `Exception` khi lỗi.
- **Repository** — map Exception → `Failure`, trả `Future<Either<Failure, T>>` (fpdart). Nơi duy nhất quyết định remote hay cache.
- **Cubit/Bloc** — gọi repository, `fold` kết quả và emit state (Freezed union: `initial/loading/success/failure`).
- **UI** — chỉ đọc state qua `state.when(...)` và bắn event. Không chứa logic nghiệp vụ.

Quy tắc: **Cubit mặc định**; chỉ dùng **Bloc (event-driven)** cho luồng nhiều sự kiện (form nhiều bước, search debounce).

## Stack

| Mối quan tâm | Lựa chọn |
|---|---|
| State management | flutter_bloc (Cubit/Bloc) + freezed |
| Kiến trúc | Feature-first, Clean Architecture rút gọn (presentation / data) |
| Networking | dio + retrofit |
| Dependency Injection | get_it + injectable |
| Routing | go_router |
| Local storage | hive (cache) + flutter_secure_storage (token) |
| Error handling | fpdart `Either<Failure, T>` |
| i18n | flutter_localizations + arb (`en`, `vi`) |
| Môi trường | flavor `dev` / `staging` / `prod` |

## Cấu trúc thư mục

```
lib/
├── main_dev.dart / main_staging.dart / main_prod.dart   # entrypoint theo flavor
├── bootstrap.dart      # init Hive, DI, BlocObserver → runApp
├── app.dart            # MaterialApp.router + theme + locale
├── core/               # hạ tầng dùng chung (không thuộc feature nào)
│   ├── config/         # AppEnv, AppConfig (baseUrl/flags theo env)
│   ├── di/             # get_it + injectable (injector.dart)
│   ├── error/          # Exception, Failure (Freezed), guard, failure_mapper
│   ├── network/        # dio_client + interceptors (auth/logging/error)
│   ├── storage/        # HiveService, SecureStorageService
│   ├── router/         # go_router (app_router.dart, routes.dart)
│   ├── theme/          # AppTheme (light/dark, Material 3), AppColors
│   ├── l10n/           # app_en.arb, app_vi.arb, l10n_ext.dart
│   └── widgets/        # LoadingView, ErrorView (dùng chung)
└── features/
    ├── settings/       # ThemeCubit + LocaleCubit (lưu Hive)
    └── articles/       # feature mẫu end-to-end
        ├── data/       # models (Freezed+json), datasources (Retrofit), repositories (Either)
        └── presentation/  # bloc (cubit+state), pages, widgets
```

`test/` gương theo `lib/`.

## Bắt đầu

Yêu cầu: Flutter SDK 3.22+ (Dart 3.4+).

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs   # sinh Freezed / json / retrofit / injectable
flutter gen-l10n                                            # sinh AppLocalizations
```

> Trên Windows, nếu có bản `dart` standalone cũ hơn nằm trước trong PATH (vd. `dart-sdk` cũ), lệnh `dart run build_runner ...` trần có thể lỗi âm thầm. Dùng `flutter pub run build_runner ...` để chắc chắn chạy đúng Dart SDK đi kèm Flutter.

## Chạy app (theo flavor)

```bash
flutter run -t lib/main_dev.dart     --flavor dev
flutter run -t lib/main_staging.dart --flavor staging
flutter run -t lib/main_prod.dart    --flavor prod
```

`baseUrl` và các cờ được lấy qua `AppConfig` theo flavor — **không hard-code** trong feature. Secret thật (nếu cần) truyền qua `--dart-define`.

## Test

```bash
flutter test                    # toàn bộ
flutter test test/features/articles   # theo thư mục
```

Dùng `mocktail` + `bloc_test`. Mỗi lớp test độc lập: repository (mock datasource), cubit (mock repository), page (bơm cubit giả).

## Thêm một feature mới

1. Tạo `lib/features/<feature>/data/{models,datasources,repositories}` và `presentation/{bloc,pages,widgets}`.
2. **Model**: Freezed + json_serializable.
3. **DataSource**: Retrofit `@RestApi` + `@lazySingleton`, ném Exception.
4. **Repository**: abstract + impl `@LazySingleton(as: ...)`, trả `Either<Failure, T>` qua helper `guard`.
5. **Cubit**: `@injectable`, state Freezed union `initial/loading/success/failure`.
6. **Page**: render bằng `state.when(...)`, dùng `LoadingView`/`ErrorView` + `mapFailureToMessage`.
7. Thêm route vào `core/router/app_router.dart`.
8. Chạy lại `flutter pub run build_runner build --delete-conflicting-outputs` để cập nhật DI.

## Quy ước

- Repository **không bao giờ** throw ra ngoài — luôn trả `Either`.
- DI lifetime: DataSource + Repository = `@LazySingleton`; Cubit/Bloc = `@injectable` (factory, mỗi màn hình một instance).
- Lỗi hiển thị cho người dùng đi qua `mapFailureToMessage` (đã localize) — không hiển thị message kỹ thuật thô.
- File `*.freezed.dart`, `*.g.dart`, `*.config.dart` là code sinh — không sửa tay, không review.

## Phạm vi bản đầu (YAGNI)

Cố ý chưa làm, thêm khi có nhu cầu thực: token-refresh tự động (401 → điều hướng login), domain layer riêng (usecase/entity), CSDL quan hệ (Drift).

## Tài liệu

- Hướng dẫn kiến trúc chi tiết (dựa trên code đã dựng): [docs/architecture.md](docs/architecture.md)
- Thiết kế kiến trúc (spec gốc): [docs/superpowers/specs/2026-07-11-flutter-architecture-design.md](docs/superpowers/specs/2026-07-11-flutter-architecture-design.md)
- Kế hoạch triển khai: [docs/superpowers/plans/2026-07-11-flutter-architecture.md](docs/superpowers/plans/2026-07-11-flutter-architecture.md)
- Hướng dẫn cho Claude Code: [CLAUDE.md](CLAUDE.md)
