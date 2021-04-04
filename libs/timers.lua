local timers = {}

function timers.new()

	local timers = {}

	timers.list = {}

	local getuuid = function()
		return "" .. math.random(100000000, 1000000000-1) ..
			math.random(100000000, 1000000000-1) ..
			math.random(100000000, 1000000000-1)
	end

	function timers.update()
		for id, tbl in pairs(timers.list) do
			if tbl.t < os.clock() then
				tbl.func()
				timers.list[id] = nil
			end
		end
	end

	local tsimple_mt = {}
	function tsimple_mt:timeleft()
		return self.t - os.clock()
	end
	tsimple_mt.__index = tsimple_mt
	function timers.simple(t, func)
		local id = ((lume and lume.uuid) or uuid or getuuid)()
		local tsimple = {t = os.clock() + t, func = func}
		setmetatable(tsimple, tsimple_mt)
		timers.list[id] = tsimple
		return tsimple
	end

	return timers

end

return timers