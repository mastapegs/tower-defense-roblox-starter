# Tower Defense Roblox Starter

A father-and-son tower defense game, built from scratch in [Luau](https://luau-lang.org/) with a modern, professional toolchain. This is where it all begins — the very first commit of our very first Roblox experience.

Right now this repo is the absolute minimum boilerplate: a clean foundation with proper linting, formatting, type-checking, and CI already wired up. The game itself? That's the adventure ahead. Every system we build — towers, enemies, waves, maps — will grow from here, one commit at a time.

The idea is simple: **coding best practices first, game features second.** If we're going to learn game development together, we might as well learn it the right way. This repo is designed to be self-documenting, so that every iteration teaches something — not just about tower defense, but about how real software gets built.

## What's in the Box

```
src/
├── Client/             → Code that runs on each player's machine
│   └── init.client.luau
├── Server/             → Code that runs on the Roblox server
│   └── init.server.luau
├── Shared/             → Code that both Client and Server can use
│   └── Hello.luau
└── .luaurc             → Luau strict mode + path aliases

scripts/                → Build and analysis helper scripts
.github/workflows/      → CI pipeline (lint, format, type-check, build)
```

## Understanding Client vs. Server vs. Shared

Roblox games are split across two execution environments, and understanding this split is one of the most important concepts in Roblox development.

### Client (`src/Client/`)

Client code runs **on each player's device**. This is where you handle everything the player directly sees and interacts with:

- Camera controls and UI (health bars, tower placement previews, shop menus)
- User input (mouse clicks to place towers, keyboard shortcuts)
- Visual effects and animations (tower firing effects, enemy death animations)
- Anything that needs to feel instant and responsive

Client scripts become **LocalScripts** and land in `StarterPlayer.StarterPlayerScripts` inside Roblox. Every player gets their own copy.

### Server (`src/Server/`)

Server code runs **once, on the Roblox server**. This is the single source of truth for your game. The server handles:

- Game logic that must be authoritative (enemy health, damage calculations, wave progression)
- Spawning and managing enemies along paths
- Validating tower placements and purchases (so players can't cheat)
- Managing game state (current wave, money, lives remaining)
- Storing and loading player data

Server scripts become **Scripts** and run in `ServerScriptService`. There's only one server, and it's the boss.

### Shared (`src/Shared/`)

Shared modules live in `ReplicatedStorage`, which means **both Client and Server can require them**. This is the perfect home for:

- Configuration tables (tower stats, enemy stats, wave definitions)
- Utility functions used on both sides
- Type definitions and interfaces
- Constants (prices, damage values, map data)

The golden rule: if both sides need it, put it in Shared. If only one side needs it, keep it on that side.

## How It All Connects

Rojo maps your local files into the Roblox engine like this:

| Your Files      | Roblox Location                        | What It Means                     |
|----------------|----------------------------------------|-----------------------------------|
| `src/Client`   | `StarterPlayer.StarterPlayerScripts`   | Runs on every player's device     |
| `src/Server`   | `ServerScriptService`                  | Runs once on the server           |
| `src/Shared`   | `ReplicatedStorage.Shared`             | Available to both sides           |
| `Packages/`    | `ReplicatedStorage.Packages`           | Third-party libraries (via Wally) |

You write code locally in your editor, Rojo syncs it into Roblox Studio, and everything ends up in the right place. No copy-pasting scripts inside Studio.

## Getting Started

### Prerequisites

Install [Aftman](https://github.com/LPGhatguy/aftman), a toolchain manager for Roblox development. Then:

```sh
# Install all development tools (Rojo, Wally, StyLua, Selene, luau-lsp)
aftman install

# Install packages and generate type definitions
sh scripts/install-packages.sh
```

### Development Workflow

```sh
# Format your code
stylua src/

# Lint for issues
selene src/

# Type-check everything
sh scripts/analyze.sh

# Build a place file
rojo build default.project.json --output TowerDefense.rbxl
```

Or just push to `main` — the CI pipeline runs all four checks automatically and produces a build artifact.

### Recommended Editor Setup

Open this project in VS Code. The repo includes workspace settings and extension recommendations for:

- **Luau LSP** — autocomplete, type-checking, and diagnostics right in your editor
- **StyLua** — format on save so you never think about formatting
- **Rojo** — live sync between your editor and Roblox Studio

## CI Pipeline

Every push and pull request to `main` runs through four gates:

1. **Lint** — Selene checks for common mistakes and code smells
2. **Format** — StyLua verifies consistent code style
3. **Type Check** — luau-lsp enforces strict typing across the entire `src/` tree
4. **Build** — Rojo produces a `TowerDefense.rbxl` artifact (only if the first three pass)

All four must pass before merging. This keeps the codebase clean from day one — a habit worth building early.

## Code Conventions

- **Luau** with strict type-checking enabled (`.luaurc`)
- **Tabs** for indentation, 120-character line width
- **PascalCase** for modules and files (`TowerManager.luau`)
- **camelCase** for functions and variables (`spawnEnemy`, `towerData`)
- Every module exports a table with typed functions:

```luau
local TowerManager = {}

function TowerManager.placeTower(position: Vector3, towerType: string): boolean
    -- implementation
end

return TowerManager
```

## Next Steps: Building the Game

Here's a rough roadmap for turning this boilerplate into an actual tower defense game. Each step builds on the last — take them one at a time.

### 1. Design Your Map

Start in Roblox Studio. Build a simple map with a path for enemies to walk along. Use Parts or a MeshPart to lay out waypoints. This is the creative part — no code needed yet, just blocks and imagination.

### 2. Define Your Data (Shared)

Before writing game logic, define what things *are*. Create config modules in `src/Shared/`:

- **`TowerConfig.luau`** — Tower types, damage, range, fire rate, cost
- **`EnemyConfig.luau`** — Enemy types, health, speed, reward
- **`WaveConfig.luau`** — What spawns on each wave, delays between spawns

Starting with data keeps your game logic clean and makes balancing easy later.

### 3. Enemy Pathfinding (Server)

Write a server module that spawns enemies and moves them along waypoints. This is your first real game system:

- Create an `EnemyManager` in `src/Server/` that spawns enemy models
- Move enemies from waypoint to waypoint using `TweenService` or stepping
- Track enemy health and remove them when defeated (or when they reach the end)

### 4. Tower Placement (Client + Server)

This is where Client and Server work together:

- **Client:** Show a placement preview that follows the mouse, handle click-to-place input
- **Server:** Validate the placement (can the player afford it? is the spot valid?), then create the tower
- Use `RemoteEvents` or `RemoteFunctions` to communicate between them

### 5. Tower Targeting and Attacking (Server)

Give your towers the ability to fight back:

- Each tower scans for enemies within its range
- Pick a target (closest? lowest health? first in line?) and fire
- Apply damage to the enemy, check if it's defeated, award currency

### 6. Wave System (Server)

Orchestrate the chaos:

- Read from your `WaveConfig` to know what to spawn and when
- Track when all enemies in a wave are cleared
- Trigger the next wave (automatically or on player input)
- Increase difficulty as waves progress

### 7. Player Economy and UI (Client + Shared)

- Track currency (earned from defeating enemies)
- Build a shop UI for purchasing and upgrading towers
- Display wave number, lives remaining, and current money
- Show tower range indicators and upgrade paths

### 8. Polish and Expand

Once the core loop works, the sky's the limit:

- Tower upgrades and specializations
- Multiple maps with different path layouts
- Boss enemies with special abilities
- Sound effects and particle systems
- Leaderboards and player progression
- Multiplayer co-op support

## Toolchain

| Tool        | Version | Purpose                              |
|-------------|---------|--------------------------------------|
| Rojo        | 7.4.1   | Syncs local files into Roblox Studio |
| Wally       | 0.3.2   | Package manager for Luau libraries   |
| StyLua      | 0.20.0  | Code formatter                       |
| Selene      | 0.27.1  | Linter                               |
| luau-lsp    | 1.63.0  | Language server and type checker     |

## License

This is a personal project — a learning journey. Feel free to use it as a starting point for your own Roblox tower defense.
