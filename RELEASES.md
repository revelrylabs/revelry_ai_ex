# Releasing a new version

## Preparation
- [ ] Update the package version in `mix.exs`
- [ ] Update the package version badge and installation instructions in `README.md`
- [ ] Add an entry to `CHANGELOG.md` — call out **breaking changes** explicitly with before/after migration examples. Dependabot includes changelog entries in its version-bump PRs, so this is how downstream consumers find out about breaking changes.

## Release Process
- [ ] Make sure all changes in the `Preparation` section are in `main`
- [ ] In GitHub, create, and publish, a new release with appropriate notes (copy the breaking-changes section from `CHANGELOG.md`), and version matching the package version `mix.exs`
- [ ] The github actions workflow should automatically publish the package and docs to hex
