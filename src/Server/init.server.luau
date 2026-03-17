-- Server entrypoint
-- Runs in ServerScriptService as a Script

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Hello = require(Shared:WaitForChild("Hello"))

Hello.greet("Server")
