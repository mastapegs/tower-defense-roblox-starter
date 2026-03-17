-- Tests for the headless GameMath module.
-- These prove the game logic works without touching any Roblox Instances.
-- Run via the TestRunner server script in Roblox Studio.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameMath = require(ReplicatedStorage.Shared.GameMath)

return function()
	describe("damagePerSecond", function()
		it("should multiply damage by fire rate", function()
			local tower = { name = "Test", damage = 10, range = 25, fireRate = 2, cost = 50 }
			expect(GameMath.damagePerSecond(tower)).to.equal(20)
		end)

		it("should return zero for zero fire rate", function()
			local tower = { name = "Test", damage = 10, range = 25, fireRate = 0, cost = 50 }
			expect(GameMath.damagePerSecond(tower)).to.equal(0)
		end)
	end)

	describe("timeToKill", function()
		it("should calculate time based on DPS and health", function()
			local tower = { name = "Test", damage = 10, range = 25, fireRate = 1, cost = 50 }
			local enemy = { name = "Test", health = 50, speed = 10, reward = 5 }
			expect(GameMath.timeToKill(tower, enemy)).to.equal(5)
		end)

		it("should return huge for zero DPS", function()
			local tower = { name = "Test", damage = 0, range = 25, fireRate = 1, cost = 50 }
			local enemy = { name = "Test", health = 50, speed = 10, reward = 5 }
			expect(GameMath.timeToKill(tower, enemy)).to.equal(math.huge)
		end)
	end)

	describe("distanceBetween", function()
		it("should calculate 3-4-5 triangle correctly", function()
			local a = { x = 0, y = 0, z = 0 }
			local b = { x = 3, y = 0, z = 4 }
			expect(GameMath.distanceBetween(a, b)).to.equal(5)
		end)

		it("should return zero for same position", function()
			local a = { x = 5, y = 10, z = 15 }
			expect(GameMath.distanceBetween(a, a)).to.equal(0)
		end)

		it("should include the y axis", function()
			local a = { x = 0, y = 0, z = 0 }
			local b = { x = 0, y = 10, z = 0 }
			expect(GameMath.distanceBetween(a, b)).to.equal(10)
		end)
	end)

	describe("isInRange", function()
		it("should return true when target is within range", function()
			local towerPos = { x = 0, y = 0, z = 0 }
			local targetPos = { x = 3, y = 0, z = 4 } -- distance = 5
			expect(GameMath.isInRange(towerPos, targetPos, 10)).to.equal(true)
		end)

		it("should return true when target is exactly at range", function()
			local towerPos = { x = 0, y = 0, z = 0 }
			local targetPos = { x = 3, y = 0, z = 4 } -- distance = 5
			expect(GameMath.isInRange(towerPos, targetPos, 5)).to.equal(true)
		end)

		it("should return false when target is beyond range", function()
			local towerPos = { x = 0, y = 0, z = 0 }
			local targetPos = { x = 3, y = 0, z = 4 } -- distance = 5
			expect(GameMath.isInRange(towerPos, targetPos, 4)).to.equal(false)
		end)
	end)

	describe("pathLength", function()
		it("should sum distances between consecutive waypoints", function()
			local waypoints = {
				{ position = { x = 0, y = 0, z = 0 }, order = 1 },
				{ position = { x = 3, y = 0, z = 4 }, order = 2 }, -- +5
				{ position = { x = 3, y = 0, z = 10 }, order = 3 }, -- +6
			}
			expect(GameMath.pathLength(waypoints)).to.be.near(11, 0.01)
		end)

		it("should return zero for a single waypoint", function()
			local waypoints = {
				{ position = { x = 0, y = 0, z = 0 }, order = 1 },
			}
			expect(GameMath.pathLength(waypoints)).to.equal(0)
		end)

		it("should return zero for empty waypoints", function()
			expect(GameMath.pathLength({})).to.equal(0)
		end)
	end)

	describe("timeToTraversePath", function()
		it("should divide path length by speed", function()
			local waypoints = {
				{ position = { x = 0, y = 0, z = 0 }, order = 1 },
				{ position = { x = 0, y = 0, z = 100 }, order = 2 },
			}
			expect(GameMath.timeToTraversePath(waypoints, 10)).to.equal(10)
		end)

		it("should return huge for zero speed", function()
			local waypoints = {
				{ position = { x = 0, y = 0, z = 0 }, order = 1 },
				{ position = { x = 0, y = 0, z = 100 }, order = 2 },
			}
			expect(GameMath.timeToTraversePath(waypoints, 0)).to.equal(math.huge)
		end)
	end)

	describe("waveTotalHealth", function()
		it("should sum health across all entries", function()
			local enemies = {
				Grunt = { name = "Grunt", health = 50, speed = 10, reward = 5 },
				Tank = { name = "Tank", health = 200, speed = 5, reward = 20 },
			}
			local wave = {
				preparationTime = 5,
				entries = {
					{ enemyType = "Grunt", count = 3, spawnInterval = 1 },
					{ enemyType = "Tank", count = 1, spawnInterval = 2 },
				},
			}
			-- (50 * 3) + (200 * 1) = 350
			expect(GameMath.waveTotalHealth(wave, enemies)).to.equal(350)
		end)

		it("should skip unknown enemy types", function()
			local enemies = {
				Grunt = { name = "Grunt", health = 50, speed = 10, reward = 5 },
			}
			local wave = {
				preparationTime = 5,
				entries = {
					{ enemyType = "Grunt", count = 2, spawnInterval = 1 },
					{ enemyType = "Unknown", count = 5, spawnInterval = 1 },
				},
			}
			expect(GameMath.waveTotalHealth(wave, enemies)).to.equal(100)
		end)
	end)

	describe("waveTotalReward", function()
		it("should sum rewards across all entries", function()
			local enemies = {
				Grunt = { name = "Grunt", health = 50, speed = 10, reward = 5 },
				Speeder = { name = "Speeder", health = 25, speed = 20, reward = 8 },
			}
			local wave = {
				preparationTime = 5,
				entries = {
					{ enemyType = "Grunt", count = 5, spawnInterval = 1 },
					{ enemyType = "Speeder", count = 2, spawnInterval = 1 },
				},
			}
			-- (5 * 5) + (8 * 2) = 41
			expect(GameMath.waveTotalReward(wave, enemies)).to.equal(41)
		end)
	end)
end
