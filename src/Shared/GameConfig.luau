-- Game-wide constants that no single system owns.
-- Values that many modules need but that don't belong to towers, enemies, or waves.

local GameConfig = {}

GameConfig.startingCurrency = 100
GameConfig.startingLives = 20
GameConfig.maxTowers = 25

return GameConfig
