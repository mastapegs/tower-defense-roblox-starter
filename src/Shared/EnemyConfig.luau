-- Enemy type definitions.
-- The classic tower defense triad: normal, fast, and tanky.
-- Each enemy is keyed by a string identifier that WaveConfig references.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)

local EnemyConfig: { [string]: Types.EnemyConfig } = {
	Grunt = {
		name = "Grunt",
		health = 50,
		speed = 10,
		reward = 5,
	},
	Speeder = {
		name = "Speeder",
		health = 25,
		speed = 20,
		reward = 8,
	},
	Tank = {
		name = "Tank",
		health = 200,
		speed = 5,
		reward = 20,
	},
}

return EnemyConfig
