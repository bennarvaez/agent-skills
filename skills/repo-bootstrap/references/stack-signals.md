# Stack signals

Use these to recognise the stack and find its canonical commands. A repo often has several stacks; profile each one.

| Signal | Implies |
|---|---|
| `package.json`, lockfiles (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `bun.lockb`) | Node/TS. Take commands from `scripts`. The lockfile names the package manager. |
| `pyproject.toml`, `requirements*.txt`, `tox.ini`, `noxfile.py`, `uv.lock`, `poetry.lock` | Python; test and lint tooling |
| `*.sln`, `*.csproj`, `Directory.Build.props`, `global.json` | .NET |
| `go.mod` | Go |
| `Cargo.toml`, `Cargo.lock`, `rust-toolchain.toml`, `rustfmt.toml`, `clippy.toml` | Rust. Workspace members in `Cargo.toml`; `[patch]` and `vendor/` mean patched dependencies (never-touch). |
| `pom.xml`, `build.gradle(.kts)`, `gradlew`, `settings.gradle` | Java/Kotlin (Maven or Gradle). Prefer the wrapper (`./gradlew`, `./mvnw`). |
| `Package.swift`, `*.xcodeproj`, `*.xcworkspace` | Swift / Apple platforms |
| `CMakeLists.txt`, `meson.build`, `conanfile.*`, `vcpkg.json` | C/C++ |
| `Gemfile`, `*.gemspec` | Ruby |
| `composer.json` | PHP |
| `pubspec.yaml` | Dart/Flutter |
| `*.tf`, `.terraform.lock.hcl`, `.tflint.hcl`, `cloud {}` / `backend {}` blocks, `*.tfvars` | Terraform. Note TFE/TFC workspaces, environments, module layout. State is never-touch. |
| `ansible.cfg`, `playbooks/`, `roles/`, `requirements.yml`, `ansible-navigator.yml`, `execution-environment.yml` | Ansible. Note connection methods, inventories, EE image. Production inventories are never-touch. |
| `*.ps1`, `*.psm1`, `*.psd1`, `PSScriptAnalyzerSettings.psd1`, `*.Tests.ps1` | PowerShell (Pester tests) |
| `Chart.yaml`, `values*.yaml`, `kustomization.yaml`, k8s manifests | Helm / Kubernetes |
| `Dockerfile`, `compose*.yml`, `devcontainer.json` | Containers / dev containers |
| `*.bicep`, `azuredeploy.json` | Azure IaC |
| `azure-pipelines*.yml`, `.azuredevops/`, `.github/workflows/`, `.gitlab-ci.yml`, `bitbucket-pipelines.yml` | CI system, stages, quality gates |
| `Makefile`, `Taskfile.yml`, `justfile`, `scripts/`, `tools/` | Canonical commands. Prefer these over raw tool commands. |
| `.pre-commit-config.yaml`, `.editorconfig`, linter configs (`.eslintrc*`, `ruff.toml`, `.golangci.yml`...) | Enforced style. Don't restate what a linter already enforces. |
| `*.iss`, `*.wxs`, `*.nsi`, `electron-builder.*`, `tauri.conf.json` | Desktop app packaging: offer `docs/releasing.md` |
| `README*`, `CONTRIBUTING*`, `docs/`, `docs/adr/`, `CODEOWNERS` | Purpose, workflow, ownership, decisions |

## Unknown stack fallback

When nothing above matches, or a stack is only partly covered:

1. List the root and depth-2 files. Look for the build manifest (any file the build tool reads), lockfiles, and task runner files.
2. Read the CI config. Its steps are the most reliable source of the real build, test and lint commands.
3. Read README and CONTRIBUTING "getting started" sections.
4. Write what you found with its evidence, and mark every inferred command `TODO(verify)`.
5. Ask the user to confirm the commands in Phase 3. Never invent a command because it's typical for the language.
