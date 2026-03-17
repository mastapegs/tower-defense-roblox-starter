-- Wave definitions: what spawns, when, and how fast.
-- Each wave references enemies by string key — decoupled from EnemyConfig,
-- like a foreign key in a database. The runtime system resolves the key.
--
-- Three waves show escalation: more enemies, new types, tighter intervals.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)

local WaveConfig: { Types.WaveConfig } = {
	{
		preparationTime = 5,
		entries = {
			{ enemyType = "Grunt", count = 5, spawnInterval = 1.5 },
		},
	},
	{
		preparationTime = 5,
		entries = {
			{ enemyType = "Grunt", count = 5, spawnInterval = 1.2 },
			{ enemyType = "Speeder", count = 2, spawnInterval = 1.0 },
		},
	},
	{
		preparationTime = 8,
		entries = {
			{ enemyType = "Grunt", count = 8, spawnInterval = 1.0 },
			{ enemyType = "Speeder", count = 4, spawnInterval = 0.8 },
			{ enemyType = "Tank", count = 1, spawnInterval = 2.0 },
		},
	},
}

return WaveConfig
