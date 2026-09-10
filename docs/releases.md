# Release Process

> Last updated: 2026-09-10

This document describes how to create and publish a new release of the firmware.

## Prerequisites

- GitHub push access to `lookymlive/ESP32-Groq-Speech-to-Text`
- The repo default branch (`main`) is up to date

## Release Steps

### 1. Update the version

Edit `Code/version.h`:

```cpp
#define FIRMWARE_VERSION  "1.1.0"   // bump this
```

### 2. Update the changelog

Edit `CHANGELOG.md` and add a new version section under `[Unreleased]`:

```markdown
## [1.1.0] - 2026-09-10

### Added
- Your new features here
```

### 3. Review changes

```bash
git diff
git log --oneline main
```

### 4. Commit

```bash
git add Code/version.h CHANGELOG.md
git commit -m "chore(release): bump version to 1.1.0"
git push origin main
```

### 5. Create a Git tag

```bash
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin v1.1.0
```

### 6. Create a GitHub Release

1. Go to **Releases** → **Draft new release**.
2. Select the tag `v1.1.0`.
3. Set the title to `v1.1.0`.
4. Write release notes summarizing changes.
5. Click **Publish release**.

## Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** — incompatible API changes
- **MINOR** — new features, backward compatible
- **PATCH** — bug fixes, backward compatible

## Pre-release Checklist

- [ ] Version bumped in `Code/version.h`
- [ ] `CHANGELOG.md` updated
- [ ] CI workflow passes on `main`
- [ ] README reflects any new features
- [ ] Docs in `docs/` are up to date
- [ ] `secrets.h` template has no real credentials
- [ ] `.env.local` is git-ignored

---

[← Back to docs index](README.md)
