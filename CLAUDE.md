# CLAUDE.md - Tower Defense Roblox Starter

## Project Overview

Roblox tower defense game built in Luau with a modern toolchain (Rojo, Wally, StyLua, Selene, luau-lsp, TestEZ). Uses a **headless architecture** — pure game logic (types, math, configs) separated from the Roblox runtime, tested with TestEZ.

This is a father-and-son learning project — coding best practices first, game features second. Every iteration should be self-documenting and teach something about both game development and real software engineering.

## Tone & Documentation Guidelines

When updating `README.md` or other user-facing documentation, write with an **inviting, friendly tone that is also intellectual and approachable**. The voice should feel like a knowledgeable friend walking you through something — warm but never condescending, clear but never dumbed down. Explain *why* things work the way they do, not just *what* to do. This project is meant to be a learning journey, so documentation should teach as it guides.

When helping with code, keep suggestions approachable and well-explained. Favor clear, well-typed code over clever shortcuts.

## Repository Structure

```
src/
  Client/init.client.luau        # Client entrypoint (StarterPlayerScripts)
  Server/init.server.luau        # Server entrypoint (ServerScriptService)
  Server/TestRunner.server.luau  # TestEZ test runner
  Shared/                        # Headless logic layer (ReplicatedStorage)
    Types.luau                   # Central type definitions (no Roblox types)
    GameConfig.luau              # Game-wide constants
    TowerConfig.luau             # Tower definitions (Archer, Cannon)
    EnemyConfig.luau             # Enemy definitions (Grunt, Speeder, Tank)
    WaveConfig.luau              # Wave composition (3 waves, escalating difficulty)
    MapData.luau                 # Static map with S-curve path (6 waypoints)
    GameMath.luau                # Pure headless game logic (8 functions)
    GameMath.spec.luau           # TestEZ tests for GameMath (44+ test cases)
    Adapter.luau                 # Roblox boundary bridge (Position ↔ Vector3)
  .luaurc                        # Luau strict mode + path aliases
scripts/
  analyze.sh                     # Type-checking via luau-lsp
  install-packages.sh            # Wally package installation
.github/workflows/
  ci.yml                         # Lint, format, analyze, build pipeline
  deploy.yml                     # Roblox deployment (currently disabled)
.vscode/
  extensions.json                # Recommended extensions (luau-lsp, stylua, rojo)
  settings.json                  # Workspace settings (luau-lsp config, aliases)
testez.d.luau                    # TestEZ type stubs for strict mode
testez.yml                       # TestEZ standard library definition for selene
```

### Rojo Project Mapping (`default.project.json`)

| Directory    | Roblox Location              |
|-------------|------------------------------|
| src/Client     | StarterPlayer.StarterPlayerScripts |
| src/Server     | ServerScriptService          |
| src/Shared     | ReplicatedStorage.Shared     |
| Packages/      | ReplicatedStorage.Packages   |
| DevPackages/   | ServerStorage.DevPackages    |

## Build & Development Commands

```sh
# Install toolchain (Rojo, Wally, StyLua, Selene, luau-lsp)
aftman install

# Install Wally packages + generate types
sh scripts/install-packages.sh

# Lint
selene src/

# Format check (CI) / Format fix
stylua --check src/
stylua src/

# Type check
sh scripts/analyze.sh

# Build place file
rojo build default.project.json --output TowerDefense.rbxl
```

## CI Pipeline

The CI workflow (`.github/workflows/ci.yml`) runs on pushes/PRs to `main`:

1. **Lint** - `selene src/`
2. **Format check** - `stylua --check src/`
3. **Type check** - `sh scripts/analyze.sh`
4. **Build** - produces `TowerDefense.rbxl` artifact (requires all above to pass)

All four checks must pass before merging.

## Code Conventions

### Language & Style

- **Language:** Luau (Roblox's typed Lua variant), files use `.luau` extension
- **Type checking:** Strict mode (`"languageMode": "strict"` in `.luaurc`)
- **Formatter:** StyLua with these settings (`stylua.toml`):
  - Indentation: **tabs** (width 4)
  - Column width: 120
  - Line endings: Unix (LF)
  - Quotes: auto prefer double
  - Call parentheses: always required
  - Require sorting: enabled
- **Linter:** Selene with `testez` standard library (`selene.toml` sets `std = "testez"`, which extends `roblox` via `testez.yml` to include TestEZ globals)

### Naming

- **PascalCase** for modules and class-like tables (e.g., `GameMath`, `TowerConfig`)
- **camelCase** for functions and variables (e.g., `damagePerSecond`, `waveTotalHealth`)
- File names match their module name in PascalCase

### Module Pattern

Modules export a table and use type annotations:

```luau
local MyModule = {}

function MyModule.doSomething(param: string): number
	-- implementation
end

return MyModule
```

### Imports

- Use `game:GetService()` for Roblox services
- Access shared modules via `ReplicatedStorage.Shared`
- Wally packages via `ReplicatedStorage.Packages`

## Toolchain Versions (aftman.toml)

| Tool                 | Version |
|---------------------|---------|
| rojo                | 7.4.1   |
| wally               | 0.3.2   |
| stylua              | 0.20.0  |
| selene              | 0.27.1  |
| luau-lsp            | 1.63.0  |
| wally-package-types | 1.3.1   |

## Key Files

- `default.project.json` - Rojo project tree mapping src to Roblox instances
- `aftman.toml` - Toolchain version pins
- `wally.toml` - Package dependencies (TestEZ for testing)
- `stylua.toml` - Formatter configuration
- `selene.toml` - Linter configuration (`std = "testez"`, which extends `roblox`)
- `testez.yml` - Selene standard library definition for TestEZ globals (describe, it, expect, etc.)
- `testez.d.luau` - Type stubs for TestEZ globals (used by luau-lsp in strict mode)
- `src/.luaurc` - Luau language settings and path aliases

## Running CI Checks in Claude Code on the Web

The Roblox toolchain (aftman, rojo, wally, selene, luau-lsp) is **not pre-installed** in the Claude Code web environment. Here's what works and what doesn't:

### What works

- **StyLua** — Install and run via npx:
  ```sh
  npx --yes @johnnymorganz/stylua-bin src/          # format
  npx --yes @johnnymorganz/stylua-bin --check src/   # check only
  ```
  Always run this before committing. It handles tab indentation, require sorting, and line wrapping per `stylua.toml`.

- **Selene** — Download the Linux binary directly from GitHub releases:
  ```sh
  curl -L https://github.com/Kampfkarren/selene/releases/download/0.27.1/selene-0.27.1-linux.zip -o /tmp/selene.zip
  unzip -o /tmp/selene.zip -d /usr/local/bin/
  chmod +x /usr/local/bin/selene
  ```
  **Caveat:** `selene src/` requires a `roblox` standard library definition. It calls `selene generate-roblox-std` which fetches the Roblox API dump from GitHub. This **fails if external network access is restricted** (DNS resolution errors). When this happens, selene cannot run — rely on GitHub CI to catch lint issues. Do not let this block commits.

### What does NOT work

- **aftman install** — aftman is not available; tools must be installed individually as shown above
- **wally install / sh scripts/install-packages.sh** — Wally is not available and requires network access to the Wally registry
- **sh scripts/analyze.sh** (luau-lsp type checking) — luau-lsp is not available and the script also downloads `globalTypes.d.lua` from GitHub
- **rojo build** — Rojo is not available
- **TestEZ tests** — Tests run inside Roblox Studio, not from the command line

### Recommended workflow in this environment

1. **Always run StyLua** via npx before committing — this is the one CI check you can reliably run
2. **Attempt selene** with the binary download above — if network allows it, great; if not, note it in the commit and let GitHub CI handle it
3. **Trust the type system** — write code with full type annotations and follow existing patterns. The strict mode type checker will catch issues when CI runs on GitHub
4. **Follow existing module patterns** — look at how existing files are structured (imports, type annotations, module table pattern) and match them exactly. This minimizes CI surprises

### Headless architecture note

The headless logic layer (`Types.luau`, `GameMath.luau`, configs) uses **no Roblox-specific types** (no Vector3, no Instance, no game:GetService in logic functions). Only the Adapter module and the entrypoints/test runner use Roblox APIs. When adding new headless logic, keep this boundary clean — it's what makes the code testable and the architecture meaningful.

## Architecture Patterns

### Headless / Runtime Boundary

The codebase enforces a strict separation between pure game logic and Roblox runtime:

| Layer | Modules | Roblox APIs? | Testable? |
|-------|---------|-------------|-----------|
| **Headless** | Types, GameMath, GameConfig, TowerConfig, EnemyConfig, WaveConfig, MapData | No | Yes (TestEZ) |
| **Boundary** | Adapter (Position ↔ Vector3) | Yes (Vector3 only) | Limited |
| **Runtime** | Client/init, Server/init, TestRunner | Yes (full) | In-Studio only |

When adding new game logic, place it in the headless layer. Only reach for Roblox APIs in the boundary or runtime layers.

### Foreign Key Pattern

WaveConfig references enemies by string key (e.g., `"Grunt"`, `"Speeder"`) rather than importing EnemyConfig directly. This decouples wave composition from enemy definitions — like database foreign keys. Runtime resolves these keys via lookup at gameplay time.

### Type-Driven Design

All data shapes are defined in `Types.luau` first. Every config and logic module is constrained by these types. The strict mode type checker enforces contracts at build time. Key types:

- `Position` — `{ x: number, y: number, z: number }` (headless, not Vector3)
- `TowerConfig` — `{ name, damage, range, fireRate, cost }`
- `EnemyConfig` — `{ name, health, speed, reward }`
- `WaveEntry` — `{ enemyType (string key), count, spawnInterval }`
- `WaveConfig` — `{ entries[], preparationTime }`
- `Waypoint` — `{ position: Position, order: number }`
- `MapConfig` — `{ name, waypoints[] }`

### Current Game Data

**Towers:** Archer (10 dmg, 25 range, 1.0 rate, 50 cost) and Cannon (40 dmg, 15 range, 0.4 rate, 100 cost)
**Enemies:** Grunt (50 hp, 10 speed), Speeder (25 hp, 20 speed), Tank (200 hp, 5 speed)
**Waves:** 3 waves with escalating difficulty — Grunts only → Grunts + Speeders → all three types
**Map:** "Starter Meadow" with 6 waypoints forming an S-curve (~301.6 studs total)
**Economy:** 100 starting currency, 20 starting lives, max 25 towers

## Testing

- **Framework:** TestEZ v0.4.1 (installed via Wally as dev dependency)
- **Test discovery:** `TestRunner.server.luau` auto-discovers all `.spec.luau` modules in `ReplicatedStorage.Shared`
- **Test execution:** Tests run inside Roblox Studio on Play — check the Output window for results
- **Current coverage:** `GameMath.spec.luau` has 44+ test cases covering all 8 public functions including edge cases (zero values, boundary conditions, unknown keys)
- **Naming convention:** Test files use `<ModuleName>.spec.luau` pattern
- **TestEZ globals:** `describe`, `it`, `expect`, `FIXME`, `FOCUS`, `SKIP` — defined in `testez.yml` (selene) and `testez.d.luau` (type checker)

## Generated / Ignored Files

These are generated and should not be committed:
- `sourcemap.json` - Rojo sourcemap
- `*.rbxl` / `*.rbxlx` - Built place files
- `Packages/` / `ServerPackages/` - Wally dependencies (installed by `wally install`)
- `globalTypes.d.lua` - Roblox type definitions (downloaded by analyze.sh)
- `.claude/` - Claude Code session artifacts
