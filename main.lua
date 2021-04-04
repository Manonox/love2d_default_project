local tick 			= require("tick")
local assets 		= require("assets") 		-- https://github.com/bjornbytes/cargo
local luvent 		= require("luvent") 		-- https://github.com/ejmr/Luvent
	  class 		= require("middleclass") 	-- https://github.com/kikito/middleclass
	  inspect 		= require("inspect") 		-- https://github.com/kikito/inspect.lua
local tween 		= require("tween") 			-- https://github.com/kikito/tween.lua
local cpml 			= require("cpml") 			-- https://github.com/excessive/cpml
local lovkit 		= require("lovkit") 		-- https://github.com/excessive/cpml
local reflowprint 	= require("reflowprint") 	-- https://github.com/josefnpat/reflowprint
local lume 			= require("lume") 			-- https://github.com/rxi/lume/
local lang 			= require("lang") 			-- https://github.com/excessive/i18n
local prof 			= require("jprof") 			-- https://github.com/pfirsich/jprof
local lurker 		= require("lurker")			-- https://github.com/rxi/lurker
local lovebird 		= require("lovebird") 		-- https://github.com/rxi/lovebird
local patchy 		= require("patchy") 		-- https://github.com/excessive/patchy
local gamestate 	= require("gamestate")		-- https://github.com/vrld/hump/blob/master/gamestate.lua
local timers 		= require("timers")


--[[
==========================
========== LOVE ==========
==========================
--]]

function love.load()
	love.gamestate = gamestate
	local states, first = unpack(require("states"))
	love.states = states
	gamestate.registerEvents()
	gamestate.switch(states[first])
end

function love.update(dt)
    love.profiler.enabled(love.profiler.target == "update" and PROF_ENABLED)
    love.profiler.push("frame")
end

function love.postupdate(dt)
	love.profiler.pop("frame")
    love.profiler.enabled(false)

    love.profiler.flushEvent:trigger()
    love.timer.update()
	lurker.update()
	assets.update()
    lovebird.update()
end

function love.draw()
    love.profiler.enabled(love.profiler.target == "draw" and PROF_ENABLED)
    love.profiler.push("frame")
end

function love.postdraw()
    love.profiler.pop("frame")
    love.profiler.enabled(false)
end




--[[
===========================
========== SETUP ==========
===========================
--]]

if not _SETUP then


	printTable = inspect


	-- lume mapping
	local map = {

		math = {
			"clamp",
			"round",
			"sign",
			"lerp"
		},

		table = {
			"randomchoice",
			"weightedchoice",
			"isarray",
			"push",
			delete = "remove",
			"clear",
			"extend",
			"shuffle",
			sortx = "sort",
			"array",
			"each",
			"map",
			"all",
			"any",
			"reduce",
			"unique",
			"filter",
			"reject",
			"merge",
			concatx = "concat",
			"find",
			"match",
			"count",
			"slice",
			"first",
			"last",
			"invert",
			"pick",
			"keys",
			"clone"
		},

		string = {
			"split",
			"trim",
			"wordwrap",
			"formatx"
		}

	}

	lambda = lume.lambda
	ripairs = lume.ripairs
	uuid = lume.uuid
	for lib, funcs in pairs(map) do
		for k, lumename in pairs(funcs) do
			if type(k) == "number" then
				k = lumename
			end
			_G[lib][k] = lume[lumename]
		end
	end


	tick.framerate = tick.framerate or 144
	tick.rate = tick.rate or 1 / 64
	tick.timescale = tick.timescale or 1
	love.tick = tick


	love.event.new = luvent.newEvent

	love.tween = {}
	love.tween.new = tween.new


	love.cpml = cpml


	love.language = lang()
	love.language.folder = "locales"
	function love.language.reload(self)
		self = self or love.language
		table.each(love.filesystem.getDirectoryItems(self.folder), function(f)
			self:load(self.folder .. "/" .. f)
		end)
	end
	love.language.reload()
	love.language:set_fallback("en")
	love.language:set_locale("en")


	love.profiler = prof
	love.profiler.target = "update"
	if PROF_ENABLED and not PROF_CONNECTED then
		PROF_CONNECTED = true
		prof.connect(false)
	end
	prof.flushEvent = luvent.newEvent()
	prof.flushEvent:addAction(prof.netFlush)
	prof.flushEvent:setActionInterval(prof.netFlush, PROF_RATE)


	love.assets = assets


	lurker.quiet = true
	function lurker.postswap(f)
		local splt = string.split(f, "/")
		if splt[1] == "locales" then
			love.language.reload()
		end
	end

	local lt_mt = {__index = timers.new()}
	setmetatable(love.timer, lt_mt)


	_SETUP = true
end