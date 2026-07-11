# Mason Feature Brick Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a local Mason brick (`feature_data_bloc`) that scaffolds a complete `articles`-style feature (data + presentation layers + test skeletons) from two prompts (`feature_name`, `entity_name`), matching the repo's Cubit/Freezed/Retrofit/Either conventions exactly.

**Architecture:** A `bricks/feature_data_bloc/` Mason brick with `__brick__/` templates mirroring `lib/features/articles/` and `test/features/articles/` 1:1, using `{{feature_name}}` (plural) for DataSource/Repository/Cubit/State/Page and `{{entity_name}}` (singular) for the Model. A `post_gen.dart` hook prints manual follow-up steps (route registration, build_runner). Verified by generating a throwaway `products`/`product` feature, running `build_runner` + `flutter analyze` + `flutter test` against it, then deleting it.

**Tech Stack:** Mason CLI (`mason_cli`, activated globally via `dart pub global activate`), Mustache-style brick templating (`.snakeCase()`, `.pascalCase()`, `.paramCase()` case transforms), no new pub dependencies in `pubspec.yaml` (Mason is a dev-time global tool, not a project dependency).

## Global Constraints

- Package name for imports in generated tests: `sample_architecture` (from `pubspec.yaml` name field).
- Do not hand-edit generated files (`*.freezed.dart`, `*.g.dart`, `injector.config.dart`) — brick templates that produce Freezed/Retrofit sources must rely on `build_runner`, never hand-write the `.freezed.dart`/`.g.dart` companions.
- Brick must not touch `lib/core/router/app_router.dart` or `lib/core/router/routes.dart` — those are hand-maintained; the post-gen hook only prints instructions.
- Brick vars: `feature_name` (plural, e.g. `articles`) and `entity_name` (singular, e.g. `article`) — both required, no auto-pluralization/singularization.
- Model has exactly two fields: `id` (int), `name` (String) — no dynamic field configuration.
- No barrel files (`export ...`) — codebase convention has none; brick must not introduce any.
- Follow exact naming/annotation conventions documented in `docs/superpowers/specs/2026-07-11-mason-feature-brick-design.md` (sections 4–5) — this plan implements that spec verbatim.
- Windows environment: use `flutter pub run build_runner ...`, never bare `dart run build_runner` (stale standalone `dart` may shadow it in PATH).

---

### Task 1: Mason CLI setup + brick skeleton + `brick.yaml`

**Files:**
- Create: `mason.yaml` (repo root)
- Create: `bricks/feature_data_bloc/brick.yaml`
- Create: `bricks/feature_data_bloc/__brick__/.gitkeep` (placeholder so the empty dir is tracked until Task 2 populates it)

**Interfaces:**
- Produces: brick name `feature_data_bloc` resolvable via `mason make feature_data_bloc`, with vars `feature_name` (string, required) and `entity_name` (string, required) — later tasks' templates read these two vars.

- [ ] **Step 1: Verify Mason CLI is available, install if missing**

Run: `mason --version`

Expected: prints a version like `mason_cli 0.1.x`. If instead you get "command not found" / "'mason' is not recognized", run:

```bash
dart pub global activate mason_cli
```

Then re-run `mason --version` and confirm it now prints a version. If `dart pub global bin` isn't on PATH, the activation command will print the exact PATH line to add — add it for this shell session (e.g. `export PATH="$PATH:$HOME/.pub-cache/bin"` on the Bash tool, or the Windows equivalent for PowerShell) so subsequent `mason` commands in later steps work.

- [ ] **Step 2: Create `mason.yaml` registering the local brick**

Create `d:\Project\sample_architecture\mason.yaml`:

```yaml
bricks:
  feature_data_bloc:
    path: bricks/feature_data_bloc
```

- [ ] **Step 3: Create the brick directory structure**

```bash
mkdir -p /d/Project/sample_architecture/bricks/feature_data_bloc/__brick__
mkdir -p /d/Project/sample_architecture/bricks/feature_data_bloc/hooks
touch /d/Project/sample_architecture/bricks/feature_data_bloc/__brick__/.gitkeep
```

- [ ] **Step 4: Write `brick.yaml`**

Create `d:\Project\sample_architecture\bricks\feature_data_bloc\brick.yaml`:

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

- [ ] **Step 5: Resolve the brick registration**

Run: `mason get`

Expected: output confirms `feature_data_bloc` resolved (e.g. `✓ feature_data_bloc (local)` or similar "getting bricks" success message), no errors.

- [ ] **Step 6: Commit**

```bash
git add mason.yaml bricks/feature_data_bloc/brick.yaml bricks/feature_data_bloc/__brick__/.gitkeep
git commit -m "feat: scaffold Mason feature_data_bloc brick registration"
```

---

### Task 2: `data/` layer templates (model, datasource, repository)

**Files:**
- Create: `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model.dart`
- Create: `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/data/datasources/{{feature_name.snakeCase()}}_remote_datasource.dart`
- Create: `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/data/repositories/{{feature_name.snakeCase()}}_repository.dart`
- Delete: `bricks/feature_data_bloc/__brick__/.gitkeep` (no longer needed once real files exist in `__brick__/`)

**Interfaces:**
- Consumes: vars `feature_name`, `entity_name` from Task 1's `brick.yaml`.
- Produces: for a feature named e.g. `products`/`product`, generates classes `Product` (model), `ProductsRemoteDataSource` (abstract, `getProducts()` returning `Future<List<Product>>`, `@GET('/products')`), `ProductsRepository`/`ProductsRepositoryImpl` (method `fetchProducts()` returning `Future<Either<Failure, List<Product>>>` via `guard()`). Task 3 (state/cubit) and Task 4 (page) consume `ProductsRepository`, `ProductsRemoteDataSource`, and `Product` by these exact names.

- [ ] **Step 1: Write the model template**

Create `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model.dart`:

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

- [ ] **Step 2: Write the remote datasource template**

Create `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/data/datasources/{{feature_name.snakeCase()}}_remote_datasource.dart`:

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

- [ ] **Step 3: Write the repository template**

Create `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/data/repositories/{{feature_name.snakeCase()}}_repository.dart`:

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

- [ ] **Step 4: Remove the now-unneeded placeholder**

```bash
rm /d/Project/sample_architecture/bricks/feature_data_bloc/__brick__/.gitkeep
```

- [ ] **Step 5: Commit**

```bash
git add bricks/feature_data_bloc/__brick__
git commit -m "feat: add data-layer templates to feature_data_bloc brick"
```

---

### Task 3: `presentation/bloc/` templates (state, cubit)

**Files:**
- Create: `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_state.dart`
- Create: `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_cubit.dart`

**Interfaces:**
- Consumes: `{{feature_name.pascalCase()}}Repository` and `fetch{{feature_name.pascalCase()}}()` from Task 2; `{{entity_name.pascalCase()}}` model from Task 2; shared `Failure` type from `lib/core/error/failure.dart` (already exists in the host project, not brick-generated).
- Produces: `{{feature_name.pascalCase()}}State` (sealed Freezed union: `.initial()`, `.loading()`, `.success(List<{{entity_name.pascalCase()}}> items)`, `.failure(Failure failure)`, concrete classes `{{feature_name.pascalCase()}}Initial/Loading/Success/Failure`), `{{feature_name.pascalCase()}}Cubit` (constructor takes `{{feature_name.pascalCase()}}Repository`, exposes `Future<void> load()`). Task 4 (page) consumes `{{feature_name.pascalCase()}}Cubit`, `{{feature_name.pascalCase()}}State`, and calls `.load()`.

- [ ] **Step 1: Write the state template**

Create `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_state.dart`:

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

- [ ] **Step 2: Write the cubit template**

Create `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_cubit.dart`:

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

- [ ] **Step 3: Commit**

```bash
git add bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/presentation/bloc
git commit -m "feat: add bloc templates to feature_data_bloc brick"
```

---

### Task 4: `presentation/pages/` template (page)

**Files:**
- Create: `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/presentation/pages/{{feature_name.snakeCase()}}_page.dart`

**Interfaces:**
- Consumes: `{{feature_name.pascalCase()}}Cubit`, `{{feature_name.pascalCase()}}State` from Task 3; shared `core/error/failure_mapper.dart` (`mapFailureToMessage`), `core/l10n/l10n_ext.dart` (`context.l10n`), `core/widgets/loading_view.dart` (`LoadingView`), `core/widgets/error_view.dart` (`ErrorView`) — all already exist in the host project.
- Produces: `{{feature_name.pascalCase()}}Page` (StatefulWidget) — no other task consumes this; it's the leaf UI.

- [ ] **Step 1: Write the page template**

Create `bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/presentation/pages/{{feature_name.snakeCase()}}_page.dart`:

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

- [ ] **Step 2: Commit**

```bash
git add bricks/feature_data_bloc/__brick__/lib/features/{{feature_name.snakeCase()}}/presentation/pages
git commit -m "feat: add page template to feature_data_bloc brick"
```

---

### Task 5: Test skeleton templates (model, repository, cubit)

**Files:**
- Create: `bricks/feature_data_bloc/__brick__/test/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model_test.dart`
- Create: `bricks/feature_data_bloc/__brick__/test/features/{{feature_name.snakeCase()}}/data/repositories/{{feature_name.snakeCase()}}_repository_test.dart`
- Create: `bricks/feature_data_bloc/__brick__/test/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_cubit_test.dart`

**Interfaces:**
- Consumes: everything from Tasks 2–3 (`{{entity_name.pascalCase()}}`, `{{feature_name.pascalCase()}}RemoteDataSource`, `{{feature_name.pascalCase()}}Repository`/`Impl`, `{{feature_name.pascalCase()}}Cubit`/`State`), plus the fixed host-project package name `sample_architecture` for import paths.
- Produces: nothing consumed by later tasks — these are leaf test files, directly runnable once `build_runner` has generated `.freezed.dart`/`.g.dart` companions for a real generated feature.

- [ ] **Step 1: Write the model test template**

Create `bricks/feature_data_bloc/__brick__/test/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model.dart';

void main() {
  test('fromJson parse đúng các trường', () {
    final item = {{entity_name.pascalCase()}}.fromJson(const {
      'id': 1,
      'name': 'Hello',
    });
    expect(item.id, 1);
    expect(item.name, 'Hello');
  });
}
```

- [ ] **Step 2: Write the repository test template**

Create `bricks/feature_data_bloc/__brick__/test/features/{{feature_name.snakeCase()}}/data/repositories/{{feature_name.snakeCase()}}_repository_test.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/error/exceptions.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/datasources/{{feature_name.snakeCase()}}_remote_datasource.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/repositories/{{feature_name.snakeCase()}}_repository.dart';

class MockRemote extends Mock implements {{feature_name.pascalCase()}}RemoteDataSource {}

void main() {
  late MockRemote remote;
  late {{feature_name.pascalCase()}}Repository repo;

  setUp(() {
    remote = MockRemote();
    repo = {{feature_name.pascalCase()}}RepositoryImpl(remote);
  });

  test('thành công → Right chứa danh sách', () async {
    when(() => remote.get{{feature_name.pascalCase()}}()).thenAnswer(
      (_) async => const [{{entity_name.pascalCase()}}(id: 1, name: 'n')],
    );
    final result = await repo.fetch{{feature_name.pascalCase()}}();
    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected Right'), (list) {
      expect(list, hasLength(1));
      expect(list.first.id, 1);
    });
  });

  test('DioException(Unauthorized) → Left(unauthorized)', () async {
    when(() => remote.get{{feature_name.pascalCase()}}()).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/{{feature_name.paramCase()}}'),
        error: UnauthorizedException(),
      ),
    );
    final result = await repo.fetch{{feature_name.pascalCase()}}();
    expect(
      result,
      equals(left<Failure, List<{{entity_name.pascalCase()}}>>(const Failure.unauthorized())),
    );
  });
}
```

- [ ] **Step 3: Write the cubit test template**

Create `bricks/feature_data_bloc/__brick__/test/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/error/failure.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/repositories/{{feature_name.snakeCase()}}_repository.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_cubit.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_state.dart';

class MockRepo extends Mock implements {{feature_name.pascalCase()}}Repository {}

void main() {
  late MockRepo repo;

  setUp(() => repo = MockRepo());

  blocTest<{{feature_name.pascalCase()}}Cubit, {{feature_name.pascalCase()}}State>(
    'load thành công → [loading, success]',
    build: () {
      when(() => repo.fetch{{feature_name.pascalCase()}}()).thenAnswer(
        (_) async => right(const [{{entity_name.pascalCase()}}(id: 1, name: 'n')]),
      );
      return {{feature_name.pascalCase()}}Cubit(repo);
    },
    act: (c) => c.load(),
    expect: () => [
      const {{feature_name.pascalCase()}}State.loading(),
      const {{feature_name.pascalCase()}}State.success([{{entity_name.pascalCase()}}(id: 1, name: 'n')]),
    ],
  );

  blocTest<{{feature_name.pascalCase()}}Cubit, {{feature_name.pascalCase()}}State>(
    'load lỗi → [loading, failure]',
    build: () {
      when(() => repo.fetch{{feature_name.pascalCase()}}()).thenAnswer(
        (_) async => left(const Failure.network()),
      );
      return {{feature_name.pascalCase()}}Cubit(repo);
    },
    act: (c) => c.load(),
    expect: () => [
      const {{feature_name.pascalCase()}}State.loading(),
      const {{feature_name.pascalCase()}}State.failure(Failure.network()),
    ],
  );
}
```

- [ ] **Step 4: Commit**

```bash
git add bricks/feature_data_bloc/__brick__/test
git commit -m "feat: add test skeleton templates to feature_data_bloc brick"
```

---

### Task 6: Post-gen hook

**Files:**
- Create: `bricks/feature_data_bloc/hooks/post_gen.dart`
- Create: `bricks/feature_data_bloc/hooks/pubspec.yaml`

**Interfaces:**
- Consumes: `mason` package's `HookContext` API, and the same `feature_name` var used throughout Tasks 2–5.
- Produces: console output only — no files or types consumed by other tasks.

- [ ] **Step 1: Write the hook's own `pubspec.yaml`**

Mason hooks are standalone Dart scripts requiring their own `pubspec.yaml` declaring the `mason` package. Create `bricks/feature_data_bloc/hooks/pubspec.yaml`:

```yaml
name: feature_data_bloc_hooks
publish_to: none
environment:
  sdk: ^3.4.0
dependencies:
  mason: ^0.1.1
```

- [ ] **Step 2: Write `post_gen.dart`**

Create `bricks/feature_data_bloc/hooks/post_gen.dart`:

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

- [ ] **Step 3: Resolve hook dependencies**

```bash
cd /d/Project/sample_architecture/bricks/feature_data_bloc/hooks && dart pub get
cd /d/Project/sample_architecture
```

Expected: `dart pub get` completes with no errors (resolves the `mason` package for the hook script).

- [ ] **Step 4: Commit**

```bash
git add bricks/feature_data_bloc/hooks
git commit -m "feat: add post-gen hook to feature_data_bloc brick"
```

---

### Task 7: End-to-end verification with a throwaway feature, then cleanup

**Files:**
- Temporary (generated then deleted): `lib/features/products/**`, `test/features/products/**`
- No permanent files created or modified by this task.

**Interfaces:**
- Consumes: the complete brick from Tasks 1–6.
- Produces: nothing persisted — this task only verifies the brick works and leaves the repo clean.

- [ ] **Step 1: Generate a throwaway feature via Mason**

```bash
cd /d/Project/sample_architecture
mason make feature_data_bloc --feature_name products --entity_name product -o .
```

Expected: Mason reports files created under `lib/features/products/` and `test/features/products/`, then prints the post-gen hook's instructions block (from Task 6) ending with `flutter test test/features/products`.

- [ ] **Step 2: Verify the generated file tree matches spec**

```bash
find lib/features/products test/features/products -type f
```

Expected output (paths, order may vary):
```
lib/features/products/data/models/product_model.dart
lib/features/products/data/datasources/products_remote_datasource.dart
lib/features/products/data/repositories/products_repository.dart
lib/features/products/presentation/bloc/products_state.dart
lib/features/products/presentation/bloc/products_cubit.dart
lib/features/products/presentation/pages/products_page.dart
test/features/products/data/models/product_model_test.dart
test/features/products/data/repositories/products_repository_test.dart
test/features/products/presentation/bloc/products_cubit_test.dart
```

- [ ] **Step 3: Run build_runner to generate Freezed/Retrofit/injectable companions**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Expected: build succeeds with no errors; `product_model.freezed.dart`, `product_model.g.dart`, `products_remote_datasource.g.dart`, `products_state.freezed.dart` appear under `lib/features/products/`, and `lib/core/di/injector.config.dart` is updated to register `ProductsRemoteDataSource`, `ProductsRepository`, `ProductsCubit`.

- [ ] **Step 4: Run static analysis**

```bash
flutter analyze
```

Expected: `No issues found!` (the generated `products` feature must not introduce any analyzer warnings/errors).

- [ ] **Step 5: Run the generated tests**

```bash
flutter test test/features/products
```

Expected: all tests pass (model fromJson test, repository success/unauthorized tests, cubit success/failure blocTest cases) — 5 tests total, 0 failures.

- [ ] **Step 6: Delete the throwaway feature and regenerate injector config**

```bash
rm -rf lib/features/products test/features/products
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
```

Expected: both commands succeed cleanly — `injector.config.dart` no longer references `Products*` classes, `flutter analyze` reports `No issues found!`.

- [ ] **Step 7: Confirm no throwaway artifacts remain, then commit any resulting `injector.config.dart` diff**

```bash
git status
```

Expected: only `lib/core/di/injector.config.dart` shows as modified (reverted back to not knowing about `Products*`), no `products` files listed as untracked. If `injector.config.dart` differs from its state before this task started, commit it:

```bash
git add lib/core/di/injector.config.dart
git commit -m "chore: regenerate injector.config.dart after brick verification cleanup"
```

If `git status` shows no diff at all (injector config was already clean), skip the commit.

---

## Post-Plan Note

`CLAUDE.md` already documents brick usage (`mason make feature_data_bloc`, follow-up manual steps) — no further doc changes needed once this plan's tasks are complete.
