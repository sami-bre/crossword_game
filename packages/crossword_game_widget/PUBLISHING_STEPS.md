# Publishing Checklist for `crossword_game_widget`

Follow these steps before publishing the package to [pub.dev](https://pub.dev).

## 1. Package Metadata

- [ ] Update `pubspec.yaml`
  - Set a meaningful `description`
  - Replace placeholder `homepage` and `repository` URLs
  - Confirm `version` follows semantic versioning
- [ ] Add a valid `LICENSE` file (MIT, BSD, etc.)
- [ ] Complete `README.md` with usage examples, screenshots, and badges
- [ ] Document the API with Dart doc comments and run `dart doc` locally if desired

## 2. Code Quality

- [ ] Run `flutter analyze` to ensure the code passes static analysis
- [ ] Execute `flutter test` (add tests if needed)
- [ ] Verify that the widget renders correctly using the example app or integration tests

## 3. Assets & Documentation

- [ ] Ensure any assets referenced in the package are included and declared in `pubspec.yaml`
- [ ] Update `CHANGELOG.md` with release notes
- [ ] Consider creating an `example/` app demonstrating typical usage

## 4. Publishing Dry Run

- [ ] Authenticate with pub.dev: `dart pub login`
- [ ] Run `dart pub publish --dry-run` inside the package directory to validate metadata
- [ ] Address any warnings or errors reported by the dry run

## 5. Publish

- [ ] Tag the release in version control (e.g., `git tag v0.1.0`)
- [ ] Publish: `dart pub publish`
- [ ] Verify the package page on pub.dev and monitor for any issues

Refer to the official guide for more details: <https://dart.dev/tools/pub/publishing>.
