-- The boundary between headless game logic and the Roblox runtime.
--
-- Like a Theme trait in a headless UI library, the Adapter is where the
-- "brain" (pure logic with Position tables) connects to the "body"
-- (Roblox Instances with Vector3 values).
--
-- All runtime code that needs to convert between the two layers goes
-- through here — one place, one pattern, easy to find.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)

local Adapter = {}

-- Convert a headless Position to a Roblox Vector3.
function Adapter.toVector3(pos: Types.Position): Vector3
	return Vector3.new(pos.x, pos.y, pos.z)
end

-- Convert a Roblox Vector3 to a headless Position.
function Adapter.fromVector3(v: Vector3): Types.Position
	return { x = v.X, y = v.Y, z = v.Z }
end

return Adapter
