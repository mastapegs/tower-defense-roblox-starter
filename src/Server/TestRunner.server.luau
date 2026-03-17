-- TestEZ test runner — discovers and runs all .spec modules.
-- This script runs in ServerScriptService on startup.
-- In a production build, you'd remove or disable this script.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local TestEZ = require(ServerStorage.DevPackages.TestEZ)

-- Collect all .spec modules from Shared
local testModules = {}
for _, module in ReplicatedStorage.Shared:GetChildren() do
	if module:IsA("ModuleScript") and module.Name:match("%.spec$") then
		table.insert(testModules, module)
	end
end

print(string.format("[TestRunner] Found %d test module(s)", #testModules))

TestEZ.TestBootstrap:run(testModules)
