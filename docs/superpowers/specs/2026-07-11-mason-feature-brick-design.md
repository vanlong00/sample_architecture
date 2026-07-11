# Mason Brick: Sinh Feature Mẫu (data + presentation)

**Ngày:** 2026-07-11
**Mục tiêu:** Tự động hóa việc sao chép cấu trúc feature `articles` (xem `lib/features/articles/`) khi tạo feature mới, giảm thao tác thủ công lặp lại và giữ đúng convention trong `CLAUDE.md`.

## 1. Phạm vi

Một brick Mason local (không publish lên pub.dev/BrickHub), tên `feature_data_bloc`, sinh toàn bộ 1 feature theo luồng:

```
UI (Page) → Cubit → Repository → DataSource → API
```

Bao gồm cả code chính (`lib/`) và test skeleton mirror (`test/`), nhưng **không** tự động:
- Đăng ký route vào `app_router.dart` / `routes.dart` (file tay, không auto-discover).
- Chạy `build_runner` (dev tự chạy sau khi generate).
- Sinh field model tùy biến (model chỉ có field mẫu tối giản, dev tự mở rộng).

## 2. Cài đặt Mason trong repo

- Thêm `mason_cli` như global activate hoặc qua `dart pub global activate mason_cli` (ghi hướng dẫn trong README, không cần thêm vào `pubspec.yaml` vì mason là dev-tool ngoài project).
- Tạo `mason.yaml` ở root repo, khai báo brick local:
  ```yaml
  bricks:
    feature_data_bloc:
      path: bricks/feature_data_bloc
  ```
- Chạy `mason get` sau khi thêm để resolve brick.

## 3. Cấu trúc brick

```
bricks/feature_data_bloc/
├── brick.yaml
├── hooks/
│   └── post_gen.dart
└── __brick__/
    ├── lib/features/{{feature_name.snakeCase()}}/
    │   ├── data/
    │   │   ├── models/{{entity_name.snakeCase()}}_model.dart
    │   │   ├── datasources/{{feature_name.snakeCase()}}_remote_datasource.dart
    │   │   └── repositories/{{feature_name.snakeCase()}}_repository.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── {{feature_name.snakeCase()}}_cubit.dart
    │       │   └── {{feature_name.snakeCase()}}_state.dart
    │       └── pages/{{feature_name.snakeCase()}}_page.dart
    └── test/features/{{feature_name.snakeCase()}}/
        ├── data/
        │   ├── models/{{entity_name.snakeCase()}}_model_test.dart
        │   └── repositories/{{feature_name.snakeCase()}}_repository_test.dart
        └── presentation/
            └── bloc/{{feature_name.snakeCase()}}_cubit_test.dart
```

## 4. Biến (`brick.yaml` vars)

| Biến | Kiểu | Bắt buộc | Ví dụ | Dùng cho |
|---|---|---|---|---|
| `feature_name` | string | có | `articles` | Tên folder feature, class `DataSource`/`Repository`/`Cubit`/`State`/`Page`, route path gợi ý, API endpoint `/{{feature_name}}` |
| `entity_name` | string | có | `article` | Class Model (`{{entity_name.pascalCase()}}`), tên file `{{entity_name.snakeCase()}}_model.dart` |

Không suy luận số ít/số nhiều tự động giữa hai biến (tránh lỗi kiểu `category` → `categorys`) — cả hai đều bắt buộc nhập tay.

`brick.yaml`:
```yaml
name: feature_data_bloc
description: Sinh 1 feature theo mẫu articles (data + presentation, Cubit/Freezed/Retrofit/Either)
version: 0.1.0
environment:
  mason: ">=0.1.0 <0.2.0"
vars:
  feature_name:
    type: string
    description: Tên feature, số nhiều, snake_case-able (vd articles, products)
    prompt: "Tên feature (số nhiều, vd: products)"
  entity_name:
    type: string
    description: Tên entity, số ít, dùng cho model class (vd article, product)
    prompt: "Tên entity (số ít, vd: product)"
```

## 5. Nội dung từng file sinh ra

Bám sát 1:1 cấu trúc/annotation của `articles` đã khảo sát, chỉ thay tên bằng biến Mason.

**Model** (`{{entity_name.snakeCase()}}_model.dart`):
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{entity_name.snakeCase()}}_model.freezed.dart';
part '{{entity_name.snakeCase()}}_model.g.dart';

@freezed
abstract class {{entity_name.pascalCase()}} with _${{entity_name.pascalCase()}} {
  const factory {{entity_name.pascalCase()}}({
    required int id,
    required String name,
  }) = _{{entity_name.pascalCase()}};

  factory {{entity_name.pascalCase()}}.fromJson(Map<String, dynamic> json) =>
      _${{entity_name.pascalCase()}}FromJson(json);
}
```

**DataSource** (`{{feature_name.snakeCase()}}_remote_datasource.dart`):
```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/{{entity_name.snakeCase()}}_model.dart';

part '{{feature_name.snakeCase()}}_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class {{feature_name.pascalCase()}}RemoteDataSource {
  @factoryMethod
  factory {{feature_name.pascalCase()}}RemoteDataSource(Dio dio) = _{{feature_name.pascalCase()}}RemoteDataSource;

  @GET('/{{feature_name.paramCase()}}')
  Future<List<{{entity_name.pascalCase()}}>> get{{feature_name.pascalCase()}}();
}
```

**Repository** (`{{feature_name.snakeCase()}}_repository.dart`):
```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/guard.dart';
import '../datasources/{{feature_name.snakeCase()}}_remote_datasource.dart';
import '../models/{{entity_name.snakeCase()}}_model.dart';

abstract class {{feature_name.pascalCase()}}Repository {
  Future<Either<Failure, List<{{entity_name.pascalCase()}}>>> fetch{{feature_name.pascalCase()}}();
}

@LazySingleton(as: {{feature_name.pascalCase()}}Repository)
class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  {{feature_name.pascalCase()}}RepositoryImpl(this._remote);

  final {{feature_name.pascalCase()}}RemoteDataSource _remote;

  @override
  Future<Either<Failure, List<{{entity_name.pascalCase()}}>>> fetch{{feature_name.pascalCase()}}() =>
      guard(() => _remote.get{{feature_name.pascalCase()}}());
}
```

**State** (`{{feature_name.snakeCase()}}_state.dart`):
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/{{entity_name.snakeCase()}}_model.dart';

part '{{feature_name.snakeCase()}}_state.freezed.dart';

@freezed
sealed class {{feature_name.pascalCase()}}State with _${{feature_name.pascalCase()}}State {
  const factory {{feature_name.pascalCase()}}State.initial() = {{feature_name.pascalCase()}}Initial;
  const factory {{feature_name.pascalCase()}}State.loading() = {{feature_name.pascalCase()}}Loading;
  const factory {{feature_name.pascalCase()}}State.success(List<{{entity_name.pascalCase()}}> items) = {{feature_name.pascalCase()}}Success;
  const factory {{feature_name.pascalCase()}}State.failure(Failure failure) = {{feature_name.pascalCase()}}Failure;
}
```

**Cubit** (`{{feature_name.snakeCase()}}_cubit.dart`):
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/{{feature_name.snakeCase()}}_repository.dart';
import '{{feature_name.snakeCase()}}_state.dart';

@injectable
class {{feature_name.pascalCase()}}Cubit extends Cubit<{{feature_name.pascalCase()}}State> {
  {{feature_name.pascalCase()}}Cubit(this._repository) : super(const {{feature_name.pascalCase()}}State.initial());

  final {{feature_name.pascalCase()}}Repository _repository;

  Future<void> load() async {
    emit(const {{feature_name.pascalCase()}}State.loading());
    final result = await _repository.fetch{{feature_name.pascalCase()}}();
    result.fold(
      (failure) => emit({{feature_name.pascalCase()}}State.failure(failure)),
      (items) => emit({{feature_name.pascalCase()}}State.success(items)),
    );
  }
}
```

**Page** (`{{feature_name.snakeCase()}}_page.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/{{feature_name.snakeCase()}}_cubit.dart';
import '../bloc/{{feature_name.snakeCase()}}_state.dart';

class {{feature_name.pascalCase()}}Page extends StatefulWidget {
  const {{feature_name.pascalCase()}}Page({super.key});

  @override
  State<{{feature_name.pascalCase()}}Page> createState() => _{{feature_name.pascalCase()}}PageState();
}

class _{{feature_name.pascalCase()}}PageState extends State<{{feature_name.pascalCase()}}Page> {
  @override
  void initState() {
    super.initState();
    context.read<{{feature_name.pascalCase()}}Cubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appTitle)),
      body: BlocBuilder<{{feature_name.pascalCase()}}Cubit, {{feature_name.pascalCase()}}State>(
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingView(),
            loading: () => const LoadingView(),
            success: (items) => ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(items[i].name),
              ),
            ),
            failure: (failure) => ErrorView(
              message: mapFailureToMessage(failure, context.l10n),
              onRetry: () => context.read<{{feature_name.pascalCase()}}Cubit>().load(),
            ),
          );
        },
      ),
    );
  }
}
```

**Test skeleton** — mỗi test file sinh sẵn cấu trúc `mocktail`/`bloc_test` với TODO cho assertion cụ thể (không sinh page test do phức tạp về `AppLocalizations` delegate setup, dev tự viết theo TDD nếu cần):

- `{{entity_name.snakeCase()}}_model_test.dart`: test `fromJson`/`toJson` roundtrip cơ bản, đánh dấu TODO khớp field thật.
- `{{feature_name.snakeCase()}}_repository_test.dart`: `MockRemote extends Mock implements {{feature_name.pascalCase()}}RemoteDataSource {}`, test case thành công (`right`) và lỗi (map exception → `left(Failure)`).
- `{{feature_name.snakeCase()}}_cubit_test.dart`: `blocTest` cho `[loading, success]` và `[loading, failure]`.

## 6. Post-gen hook

`hooks/post_gen.dart` chỉ in hướng dẫn console, không patch file tay:

```dart
import 'package:mason/mason.dart';

void run(HookContext context) {
  final featureName = context.vars['feature_name'];
  context.logger.info('''
✅ Feature "$featureName" đã được tạo.

Việc còn lại (thủ công):
1. Thêm route path vào lib/core/router/routes.dart
2. Thêm GoRoute cho ${featureName}Page vào lib/core/router/app_router.dart
3. Chạy: flutter pub run build_runner build --delete-conflicting-outputs
4. Chạy: flutter test test/features/$featureName
''');
}
```

## 7. Kiểm thử việc triển khai brick

Không phải code sản phẩm nên không áp dụng TDD cho brick. Thay vào đó, xác minh bằng cách:
1. `mason make feature_data_bloc --feature_name products --entity_name product -o lib_test_output/` (hoặc chạy thẳng vào `lib/`/`test/` với feature giả để kiểm tra rồi xoá) — kiểm tra cấu trúc/tên file/class sinh ra đúng.
2. `flutter pub run build_runner build --delete-conflicting-outputs` — đảm bảo code sinh ra biên dịch được (freezed/json_serializable/retrofit/injectable không lỗi).
3. `flutter analyze` sạch trên code vừa sinh.
4. Xoá thư mục thử nghiệm sau khi xác minh xong, không để lại feature giả trong repo.

## 8. Ngoài phạm vi (không làm)

- Không tự động patch `app_router.dart`/`routes.dart`.
- Không hỗ trợ khai báo field động qua Mason var (model chỉ có field mẫu `id`/`name`).
- Không publish brick lên BrickHub — chỉ dùng local trong repo.
- Không sinh local datasource (Hive) mẫu — feature `articles` chỉ có remote, brick theo sát đúng mẫu này.
