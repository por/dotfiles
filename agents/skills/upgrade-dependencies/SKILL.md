---
name: upgrade-dependencies
description: Safely upgrade dependencies in JavaScript, TypeScript, or Node.js projects while preserving the existing package manager, lockfile, and working behavior. Use for dependency refreshes, outdated packages, or deliberate major-version migrations.
---

# Upgrade dependencies

Bring the requested dependencies to the latest appropriate stable versions while keeping the project working. Treat the repository's constraints and the user's requested scope as authoritative; do not turn a targeted upgrade into an unrelated modernization.

## Establish the baseline

Before editing, inspect:

- `package.json` files, the existing lockfile, and workspace/monorepo configuration
- the selected package manager and its pinned version, including the `packageManager` field when present
- Node constraints in `engines`, version files, toolchain config, CI, containers, and deployment/runtime configuration
- overrides, resolutions, patched dependencies, catalogs, and intentional exact pins
- scripts for typechecking, linting, tests, builds, and other repository-specific checks
- relevant framework, bundler, test, lint, and deployment-adapter configuration
- Git status, the pre-existing diff, and untracked paths for files likely to be touched

Use only the package manager already selected by the repository (`pnpm`, `npm`, `yarn`, or `bun`). Preserve its lockfile and do not introduce another package manager or lockfile.

Before changing dependencies, run the repository's documented validation workflow or the smallest relevant subset and record the commands and failure signatures. If dependencies must be installed first, use the existing lockfile's frozen or immutable mode so the baseline is not changed. Re-run the same checks after each stage and distinguish unchanged baseline failures from new failures.

Never discard, reset, or overwrite user changes. If a required manifest, config, or source file is already modified, integrate around those edits and review package-manager or codemod output file by file. If upgrade edits cannot be distinguished safely from pre-existing work, stop and ask. Roll back only changes introduced by the upgrade.

## Plan the upgrade

Inventory outdated direct dependencies and dev dependencies in the requested scope, plus packages that may need to move with them for compatibility. Distinguish patch, minor, and major updates, and identify deprecated packages or releases incompatible with the project's Node or package-manager version. A broader inventory can inform the plan but does not authorize unrelated updates.

When a transitive or peer dependency causes a conflict, use the package manager's dependency-tree, `why`, or `explain` capability to identify which direct package and version constraint introduced it. Resolve the owning compatibility unit rather than guessing, adding an override prematurely, or bypassing peer checks.

Group packages that form a compatibility unit, such as:

- a framework, its official plugins, adapters, and lint configuration
- React, React DOM, their type packages, and frameworks that constrain their peer ranges
- a test runner and its plugins or coverage provider
- ESLint, TypeScript, build tools, and their associated plugins
- packages connected by peer dependencies, overrides, or workspace protocol ranges

In a workspace or monorepo, map every declaration of a compatibility unit across package manifests, catalogs, overrides or resolutions, and lockfile importers. Update the owning declarations consistently while preserving workspace or catalog protocols and legitimate package-local constraints.

Preserve intentional pins, prerelease channels, overrides, and patches unless changing them is necessary and within scope. Prefer stable releases; do not introduce alpha, beta, canary, RC, or other prerelease versions unless the repository already intentionally follows that channel or the user asks for it.

Treat configured Node, deployment-platform, and server-runtime support as hard constraints. If a desired dependency version requires changing them, do so only when that change is within the requested scope; otherwise choose the newest compatible stable release or report the blocker and required runtime change.

## Upgrade in diagnosable stages

Within the requested dependency set and necessary compatibility units, apply patch and minor updates separately when that improves diagnosis. Do not update unrelated outdated packages merely because they appear in the inventory. Handle significant majors one at a time or as tightly coupled compatibility units.

For a jump across multiple major versions, determine from official migration guidance whether a direct upgrade is supported or intermediate versions are required. Do not impose intermediate upgrades by habit, but do not skip required migrations merely because the latest version installs.

Before an important major upgrade:

- read the official version-specific release notes and migration guide
- check Node, package-manager, framework, and peer-dependency requirements
- identify relevant breaking changes in this repository
- use official upgrade tools or codemods when available, after reviewing their scope

After each significant stage, inspect the resulting manifest and lockfile diff and run the most relevant available checks. A useful default is typecheck, lint, tests, then build, but follow the repository's documented validation workflow when it differs. For major upgrades, identify the behavior and runtime surfaces affected by the documented breaking changes and exercise the existing integration, end-to-end, smoke, or visual checks that cover them. Fix failures caused by the upgrade before continuing so regressions remain attributable.

Do not force an incompatible dependency tree, use `npm audit fix --force` or an equivalent broad rewrite, suppress type or lint errors, weaken tests, or add peer-dependency bypass flags merely to make installation pass. Treat security-audit findings separately from ordinary version updates and explain any remediation that expands scope.

## Framework-specific checks

Keep the workflow framework-agnostic, but apply these checks when detected.

### Next.js

- Treat Next.js, React, React DOM, relevant React type packages, and `eslint-config-next` as a coordinated compatibility set rather than independent version bumps.
- Follow the migration guide for every crossed Next.js major and use relevant official codemods. Do not assume installing successfully completes the migration.
- Check React peer compatibility, router and rendering behavior, server/client boundaries, caching and data-fetching semantics, SSR/runtime selection, middleware/proxy behavior, bundler changes, and the minimum Node version where relevant to the versions crossed.
- Recheck deployment targets and any platform adapters after build or runtime changes.

### Astro

- Treat Astro, official `@astrojs/*` integrations and adapters, renderer integrations, and their peer ranges as a compatibility set.
- Follow the version-specific Astro migration guides and use the official upgrade command or migration tooling when applicable.
- Verify adapter and integration support before upgrading, especially for SSR, output mode, image handling, content APIs, Vite-facing configuration, and framework renderers such as React.
- Recheck the chosen deployment runtime, adapter configuration, and Node requirements after SSR or runtime changes.

These are prompts for repository-specific investigation, not a reason to change unrelated framework features.

## Final review

When the requested upgrades are complete:

- verify manifests and the lockfile agree and contain no unexpected package-manager changes
- check unresolved peer dependencies, deprecated direct dependencies, and surprising duplicate versions where relevant
- when practical, verify a reproducible install in a clean disposable checkout or CI-style environment using the repository's frozen or immutable lockfile mode
- run the complete available verification suite once more
- review the final diff for unrelated source, config, generated, or lockfile churn

Report:

- packages upgraded, grouped by compatibility unit where useful
- major migrations and resulting source or configuration changes
- packages intentionally left unchanged and the constraint or risk responsible
- remaining warnings, deprecations, audit findings, or baseline failures
- validation commands run and their outcomes

If an upgrade cannot be completed safely within scope, leave that dependency at its last working version, revert only upgrade-introduced edits, and explain the blocker instead of forcing it through.
