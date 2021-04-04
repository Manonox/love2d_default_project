return require("cargo").init({
	dir = "assets",
	loaders = {
		--jpg = love.graphics.newImage
	},
	processors = {
		['.9.'] = function(asset, filename, t, k)
			local newasset = require("patchy").load(filename)
			rawset(t, k, newasset)
		end
	}
})