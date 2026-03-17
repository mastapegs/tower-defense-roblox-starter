# Tower Defense Roblox Starter

A father-and-son tower defense game, built from scratch in [Luau](https://luau-lang.org/) with a modern, professional toolchain. This is where it all begins — the very first Roblox experience we're building together.

The idea is simple: **coding best practices first, game features second.** If we're going to learn game development together, we might as well learn it the right way. This repo is designed to be self-documenting, so that every iteration teaches something — not just about tower defense, but about how real software gets built.

## Headless Game Logic

This project follows a **headless architecture** — the same pattern used in modern front-end development (think [Radix UI](https://www.radix-ui.com/) or [Headless UI](https://headlessui.com/)), but applied to game development.

The idea: separate the **brain** from the **body**.

- The **brain** (headless logic layer) knows what towers do, how much damage they deal, how fast enemies move, what a wave looks like. It's pure math and data — typed Luau functions that take data in and return data out. It has *zero knowledge* of Roblox Instances, Vector3, TweenService, or anything visual.

- The **body** (Roblox runtime layer) handles rendering, physics, input, and UI. It reads from the headless layer and translates pure data into the living game world.

- The **Adapter** sits at the boundary, converting between the two — like a Theme trait in a headless UI library. Today it converts `Position ↔ Vector3`. As the game grows, it'll bridge more headless types to their Roblox counterparts.

### Why headless?

**Testability.** When your game logic is pure functions with no engine dependency, you can test it with [TestEZ](https://github.com/Roblox/testez) — describe, it, expect — just like testing a React component's logic without mounting it to the DOM. "Does an Archer deal 10 DPS?" "Does a Grunt take 5 seconds to cross 50 studs?" These are math questions, and math doesn't need a game engine to answer.

**Portability of concepts.** The patterns here — type-driven design, pure logic separated from side effects, adapter boundaries — aren't Roblox-specific. They're the same ideas behind functional programming, clean architecture, and every well-structured codebase. Learning them here means understanding them everywhere.

**Fearless iteration.** When you can prove your game logic is correct before opening Studio, you can change tower stats, rebalance waves, or redesign the economy with confidence. The tests catch regressions. The types catch structural mistakes. You iterate faster because you're not debugging in a game engine — you're debugging math.

### Architecture

```
┌─────────────────────────────────────────────┐
│           Headless Logic Layer               │
│  (Pure Luau — no Roblox dependency)          │
│                                              │
│  Types ─── GameMath ─── Configs ─── MapData  │
│                                              │
│  ✓ Testable with TestEZ                      │
│  ✓ Pure functions, typed data in/out         │
│  ✓ Zero knowledge of Instances or rendering  │
└──────────────────┬──────────────────────────┘
                   │ Adapter (Position ↔ Vector3)
┌──────────────────▼──────────────────────────┐
│           Roblox Runtime Layer               │
│  (Server scripts, Client scripts)            │
│                                              │
│  EnemyManager ─ TowerManager ─ WaveManager   │
│  UI ─ Input ─ Effects ─ TweenService         │
│                                              │
│  Reads from headless layer                   │
│  Converts Position ↔ Vector3 at boundary     │
└─────────────────────────────────────────────┘
```

### Type-Driven Design

We define the *shape* of our data before writing any logic. The types **are** the specification:

```luau
export type TowerConfig = {
    name: string,
    damage: number,
    range: number,
    fireRate: number,
    cost: number,
}
```

Once this type exists, every module that touches tower data is constrained by it. The type checker enforces the contract at build time — no runtime surprises, no "undefined is not a function" moments. If a field is missing or the wrong type, the build fails. This is the power of Luau's strict mode.

Types also tell a story. Reading `Types.luau` gives you a complete picture of the game's data model without reading any logic code. It's documentation that the compiler verifies.

## What's in the Box

```
src/
├── Client/                  → Code that runs on each player's machine
│   └── init.client.luau
├── Server/                  → Code that runs on the Roblox server
│   ├── init.server.luau
│   └── TestRunner.server.luau
├── Shared/                  → Headless logic + config (both sides can use)
│   ├── Types.luau           → Central type definitions (the contract)
│   ├── GameConfig.luau      → Game-wide constants
│   ├── TowerConfig.luau     → Tower type definitions
│   ├── EnemyConfig.luau     → Enemy type definitions
│   ├── WaveConfig.luau      → Wave composition
│   ├── MapData.luau         → Static map with waypoints
│   ├── GameMath.luau        → Pure headless game logic
│   ├── GameMath.spec.luau   → TestEZ tests for GameMath
│   └── Adapter.luau         → Roblox boundary bridge
└── .luaurc                  → Luau strict mode + path aliases

scripts/                     → Build and analysis helper scripts
.github/workflows/           → CI pipeline (lint, format, type-check, build)
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

The client deliberately requires only what it needs from Shared — tower configs for the shop UI, map data for display, game constants. It does *not* require wave composition or enemy details, because those are the server's responsibility. This isn't just organization — it's a security and architecture principle.

### Server (`src/Server/`)

Server code runs **once, on the Roblox server**. This is the single source of truth for your game. The server handles:

- Game logic that must be authoritative (enemy health, damage calculations, wave progression)
- Spawning and managing enemies along paths
- Validating tower placements and purchases (so players can't cheat)
- Managing game state (current wave, money, lives remaining)
- Storing and loading player data

Server scripts become **Scripts** and run in `ServerScriptService`. There's only one server, and it's the boss.

### Shared (`src/Shared/`)

Shared modules live in `ReplicatedStorage`, which means **both Client and Server can require them**. In our headless architecture, this is where the entire logic layer lives:

- **Type definitions** (`Types.luau`) — the contract that all game data follows
- **Configuration tables** — tower stats, enemy stats, wave definitions, map data
- **Pure logic** (`GameMath.luau`) — calculations that don't depend on the Roblox engine
- **Tests** (`*.spec.luau`) — proving the logic is correct
- **Adapter** — the boundary bridge to Roblox types

The golden rule: if both sides need it, put it in Shared. If only one side needs it, keep it on that side.

## How It All Connects

Rojo maps your local files into the Roblox engine like this:

| Your Files      | Roblox Location                        | What It Means                     |
|----------------|----------------------------------------|-----------------------------------|
| `src/Client`   | `StarterPlayer.StarterPlayerScripts`   | Runs on every player's device     |
| `src/Server`   | `ServerScriptService`                  | Runs once on the server           |
| `src/Shared`   | `ReplicatedStorage.Shared`             | Available to both sides           |
| `Packages/`    | `ReplicatedStorage.Packages`           | Third-party libraries (via Wally) |
| `DevPackages/` | `ServerStorage.DevPackages`            | Dev-only packages (TestEZ)        |

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

### Running Tests

Tests use [TestEZ](https://github.com/Roblox/testez) and run inside Roblox Studio:

1. Sync the project with `rojo serve`
2. Open the place in Roblox Studio
3. Play the game — `TestRunner.server.luau` auto-discovers and runs all `.spec` modules
4. Check the Output window for test results

Because the headless logic has no Roblox dependency, the tests exercise pure math — no Instances, no waiting for things to load, no flaky timing issues.

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
- **PascalCase** for modules and files (`TowerConfig.luau`, `GameMath.luau`)
- **camelCase** for functions and variables (`damagePerSecond`, `waveTotalHealth`)
- Every module exports a table with typed functions:

```luau
local GameMath = {}

function GameMath.damagePerSecond(tower: Types.TowerConfig): number
    return tower.damage * tower.fireRate
end

return GameMath
```

## Next Steps: Building the Game

Here's the roadmap for turning this foundation into an actual tower defense game. Each step builds on the last — take them one at a time.

### 1. Design Your Map

Start in Roblox Studio. Build a simple map with a path for enemies to walk along. Use Parts or a MeshPart to lay out waypoints. This is the creative part — no code needed yet, just blocks and imagination. The hardcoded waypoints in `MapData.luau` define the intended S-curve shape; your Studio map should match it.

### 2. Enemy Pathfinding (Server)

Write a server module that spawns enemies and moves them along waypoints. This is your first real runtime system — the first piece of the "body" that reads from the headless "brain":

- Create an `EnemyManager` in `src/Server/` that spawns enemy models
- Use `Adapter.toVector3()` to convert waypoint positions into the game world
- Move enemies from waypoint to waypoint using `TweenService` or stepping
- Track enemy health and remove them when defeated (or when they reach the end)

### 3. Tower Placement (Client + Server)

This is where Client and Server work together:

- **Client:** Show a placement preview that follows the mouse, handle click-to-place input
- **Server:** Validate the placement (can the player afford it? is the spot valid?), then create the tower
- Use `RemoteEvents` or `RemoteFunctions` to communicate between them

### 4. Tower Targeting and Attacking (Server)

Give your towers the ability to fight back:

- Each tower scans for enemies within its range — use `GameMath.isInRange()` for the headless check
- Pick a target (closest? lowest health? first in line?) and fire
- Apply damage to the enemy, check if it's defeated, award currency

### 5. Wave System (Server)

Orchestrate the chaos:

- Read from your `WaveConfig` to know what to spawn and when
- Track when all enemies in a wave are cleared
- Trigger the next wave (automatically or on player input)
- Increase difficulty as waves progress

### 6. Player Economy and UI (Client + Shared)

- Track currency (earned from defeating enemies)
- Build a shop UI for purchasing and upgrading towers
- Display wave number, lives remaining, and current money
- Show tower range indicators and upgrade paths

### 7. Polish and Expand

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
| TestEZ      | 0.4.1   | Testing framework (via Wally)        |

## License

This is a personal project — a learning journey. Feel free to use it as a starting point for your own Roblox tower defense.
