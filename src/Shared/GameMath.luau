-- Pure headless game logic — the "brain without a body."
--
-- Every function here takes typed data in and returns typed data out.
-- No Roblox services, no Instances, no Vector3. Just math.
-- This is the equivalent of headless UI components: all the behavior
-- and none of the rendering.
--
-- Because these functions are pure, they're fully testable with TestEZ
-- without ever opening Roblox Studio.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)

local GameMath = {}

-- How much damage a tower deals per second.
-- A tower that does 10 damage at 2 shots/sec = 20 DPS.
function GameMath.damagePerSecond(tower: Types.TowerConfig): number
	return tower.damage * tower.fireRate
end

-- How many seconds it takes a single tower to kill a single enemy.
-- Assumes the enemy is always in range (pure math, no spatial logic).
function GameMath.timeToKill(tower: Types.TowerConfig, enemy: Types.EnemyConfig): number
	local dps = GameMath.damagePerSecond(tower)
	if dps <= 0 then
		return math.huge
	end
	return enemy.health / dps
end

-- Euclidean distance between two positions.
function GameMath.distanceBetween(a: Types.Position, b: Types.Position): number
	local dx = b.x - a.x
	local dy = b.y - a.y
	local dz = b.z - a.z
	return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Whether a target position is within a tower's range.
function GameMath.isInRange(towerPos: Types.Position, targetPos: Types.Position, range: number): boolean
	return GameMath.distanceBetween(towerPos, targetPos) <= range
end

-- Total length of a path defined by ordered waypoints.
function GameMath.pathLength(waypoints: { Types.Waypoint }): number
	local total = 0
	for i = 2, #waypoints do
		total += GameMath.distanceBetween(waypoints[i - 1].position, waypoints[i].position)
	end
	return total
end

-- How long it takes an enemy to walk the full path at a given speed.
function GameMath.timeToTraversePath(waypoints: { Types.Waypoint }, speed: number): number
	if speed <= 0 then
		return math.huge
	end
	return GameMath.pathLength(waypoints) / speed
end

-- Total hit points across all enemies in a wave.
-- Looks up each entry's enemyType in the provided enemy config table.
function GameMath.waveTotalHealth(wave: Types.WaveConfig, enemies: { [string]: Types.EnemyConfig }): number
	local total = 0
	for _, entry in wave.entries do
		local enemy = enemies[entry.enemyType]
		if enemy then
			total += enemy.health * entry.count
		end
	end
	return total
end

-- Total currency reward for clearing an entire wave.
function GameMath.waveTotalReward(wave: Types.WaveConfig, enemies: { [string]: Types.EnemyConfig }): number
	local total = 0
	for _, entry in wave.entries do
		local enemy = enemies[entry.enemyType]
		if enemy then
			total += enemy.reward * entry.count
		end
	end
	return total
end

return GameMath
