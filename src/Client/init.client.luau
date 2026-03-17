-- Client entrypoint
-- Runs in StarterPlayerScripts as a LocalScript
--
-- The client deliberately requires only what it needs:
-- GameConfig, MapData, and TowerConfig. Wave composition and enemy
-- details are server-owned — the client doesn't need to know what's
-- spawning or how much health enemies have.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared:WaitForChild("GameConfig"))
local MapData = require(Shared:WaitForChild("MapData"))
local TowerConfig = require(Shared:WaitForChild("TowerConfig"))

print("[Client] Tower Defense client starting")
print(string.format("[Client] Map: %s", MapData.name))
print(string.format("[Client] Starting currency: %d", GameConfig.startingCurrency))

for towerName, tower in TowerConfig do
	print(string.format("[Client]   Available tower '%s': %d cost", towerName, tower.cost))
end
