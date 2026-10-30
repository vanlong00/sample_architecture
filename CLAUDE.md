# CLAUDE.md

Hướng dẫn cho Claude Code khi làm việc trong repo này. Đọc file này trước khi sửa code.

## Repo này là gì

Khung kiến trúc Flutter (app quy mô vừa): **feature-first + Clean Architecture rút gọn** (2 lớp `data` / `presentation` mỗi feature, không có domain layer riêng). Stack: flutter_bloc + freezed, dio + retrofit, get_it + injectable, go_router, Isar (`LocalStore` key-value + cache), fpdart, [flutter_gen](https://pub.dev/packages/flutter_gen) (sinh code type-safe cho asset). Chi tiết đầy đủ: [README.md](README.md) và spec trong `docs/superpowers/specs/`.

## Lệnh thường dùng

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs   # BẮT BUỘC chạy sau khi sửa Freezed/json/retrofit/injectable
flutter gen-l10n                                            # sau khi sửa file .arb
flutter test                                               # chạy test
flutter test <path>                                        # test một file/thư mục
flutter analyze                                            # phân tích tĩnh (phải sạch trước khi coi là xong)
flutter run -t lib/main_dev.dart --flavor dev              # chạy app (dev)
```

> Dùng `flutter pub run build_runner ...` để luôn gọi đúng Dart SDK đi kèm Flutter. Git dep private (bitbucket) cần `GIT_TERMINAL_PROMPT=0` khi `flutter pub get` để không bị hỏi mật khẩu.

## Luật vàng — luồng dữ liệu

```
UI (Page)  →  Cubit/Bloc  →  Repository  →  DataSource  →  API / Isar
```

- **DataSource** chỉ nói chuyện với **một** nguồn, **ném `Exception`** (ServerException/CacheException/…). Không biết `Failure` hay `Either`.
- **Repository** trả `Future<Either<Failure, T>>`, dùng helper `guard(() => ...)` trong `lib/core/error/guard.dart` để map Exception → Failure. **Không bao giờ throw ra ngoài repository.**
- **Cubit/Bloc** gọi repository rồi `result.fold(onFailure, onSuccess)` để emit state. **Không** tự try/catch, **không** gọi Dio trực tiếp.
- **UI** chỉ đọc state qua `state.when(...)` và bắn event. Không chứa logic nghiệp vụ.

State luôn là Freezed union đủ 4 nhánh: `initial / loading / success / failure`.

### Pipeline lỗi network (3 file phối hợp)

`ErrorInterceptor` (`lib/core/network/interceptors/error_interceptor.dart`) bắt `DioException` ở tầng dio, map status code → Exception cụ thể (401 → `UnauthorizedException`, không có response → `NetworkException`, còn lại → `ServerException`) rồi gắn vào `DioException.error`. `guard()` (`lib/core/error/guard.dart`) đọc `error.error` đó để map tiếp sang `Failure`. `failure_mapper.dart` map `Failure` → chuỗi đã localize qua `l10n`. Khi thêm loại lỗi mới: sửa cả 3 file (`exceptions.dart`, `guard.dart`, `failure_mapper.dart` + thêm key `.arb`), không chỉ một chỗ.

Không có auth: app không dùng token, không có `AuthInterceptor` / secure storage.

## Quy ước bắt buộc tuân theo

1. **DI lifetime**: DataSource + Repository = `@LazySingleton` (impl dùng `@LazySingleton(as: AbstractType)`); Cubit/Bloc = `@injectable` (factory). Sau khi thêm/sửa class có annotation DI, **phải** chạy `flutter pub run build_runner build --delete-conflicting-outputs`.
2. **Cubit mặc định**; chỉ dùng Bloc event-driven khi luồng nhiều sự kiện (form nhiều bước, search debounce).
3. **Không hard-code `baseUrl` / secret** trong feature — lấy qua `AppConfig` (DI theo env). Secret thật dùng `--dart-define`.
4. **Lỗi cho người dùng** đi qua `mapFailureToMessage(failure, context.l10n)` — không hiển thị message kỹ thuật thô.
5. **i18n**: text hiển thị lấy từ `context.l10n.xxx` (khai báo trong `lib/core/l10n/app_en.arb` + `app_vi.arb`). Không hard-code chuỗi UI.
6. **Asset**: ảnh/font đặt trong `assets/images/` (khai báo trong `pubspec.yaml`), tham chiếu qua `Assets.images.xxx` (sinh bởi `flutter_gen`, `lib/core/assets/assets.gen.dart`) — không hard-code đường dẫn asset dạng chuỗi.
7. **TDD**: viết test fail trước → code tối thiểu cho pass → commit. Dùng `mocktail` + `bloc_test`.
8. Đặt file test gương theo `lib/`: code ở `lib/features/x/...` → test ở `test/features/x/...`.

## File KHÔNG được sửa tay (code sinh)

Bỏ qua khi review, không chỉnh trực tiếp — sinh lại bằng `build_runner`:

- `*.freezed.dart`
- `*.g.dart`
- `lib/core/di/injector.config.dart`
- `lib/core/l10n/app_localizations*.dart` (sinh bởi `flutter gen-l10n`)
- `lib/core/assets/assets.gen.dart` (sinh bởi `flutter_gen_runner` qua `build_runner`)

Nếu cần đổi hành vi, sửa file nguồn (`*.dart` gốc / `.arb`) rồi chạy lại lệnh sinh.

## Mẫu tham chiếu

Feature mẫu là `mods` (`lib/features/mods/`; `articles` của sample đã bị xóa). Các feature hiện có: `mods`, `downloads`, `favorites`, `premium`, `settings`, `splash` (trong `lib/features/`). Khi thêm feature mới, **sao chép cấu trúc của `mods`**:

```
features/<feature>/
├── data/
│   ├── models/         # Freezed + json_serializable
│   ├── datasources/    # Retrofit @RestApi, @lazySingleton, ném Exception
│   └── repositories/   # abstract + impl @LazySingleton(as:), trả Either qua guard()
└── presentation/
    ├── bloc/           # <feature>_cubit.dart + <feature>_state.dart (Freezed union)
    ├── pages/          # UI: state.when(...), LoadingView/ErrorView
    └── widgets/
```

Sau khi tạo: thêm route trong `lib/core/router/app_router.dart`, rồi chạy `build_runner`.

### Sinh feature mới bằng Mason (khuyến nghị thay vì copy tay)

Repo có brick Mason local `feature_data_bloc` (`bricks/feature_data_bloc/`, đăng ký trong `mason.yaml`) sinh sẵn toàn bộ cấu trúc trên (data + presentation + test mirror) theo cấu trúc mẫu (`mods`). Thiết kế chi tiết: `docs/superpowers/specs/2026-07-11-mason-feature-brick-design.md`.

```bash
dart pub global activate mason_cli   # 1 lần
mason get                            # resolve brick sau khi clone repo
mason make feature_data_bloc         # trả lời prompt feature_name (số nhiều, vd: products) và entity_name (số ít, vd: product)
```

Sau khi generate, **luôn** làm tiếp các bước thủ công (brick không tự động patch các file này):
1. Thêm route path vào `lib/core/router/routes.dart`.
2. Thêm `GoRoute` cho `<Feature>Page` vào `lib/core/router/app_router.dart`.
3. Chạy `flutter pub run build_runner build --delete-conflicting-outputs`.
4. Điền logic/assertion thật vào test skeleton đã sinh (model chỉ có field mẫu `id`/`name` — sửa lại theo entity thật), rồi chạy `flutter test test/features/<feature>`.

Nếu `bricks/feature_data_bloc/` **chưa tồn tại** trong lần làm việc hiện tại, hãy triển khai brick theo đúng spec ở trên trước khi dùng lệnh `mason make` (dùng skill `writing-plans` để lập kế hoạch nếu việc này chưa có plan).

## Định nghĩa "xong"

Một thay đổi được coi là hoàn tất khi:
1. `flutter test` xanh (kèm test mới cho code mới).
2. `flutter analyze` không còn issue.
3. `build_runner` đã chạy nếu có đụng tới annotation/Freezed/arb.
4. Đã commit với message rõ ràng (`feat:` / `fix:` / `chore:` / `docs:`).

## Lưu ý môi trường

- Dev trên **macOS**, chỉ **Android** (flavors dev/staging/prod; minSdk 24, compileSdk 36). iOS không hỗ trợ.
- Test dựa vào Isar/path_provider cần platform channel — nếu không có, đánh dấu `skip`/`@Tags(['integration'])` và ghi chú.
- **Firebase là Phase 2** (chưa thêm package Firebase / google-services / crashlytics). **Phase 1 phân phối = chỉ Internal testing** trên Play Console.

## Khởi tạo DI (thứ tự quan trọng)

`configureDependencies(env)` trong `lib/core/di/injector.dart`: đăng ký `AppConfig` thủ công **trước** `getIt.init()` (vì các provider khác — vd. `Dio` — phụ thuộc `AppConfig` qua constructor injection trong `RegisterModule`), rồi gọi `getIt.init()` (sinh bởi injectable). Dependency cần khởi tạo async (vd. mở Isar của `LocalStore`, task T3) thì khởi tạo thủ công sau `getIt.init()`, không nhét vào constructor. `LocalStore` (Isar, `lib/core/storage/local_store.dart`) đã có và được `init()` ngay sau `getIt.init()`.

## Ghi chú tích hợp

- Router (`lib/core/router/app_router.dart`): `/` splash, shell 5 tab (`/home /search /downloads /favorites /settings`), `/mod/:sourceId` và `/pro` ở root navigator. `/pro` chỉ được push từ Settings.
- Cubit toàn app (`lib/app.dart`): `ThemeCubit`, `LocaleCubit`, `FavoritesCubit`, `ProStatusCubit`, và MỘT `PaywallCubit` dùng chung (Settings restore + `PaywallPage`).
- `SplashCubit` tự khởi động `AdsService.init()` và `SubscriptionService.initialize()`; đừng thêm init ở `bootstrap`.
- `pubspec.yaml` có `dependency_overrides: html: 0.15.6` vì `flutter_html 3.0.0` không build với `html 0.15.7`; bỏ override khi flutter_html sửa.
- `app_picker` hiện KHÔNG được dùng ở đâu (chờ quyết định giữ/bỏ); chưa xóa khỏi `pubspec.yaml`.
- Test cả app: `test/helpers/app_test_setup.dart` (`setUpAppDi()` = DI thật + Isar tạm + fake network/ads/IAP).

## Phase 2 — Firebase (to-do)

- Thêm dependency Firebase (core, analytics, crashlytics, remote_config).
- Sinh `firebase_options.dart` bằng `flutterfire configure`; thêm gradle plugins (google-services, crashlytics) + `google-services.json` theo flavor.
- Viết thật `RemoteConfigService` và thân `Telemetry` (`lib/core/analytics/telemetry.dart`, hiện là stub).
- Force-update gate.
- Các analytics event còn thiếu.
- `remoteconfig.template.json`.

## Phạm vi hiện tại (đừng tự thêm nếu chưa được yêu cầu)

Cố ý CHƯA làm (YAGNI): token-refresh tự động, domain layer riêng (usecase/entity), Drift (SQLite).
