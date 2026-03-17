-- Static map definition with waypoints forming an S-curve path.
-- Uses plain Position tables (not Vector3) — this is the headless layer.
-- The runtime Adapter converts these to Vector3 when creating actual Parts.
--
-- When a real map is built in Roblox Studio, the runtime can read waypoint
-- positions from Parts instead. But this hardcoded data lets us reason about
-- the full game scenario without Studio: "A Grunt spawns at waypoint 1,
-- walks this S-curve at 10 studs/sec, while an Archer tower deals 10 DPS
-- from 25 studs away."

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)

local MapData: Types.MapConfig = {
	name = "Starter Meadow",
	waypoints = {
		{ position = { x = 0, y = 5, z = -100 }, order = 1 },
		{ position = { x = 40, y = 5, z = -60 }, order = 2 },
		{ position = { x = -40, y = 5, z = -20 }, order = 3 },
		{ position = { x = 40, y = 5, z = 20 }, order = 4 },
		{ position = { x = -40, y = 5, z = 60 }, order = 5 },
		{ position = { x = 0, y = 5, z = 100 }, order = 6 },
	},
}

return MapData
