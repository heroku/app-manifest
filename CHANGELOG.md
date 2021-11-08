# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

## [1.0.0] - 2021-11-08

### Added
- `AppManifest::ManifestValidator` module performs basic type checking validation for a given manifest hash.
  The Error `AppManifest::InvalidManifest` is raised if the manifest is invalid.

### Changed
- `AppManifest` now uses `AppManifest::ManifestValidator` to validate the manifest hash by default.
  The `validate` named parameter can be set to `false` to disable this.

## [0.5.0] - 2018-07-24

### Added
- `Manifest#environments?` helper method to provide if `environments` data is populated.

## [0.4.0] - 2017-11-28

### Fixed
- Support canonicalization for env shorthands with numeric values(for example:  `{ "env": { "FOO": 5 } }`).

## [0.3.0] - 2017-06-18

### Added
- Manifests are now fully modeled. There are now getters and setters for
  nested data (for example: `manifest.addons.first.plan`).

### Changed
- `Manifest#to_hash` now returns a hash for the current manifest state, rather
  than the hash that was passed in.
- `Manifest#environment` now returns an `Environment` instance, as a result,
  it's serialization will not include nested `environments` data.

### Removed
- `Manifest#manifest` was removed as it was superfluous and potentially
  confusing. `Manifest#to_hash` may be a suitable replacement.

## [0.2.1] - 2017-04-04
### Fixed
- Prevent `NoMethodError on TrueClass` when a `true` or `false` environment variable is provided.

## [0.2.0] - 2017-03-17
### Fixed
- Addon keys are now deep symbolized.
- Legacy formations are not rejected when keys are strings

## [0.1.2] - 2017-02-27
### Fixed
- Reject legacy formations from canonicalized where process is not defined.

## [0.1.1] - 2017-02-24
### Fixed
- Nested canonicalized nodes are now properly symbolized.
