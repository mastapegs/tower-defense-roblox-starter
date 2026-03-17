# CLAUDE.md - Tower Defense Roblox Starter

## Project Overview

Roblox tower defense game starter template using Luau with a modern toolchain (Rojo, Wally, StyLua, Selene, luau-lsp). Currently a minimal boilerplate ready for game system development.

## Repository Structure

```
src/
  Client/init.client.luau    # Client entrypoint (StarterPlayerScripts)
  Server/init.server.luau    # Server entrypoint (ServerScriptService)
  Shared/                    # Shared modules (ReplicatedStorage)
  .luaurc                    # Luau strict mode + path aliases
scripts/
  analyze.sh                 # Type-checking via luau-lsp
  install-packages.sh        # Wally package installation
.github/workflows/
  ci.yml                     # Lint, format, analyze, build pipeline
  deploy.yml                 # Roblox deployment (currently disabled)
```

### Rojo Project Mapping (`default.project.json`)

| Directory    | Roblox Location              |
|-------------|------------------------------|
| src/Client  | StarterPlayer.StarterPlayerScripts |
| src/Server  | ServerScriptService          |
| src/Shared  | ReplicatedStorage.Shared     |
| Packages/   | ReplicatedStorage.Packages   |

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

- **PascalCase** for modules and class-like tables (e.g., `Hello`)
- **camelCase** for functions and variables (e.g., `greet`, `caller`)
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
- `wally.toml` - Package dependencies (currently none)
- `stylua.toml` - Formatter configuration
- `selene.toml` - Linter configuration (`std = "roblox"`)
- `src/.luaurc` - Luau language settings and path aliases

## Generated / Ignored Files

These are generated and should not be committed:
- `sourcemap.json` - Rojo sourcemap
- `*.rbxl` / `*.rbxlx` - Built place files
- `Packages/` / `ServerPackages/` - Wally dependencies
- `globalTypes.d.lua` - Roblox type definitions (downloaded by analyze.sh)
