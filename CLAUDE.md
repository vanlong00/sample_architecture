# CLAUDE.md

Hướng dẫn cho Claude Code khi làm việc trong repo này. Đọc file này trước khi sửa code.

## Repo này là gì

Khung kiến trúc Flutter (app quy mô vừa): **feature-first + Clean Architecture rút gọn** (2 lớp `data` / `presentation` mỗi feature, không có domain layer riêng). Stack: flutter_bloc + freezed, dio + retrofit, get_it + injectable, go_router, hive + flutter_secure_storage, fpdart. Chi tiết đầy đủ: [README.md](README.md) và spec trong `docs/superpowers/specs/`.

## Lệnh thường dùng

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # BẮT BUỘC chạy sau khi sửa Freezed/json/retrofit/injectable
flutter gen-l10n                                            # sau khi sửa file .arb
flutter test                                               # chạy test
flutter test <path>                                        # test một file/thư mục
flutter analyze                                            # phân tích tĩnh (phải sạch trước khi coi là xong)
flutter run -t lib/main_dev.dart --flavor dev              # chạy app (dev)
```

## Luật vàng — luồng dữ liệu

```
UI (Page)  →  Cubit/Bloc  →  Repository  →  DataSource  →  API / Hive
```

- **DataSource** chỉ nói chuyện với **một** nguồn, **ném `Exception`** (ServerException/CacheException/…). Không biết `Failure` hay `Either`.
- **Repository** trả `Future<Either<Failure, T>>`, dùng helper `guard(() => ...)` trong `lib/core/error/guard.dart` để map Exception → Failure. **Không bao giờ throw ra ngoài repository.**
- **Cubit/Bloc** gọi repository rồi `result.fold(onFailure, onSuccess)` để emit state. **Không** tự try/catch, **không** gọi Dio trực tiếp.
- **UI** chỉ đọc state qua `state.when(...)` và bắn event. Không chứa logic nghiệp vụ.

State luôn là Freezed union đủ 4 nhánh: `initial / loading / success / failure`.

## Quy ước bắt buộc tuân theo

1. **DI lifetime**: DataSource + Repository = `@LazySingleton` (impl dùng `@LazySingleton(as: AbstractType)`); Cubit/Bloc = `@injectable` (factory). Sau khi thêm/sửa class có annotation DI, **phải** chạy `build_runner`.
2. **Cubit mặc định**; chỉ dùng Bloc event-driven khi luồng nhiều sự kiện (form nhiều bước, search debounce).
3. **Không hard-code `baseUrl` / secret** trong feature — lấy qua `AppConfig` (DI theo env). Secret thật dùng `--dart-define`.
4. **Lỗi cho người dùng** đi qua `mapFailureToMessage(failure, context.l10n)` — không hiển thị message kỹ thuật thô.
5. **i18n**: text hiển thị lấy từ `context.l10n.xxx` (khai báo trong `lib/core/l10n/app_en.arb` + `app_vi.arb`). Không hard-code chuỗi UI.
6. **TDD**: viết test fail trước → code tối thiểu cho pass → commit. Dùng `mocktail` + `bloc_test`.
7. Đặt file test gương theo `lib/`: code ở `lib/features/x/...` → test ở `test/features/x/...`.

## File KHÔNG được sửa tay (code sinh)

Bỏ qua khi review, không chỉnh trực tiếp — sinh lại bằng `build_runner`:

- `*.freezed.dart`
- `*.g.dart`
- `lib/core/di/injector.config.dart`
- `lib/core/l10n/app_localizations*.dart` (sinh bởi `flutter gen-l10n`)

Nếu cần đổi hành vi, sửa file nguồn (`*.dart` gốc / `.arb`) rồi chạy lại lệnh sinh.

## Mẫu tham chiếu

Feature `articles` (`lib/features/articles/`) là mẫu đầy đủ end-to-end. Khi thêm feature mới, **sao chép cấu trúc của `articles`**:

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

## Định nghĩa "xong"

Một thay đổi được coi là hoàn tất khi:
1. `flutter test` xanh (kèm test mới cho code mới).
2. `flutter analyze` không còn issue.
3. `build_runner` đã chạy nếu có đụng tới annotation/Freezed/arb.
4. Đã commit với message rõ ràng (`feat:` / `fix:` / `chore:` / `docs:`).

## Lưu ý môi trường

- Đây là **Windows**. Shell chính là PowerShell; Bash tool cũng dùng được cho lệnh POSIX. Đường dẫn dùng `/` trong lệnh Flutter/Dart.
- Test dựa vào Hive/secure_storage cần platform channel — nếu môi trường CI không có, đánh dấu `skip`/`@Tags(['integration'])` và ghi chú (coverage logic đã có ở các unit test tách biệt).

## Phạm vi hiện tại (đừng tự thêm nếu chưa được yêu cầu)

Cố ý CHƯA làm (YAGNI): token-refresh tự động, domain layer riêng (usecase/entity), Drift (SQLite). 401 hiện chỉ điều hướng về login.
