-- Central type definitions for the headless game logic layer
-- These types have zero Roblox dependency — pure Luau data shapes.
-- The runtime layer uses Adapter to convert Position ↔ Vector3.

local Types = {}

-- A plain position table, independent of Roblox's Vector3.
-- The Adapter module bridges this to Vector3 at the runtime boundary.
export type Position = {
	x: number,
	y: number,
	z: number,
}

export type TowerConfig = {
	name: string,
	damage: number,
	range: number,
	fireRate: number, -- shots per second
	cost: number,
}

export type EnemyConfig = {
	name: string,
	health: number,
	speed: number, -- studs per second
	reward: number, -- currency earned on kill
}

export type WaveEntry = {
	enemyType: string, -- key into EnemyConfig (decoupled, like a foreign key)
	count: number,
	spawnInterval: number, -- seconds between spawns
}

export type WaveConfig = {
	entries: { WaveEntry },
	preparationTime: number, -- seconds before wave starts
}

export type Waypoint = {
	position: Position,
	order: number,
}

export type MapConfig = {
	name: string,
	waypoints: { Waypoint },
}

return Types
