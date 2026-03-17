# Research: Roblox Project Structure Comparison

## Context

This repo is 3 hours old and contains a tower defense game starter built with a headless architecture. The goal is to compare it against how popular/professional Roblox experiences organize their GitHub repos, identifying strengths and gaps.

---

## How Popular Roblox Projects Are Organized

Professional Roblox projects on GitHub (Knit-based games, Flamework projects, open-source tower defenses like Zycostan/TD-OpenSourced, templates like MonzterDev/Roblox-Game-Template) consistently share these structural elements:

### Directory Layout
```
src/
  Client/           # Controllers, UI, input, camera
    Controllers/    # Per-feature client controllers (ShopController, PlacementController)
    UI/             # ScreenGui components, HUD elements
  Server/           # Services, data persistence, game orchestration
    Services/       # Per-feature services (CombatService, WaveService, DataService)
  Shared/           # Pure logic, types, configs, utilities
    Types.luau
    Configs/
    Util/
Packages/           # Wally runtime deps
DevPackages/        # Wally dev deps (TestEZ)
assets/             # Roblox model files (.rbxm), optional
```

### Frameworks & Patterns
| Pattern | Adoption | What It Does |
|---------|----------|-------------|
| **Knit** (Sleitnick) | Most popular | Service/Controller framework — auto-wires RemoteEvents, lifecycle hooks |
| **Matter ECS** | Growing | Entity-Component-System — ideal for TD games with many entities |
| **Flamework** | TypeScript teams | Decorator-based DI, compile-time networking |
| **ProfileService** | Near-universal | Player data persistence and session locking |

### What Professional Repos Include
1. **Service/Controller architecture** — Server Services own game state; Client Controllers handle UI/input
2. **Networking abstraction** — Frameworks handle RemoteEvent creation/routing (not manual)
3. **State management** — Centralized game state (wave number, player currency, enemy HP pools)
4. **Manager modules** — EnemyManager, TowerManager, WaveManager, CombatManager
5. **UI system** — Organized ScreenGuis, shop interfaces, HUD components
6. **Player data** — ProfileService or DataStoreService wrappers for persistence
7. **Asset management** — Model references, prefab systems for towers/enemies
8. **Input handling** — Tower placement, drag-and-drop, click detection
9. **Testing** — TestEZ specs for headless logic (same pattern you use)
10. **CI pipeline** — Lint, format, type-check, build (same pattern you use)

---

## Your Repo: What Exists Today (3 Hours In)

### Files: 12 source files
- **Headless layer (complete):** Types.luau, GameMath.luau (8 functions), GameConfig, TowerConfig (2 towers), EnemyConfig (3 enemies), WaveConfig (3 waves), MapData (6 waypoints)
- **Boundary layer (complete):** Adapter.luau (Position ↔ Vector3)
- **Runtime layer (stubs):** Server/init.server.luau (prints diagnostics), Client/init.client.luau (prints startup info)
- **Testing (complete):** GameMath.spec.luau (44+ test cases), TestRunner.server.luau
- **Toolchain & CI (complete):** aftman.toml (7 tools pinned), wally.toml, stylua.toml, selene.toml, .luaurc, ci.yml (4-gate pipeline)

---

## Strengths (What You Do Well)

### 1. Headless Architecture — Ahead of Most Projects
Most open-source Roblox repos mix game logic directly with Roblox APIs. Your strict separation of `Position` (plain table) from `Vector3` (Roblox type) is rare and genuinely professional. The Adapter pattern is textbook clean architecture. **This is your biggest differentiator.**

### 2. Type-Driven Design — Exemplary
Defining all shapes in `Types.luau` first, then constraining every module with those types in strict mode, is exactly what professional teams do — but many open-source repos skip it. You're doing this from day one.

### 3. Test Coverage — Unusually Strong for Roblox
44+ test cases covering all 8 GameMath functions, including edge cases (zero DPS, empty waypoints, unknown enemy keys). Most Roblox repos on GitHub have zero tests. Your test-first approach is a genuine strength.

### 4. CI Pipeline — Production-Grade
4-gate CI (lint → format → type-check → build) with artifact output. Many published Roblox games don't have this. Your pipeline matches what professional studios use.

### 5. Toolchain Configuration — Complete and Correct
Every tool pinned to a specific version. StyLua, Selene, luau-lsp all properly configured. Path aliases in .luaurc. VS Code settings for the team. This is textbook.

### 6. Foreign Key Pattern in WaveConfig
Referencing enemies by string key instead of direct import is a sophisticated decoupling pattern. It mirrors database design and makes wave balancing independent of enemy definitions.

### 7. Documentation (CLAUDE.md)
Comprehensive project documentation that explains architecture decisions, not just file locations. The "why" behind the headless boundary is clearly articulated.

---

## Weaknesses / Gaps (What's Missing)

### 1. No Game Systems / Managers (Critical Gap)
**What pros have:** EnemyManager (spawning, movement along path), TowerManager (placement, targeting), WaveManager (progression, timing), CombatManager (damage application, health tracking).
**What you have:** Data definitions only. No runtime behavior yet.
**Impact:** This is expected at 3 hours — the data layer is the right thing to build first. But this is the largest body of work ahead.

### 2. No Service/Controller Framework
**What pros have:** Knit Services (server) and Controllers (client) with lifecycle hooks (KnitInit, KnitStart) and automatic networking.
**What you have:** Flat init scripts that print diagnostics.
**Impact:** As you add features, you'll need a pattern for organizing server-side services and client-side controllers. You don't necessarily need Knit — a simple module-based service pattern works too — but you need *something* before adding multiple features.

### 3. No Networking / RemoteEvents
**What pros have:** Organized remote communication for tower placement requests, wave start signals, currency updates, enemy state replication.
**What you have:** Nothing yet.
**Impact:** TD games are inherently client-server. The client needs to request tower placements; the server needs to broadcast enemy positions. This is a fundamental system you'll need soon.

### 4. No UI System
**What pros have:** Shop UI (tower selection + cost display), HUD (lives, currency, wave counter), health bars over enemies, tower range indicators.
**What you have:** Nothing yet.
**Impact:** UI is what makes the game playable. This is a large chunk of work but can be built incrementally.

### 5. No Player Data / Persistence
**What pros have:** ProfileService or DataStore wrappers for saving player progress, currency, unlocks.
**What you have:** GameConfig defines startingCurrency/startingLives as constants.
**Impact:** Low priority for now — you can play sessions without persistence. But eventually needed.

### 6. No Asset/Prefab System
**What pros have:** Tower models, enemy models, map parts referenced by configuration.
**What you have:** Pure data (positions as numbers, no model references).
**Impact:** You'll need to bridge your headless configs to actual Roblox Instances (Parts, Models) in Studio. The Adapter module is a start, but you'll need a broader asset reference system.

### 7. No Game State Machine
**What pros have:** Explicit state management — Lobby → Preparation → Combat → Wave Complete → Victory/Defeat.
**What you have:** No state tracking.
**Impact:** Wave progression, win/loss conditions, and preparation phases all need a state machine to coordinate.

### 8. Single Map, No Map Loading System
**What pros have:** Multiple maps, map selection, waypoints read from workspace Parts.
**What you have:** One hardcoded map ("Starter Meadow") with waypoints as plain data.
**Impact:** Fine for now, but the MapData module should eventually read waypoints from the actual workspace rather than hardcoded positions.

---

## Summary Scorecard

| Area | Your Repo | Industry Standard | Grade |
|------|-----------|-------------------|-------|
| Project structure (dirs) | Client/Server/Shared | Same | A |
| Type system | Strict mode, Types.luau | Same or weaker | A+ |
| Headless architecture | Clean separation | Rare in practice | A+ |
| Testing | 44+ cases, edge coverage | Often 0 tests | A+ |
| CI/CD | 4-gate pipeline | Same | A |
| Toolchain | 7 tools, all pinned | Same | A |
| Documentation | Excellent CLAUDE.md | Usually minimal | A |
| Game logic (math) | 8 pure functions | Embedded in managers | A |
| Game systems (managers) | None yet | EnemyMgr, TowerMgr, WaveMgr, CombatMgr | F |
| Networking | None yet | Knit or manual remotes | F |
| UI | None yet | Shop, HUD, health bars | F |
| State management | None yet | Service state or ECS | F |
| Player data | Constants only | ProfileService | F |
| Asset system | No model refs | Prefab/model references | F |

**Bottom line:** Your foundation is stronger than 90% of open-source Roblox repos. The "F" grades are all expected — you're 3 hours in and built the hardest-to-retrofit parts first (types, tests, CI, architecture). Most projects start with the visual/fun parts and never get the engineering right. You did the opposite, which sets you up for sustainable growth.

---

## Recommended Next Steps (Priority Order)

1. **Game State module** — Simple state machine (Preparation → Combat → WaveComplete → Victory/Defeat)
2. **EnemyManager** — Spawn enemies, move along waypoints, track HP
3. **TowerManager** — Place towers, enforce placement rules
4. **CombatManager** — Targeting, damage application, enemy death
5. **WaveManager** — Orchestrate wave progression using WaveConfig
6. **Basic Networking** — RemoteEvents for tower placement + game state sync
7. **Basic UI** — Currency display, wave counter, simple tower shop

Each of these can follow your existing pattern: define types first, write headless logic, add tests, then wire to Roblox runtime through adapters.
