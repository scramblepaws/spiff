# Changelog

All notable changes to spiff are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning is
[SemVer](https://semver.org/).

## [Unreleased]

### Added

- Phase 0: project docs (`GOAL`, `ROADMAP`, `ARCHITECTURE`, `CONTEXT`), README,
  LICENSE, `.gitignore`.
- Phase 1: `state`, `util/*` (math, signal, theme, filesystem, index),
  `render/index` native-Instance backend, `manifest`, runtime `loader`, `init`
  returning the `Library` table, smoke test.
- Phase 2/3: `core/window` (ScreenGui, title bar, tab strip, drag, toggle key,
  destroy), `core/page` (tabs + two-column scroll body), `core/section`
  (bordered panel with a dynamic `AddX` surface).
