-- Example shared module accessible by both Client and Server

local Hello = {}

function Hello.greet(caller: string)
	print(string.format("[%s] Hello from Tower Defense!", caller))
end

return Hello
