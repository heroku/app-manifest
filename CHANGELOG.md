# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

### Added

- Manifests are now deeply modeled. There are now getters and setters for
  nested data (e.g. manifest.addons.first.plan)

### Changed

- `Manifest#to_hash` now returns a hash for the current manifest state, rather
  than the hash that was passed in.

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
