-- Server entrypoint
-- Runs in ServerScriptService as a Script

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local EnemyConfig = require(Shared:WaitForChild("EnemyConfig"))
local GameConfig = require(Shared:WaitForChild("GameConfig"))
local GameMath = require(Shared:WaitForChild("GameMath"))
local MapData = require(Shared:WaitForChild("MapData"))
local TowerConfig = require(Shared:WaitForChild("TowerConfig"))
local WaveConfig = require(Shared:WaitForChild("WaveConfig"))

print("[Server] Tower Defense server starting")
print(string.format("[Server] Map: %s (%d waypoints)", MapData.name, #MapData.waypoints))
print(
	string.format(
		"[Server] Starting currency: %d | Starting lives: %d",
		GameConfig.startingCurrency,
		GameConfig.startingLives
	)
)
print(string.format("[Server] Path length: %.1f studs", GameMath.pathLength(MapData.waypoints)))

for towerName, tower in TowerConfig do
	print(
		string.format(
			"[Server]   Tower '%s': %d dmg, %.1f range, %.1f DPS, %d cost",
			towerName,
			tower.damage,
			tower.range,
			GameMath.damagePerSecond(tower),
			tower.cost
		)
	)
end

for enemyName, enemy in EnemyConfig do
	local traverseTime = GameMath.timeToTraversePath(MapData.waypoints, enemy.speed)
	print(
		string.format(
			"[Server]   Enemy '%s': %d hp, %d speed, %.1fs to traverse, %d reward",
			enemyName,
			enemy.health,
			enemy.speed,
			traverseTime,
			enemy.reward
		)
	)
end

print(string.format("[Server] Waves defined: %d", #WaveConfig))
for i, wave in WaveConfig do
	local totalHealth = GameMath.waveTotalHealth(wave, EnemyConfig)
	local totalReward = GameMath.waveTotalReward(wave, EnemyConfig)
	print(string.format("[Server]   Wave %d: %d total HP, %d total reward", i, totalHealth, totalReward))
end
