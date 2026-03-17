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
    TowerConfig.luau             # Tower definitions
    EnemyConfig.luau             # Enemy definitions
    WaveConfig.luau              # Wave composition
    MapData.luau                 # Static map with waypoints
    GameMath.luau                # Pure headless game logic
    GameMath.spec.luau           # TestEZ tests for GameMath
    Adapter.luau                 # Roblox boundary bridge (Position ↔ Vector3)
  .luaurc                        # Luau strict mode + path aliases
scripts/
  analyze.sh                     # Type-checking via luau-lsp
  install-packages.sh            # Wally package installation
.github/workflows/
  ci.yml                         # Lint, format, analyze, build pipeline
  deploy.yml                     # Roblox deployment (currently disabled)
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
- **Linter:** Selene with `roblox` standard library

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
- `selene.toml` - Linter configuration (`std = "roblox"`)
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

## Generated / Ignored Files

These are generated and should not be committed:
- `sourcemap.json` - Rojo sourcemap
- `*.rbxl` / `*.rbxlx` - Built place files
- `Packages/` / `DevPackages/` / `ServerPackages/` - Wally dependencies
- `globalTypes.d.lua` - Roblox type definitions (downloaded by analyze.sh)
