local states = {}
for _, f in pairs(love.filesystem.getDirectoryItems("states")) do
	if f ~= "init.lua" then
		local statename = string.split(f, ".")[1]
		states[statename] = require("states." .. statename)
	end
end

return {states, STATE_DEFAULT or "main"}