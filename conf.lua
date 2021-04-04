function love.conf(t)
	--t.identity = "default_project"
	io.stdout:setvbuf("no")

	--STATE_DEFAULT = "main"

	PROF_ENABLED = false
	PROF_CAPTURE = true
	PROF_RATE 	 = 1
end

love.filesystem.setRequirePath(
	love.filesystem.getRequirePath() .. ";libs/?.lua;libs/?/init.lua"
)