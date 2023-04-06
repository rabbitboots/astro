
--[[
	Usage:
	LÖVE 11.x:
	> love . source_file_to_run
	(Omit the '.lua' extension.)

	Or use `love .` to run the main demo file.
--]]

function love.load(arguments)
	local demo_id = arguments[1] or "demo"

	require(demo_id)
end

