-- Client entrypoint
-- Runs in StarterPlayerScripts as a LocalScript

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Hello = require(Shared:WaitForChild("Hello"))

Hello.greet("Client")
