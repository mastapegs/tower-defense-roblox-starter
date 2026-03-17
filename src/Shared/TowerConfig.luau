-- Tower type definitions.
-- Each tower is keyed by a string identifier. The key matches the name field
-- by convention, making lookups and debugging straightforward.
--
-- Two towers show enough variety to demonstrate the pattern:
-- Archer is fast, cheap, and low-damage. Cannon is slow, expensive, and heavy-hitting.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)

local TowerConfig: { [string]: Types.TowerConfig } = {
	Archer = {
		name = "Archer",
		damage = 10,
		range = 25,
		fireRate = 1.0,
		cost = 50,
	},
	Cannon = {
		name = "Cannon",
		damage = 40,
		range = 15,
		fireRate = 0.4,
		cost = 100,
	},
}

return TowerConfig
