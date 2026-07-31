# Developer Guide

## Prerequisites

See [`SETUP.md`](SETUP.md) for getting a local environment running. This
doc assumes that's already done.

## Adding a new feature module

Every feature follows the same shape (see [`ARCHITECTURE.md`](ARCHITECTURE.md)
for the reasoning). To add one, e.g. a hypothetical `widgets` feature:

1. **Entity** — `lib/features/widgets/domain/entities/widget.dart`, a
   `@freezed` class with a hand-written `fromRow(Map<String, dynamic>)`
   factory (not `json_serializable` — see the note below on why).
2. **Repository interface** — `lib/features/widgets/domain/repositories/widget_repository.dart`,
   an abstract class returning `Future<Result<T>>` from every method.
3. **Repository impl** — `lib/features/widgets/data/repositories/widget_repository_impl.dart`,
   wrapping a `SupabaseClient`, every method wrapped in try/catch mapping
   exceptions to `ServerFailure`/`AuthFailure`/etc.
4. **Providers** — `lib/features/widgets/presentation/controllers/widget_providers.dart`:
   a `Provider<WidgetRepository>` binding the interface to the impl, plus
   whatever `FutureProvider`/`AsyncNotifierProvider` the UI needs.
5. **Pages/widgets** — `lib/features/widgets/presentation/pages/` and
   `presentation/widgets/`, depending only on the providers, never
   constructing a repository impl directly.
6. **Route** (if it's a full page) — register in
   `lib/core/routing/app_router.dart`; add a nav destination in
   `lib/core/widgets/admin_shell.dart` if it's an admin section.
7. **Migration** (if it needs new tables/columns) — a new numbered file
   under `supabase/migrations/`, applied to your Supabase project and
   documented in `docs/DATABASE_SCHEMA.md`.
8. **Tests** — at minimum, one unit test for the repository's error path
   (mocktail, Supabase-throws → `Failure` — see any existing
   `*_repository_impl_test.dart` for the pattern) and, if it's a widget
   with meaningfully different states, a widget test overriding the
   repository provider with a fake.

### Why `fromRow` instead of `json_serializable`

Entities use a hand-written `factory X.fromRow(Map<String, dynamic> json)`
rather than delegating to `json_serializable`. Freezed auto-detects any
factory literally named `fromJson` and assumes it should generate a
matching `.g.dart` part for it — which conflicts with a hand-written body
(discovered the hard way in Phase 1: renaming the factory to `fromRow`
fixed it). It also avoids needing `@JsonKey(name: '...')` on every field
whose Dart name differs from its snake_case column name.

### Why no `riverpod_generator`

`riverpod_generator` had a version conflict with the `meta` package
pinned by this Flutter SDK (Phase 1). Every provider in this app is a
plain, hand-written Riverpod provider — no code generation for state
management, only for Freezed/JSON.

## Running codegen

```
flutter pub run build_runner build --delete-conflicting-outputs
```

Needed after adding/changing any `@freezed` class. `--delete-conflicting-outputs`
is silently ignored by the current `build_runner` version (a known
harmless warning) — the build still runs correctly.

## Running tests

```
flutter analyze     # static analysis — keep this clean
flutter test         # unit + widget tests
flutter build web    # confirms the web target actually compiles
```

All three are required to pass before considering a change done — this is
the same sequence run manually after every phase of this project's
development and now automated in `.github/workflows/ci.yml`.

### Testing patterns already established

- **Repository unit tests**: mock `SupabaseClient` with `mocktail`, stub
  `client.from(any())` (or `client.storage`) to throw, assert the
  repository returns `Left(ServerFailure(...))`. See
  `test/features/categories/data/repositories/category_repository_impl_test.dart`
  for the canonical example. Testing the *success* path would mean
  mocking Postgrest's full filter-builder chain — judged disproportionate
  effort for the value versus testing the entity's own `fromRow` mapping
  directly (see `test/features/products/domain/entities/product_test.dart`).
- **Widget tests**: override the relevant `Provider<XRepository>` with a
  small local `Fake`/hand-written class implementing the interface — never
  try to hit a real (uninitialized) `Supabase.instance` in a widget test.
  See `test/features/categories/presentation/pages/category_list_page_test.dart`.
- **Don't try to render the real 3D viewer in a widget test** — confirmed
  in Phase 5 that `model_viewer_plus` throws
  `A platform implementation for 'webview_flutter' has not been set`
  without a registered fake `WebViewPlatform`, which this project doesn't
  set up. Rely on `flutter analyze`/`flutter build web` for that code
  path instead.
- **Integration tests** (`integration_test/`) need a real
  device/emulator/browser to actually run — see the header comment in
  `integration_test/app_test.dart`.

## Code style

- No comments explaining *what* code does — only *why*, when it's
  non-obvious (a platform limitation, a workaround, a deliberate scope
  cut). If you're about to write a comment restating the code below it,
  delete the comment instead.
- Prefer editing existing files/patterns over introducing a new
  abstraction for something used once.
- Don't add a dependency you only need transitively — if you import a
  package directly, add it to `pubspec.yaml` directly too (the
  `depend_on_referenced_packages` lint catches this).
