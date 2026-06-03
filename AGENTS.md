# AI Agent Instructions for CPI_Trial

## Project type
- Multi-module Gradle project with a custom SAP CPI-style integration flow structure.
- Root build scripts are `build.gradle` and `settings-irt.gradle`.
- There is no Gradle wrapper present in the repository, so use the installed Gradle CLI if needed.

## Key modules and conventions
- `common/` contains shared Groovy code and is configured as a dependency for CPI modules.
- `TestSample/`, `TestSample2/`, and `TestSample3/` contain CPI integration flow modules.
- Module names follow CPI artifact prefixes:
  - `iflow-` → CPI integration flow modules
  - `vm-` → value mapping modules
  - `sc-` → script collection modules
  - `mm-` → message mapping modules
  - `fl-` → function libraries

## Gradle import and build guidance
- Import the project at the repository root as a Gradle project.
- Use `build.gradle` and `settings-irt.gradle` together to understand module inclusion and dependency wiring.
- Key build behavior is in `build.gradle`:
  - applies `idea` and `groovy` plugins to subprojects
  - configures `mavenLocal()` and `mavenCentral()` repositories
  - adds `common` and resource JAR dependencies to CPI test modules
  - adjusts test source sets for CPI `IFLOW` modules to include `src/test/groovy` and `src/main/resources/script`
- `IFLOW` test modules depend on `:common:test` and use JUnit Platform.

## What to avoid
- Do not assume a standard Java package layout in CPI modules; many modules are metadata-driven with resources under `src/main/resources`.
- Don’t add a Gradle wrapper file unless the user requests it explicitly.

## Useful files and locations
- `build.gradle` — shared project configuration and CPI module build behavior
- `settings-irt.gradle` — multi-module project graph
- `common/` — shared Groovy code and tests
- `TestSample*/` — CPI sample module directories and metadata

## How agents should use this file
- When asked to make changes, base Gradle operations on the root project files and preserve the CPI-specific test source set and module prefix conventions.
- For Java import issues, point out that this repository is not a plain Java application but a Gradle-based CPI module repository.
- Verify that any new code or module change keeps the existing `iflow-`, `vm-`, `sc-`, `mm-`, and `fl-` naming conventions.
