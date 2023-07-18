--jit.off()

function love.conf(t)

	local major, minor = love.getVersion()

	t.window.title = "Astro Demos (LÖVE " .. major .. "." .. minor .. ")"

	--t.gammacorrect = true
end
