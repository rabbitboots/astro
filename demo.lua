-- Astro demo.
-- See README.md for version and license info.

require("demo_lib.strict")


local astro = require("astro.astro")
local quadSlice = require("astro.lib.quad_slice")


-- Uncomment to test combined fill + stroke drawing for the shapes that support it.
--[[
do
	local defs = astro.defs

	defs.arc.style.draw = defs.arc.drawB
	defs.circle.style.draw = defs.circle.drawB
	defs.ellipse.style.draw = defs.ellipse.drawB
	defs.polygon.style.draw = defs.polygon.drawB
	defs.rect.style.draw = defs.rect.drawB
end
--]]


-- LÖVE 12 compatibility
local love_major, love_minor = love.getVersion()

local _newTextBatch

if love_major <= 11 then
	_newTextBatch = love.graphics.newText

else
	_newTextBatch = love.graphics.newTextBatch
	-- f7f5290: love.graphics.newMesh() -> arg #2 must be specified explicitly.
end


-- Set up demo state, pages and sprites
local pages = {}

local page_n = 1
local disp_font = love.graphics.newFont(16)
local time = 0
local text_color = {1, 1, 1, 1} -- overwritten by page text color


love.keyboard.setKeyRepeat(true)


-- Label helper
local function printLabel(text, x, y)

	love.graphics.push("all")

	love.graphics.setColor(text_color)
	love.graphics.setFont(disp_font)
	love.graphics.print(text, x, y)

	love.graphics.pop()
end


-- Centering helper for Image Sprites
local function getFrameDimensions(image_sprite)

	local width, height = 0, 0
	if image_sprite.quad then
		local _, _, w, h = image_sprite.quad:getViewport()
		width = w
		height = h

	else
		width, height = image_sprite.image:getDimensions()
	end

	return width, height
end


local function refreshPage()

	local page = pages[page_n]
	if page then
		text_color = page.color_text

	else
		error("missing page #" .. page_n)
	end
end


function love.keypressed(kc, sc, rep)

	local do_update = false

	if sc == "escape" then
		love.event.quit()
		return

	elseif sc == "left" then
		page_n = page_n - 1
		if page_n < 1 then
			page_n = #pages
		end
		do_update = true

	elseif sc == "right" then
		page_n = page_n + 1
		if page_n > #pages then
			page_n = 1
		end
		do_update = true
	end

	if do_update then
		refreshPage()
	end
end


-- Page 1 ---------------------------------------------------------------------

local img_pumpkin = love.graphics.newImage("demo_res/furious_pumpkin.png")
img_pumpkin:setFilter("linear", "linear")
local quad1 = love.graphics.newQuad(16, 16, 16, 16, img_pumpkin)

local spr_pumpkin1 = astro.newImage(img_pumpkin)
local spr_pumpkin2 = astro.newImage(img_pumpkin)
local spr_pumpkin3 = astro.newImage(img_pumpkin, quad1)

local img_window = love.graphics.newImage("demo_res/9slice.png")
img_window:setFilter("nearest", "nearest")
local slice_def = quadSlice.newSlice(0,0, 16,16, 16,16, 16,16, img_window:getDimensions())
local spr_slice = astro.newSlice(img_window, slice_def, false)

local img_palette = love.graphics.newImage("demo_res/27_colors.png")
img_palette:setFilter("nearest", "nearest")
local spr_palette = astro.newImage(img_palette)
local spr_palette_ref = astro.newImage(img_palette)

local img_joggers = love.graphics.newImage("demo_res/joggers.png")
img_joggers:setFilter("nearest", "nearest")

local anim_def1 = {
	image = img_joggers,
	frames = {
		{ quad = love.graphics.newQuad(64*0, 64*0, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*1, 64*0, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*2, 64*0, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*3, 64*0, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*0, 64*1, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*1, 64*1, 64, 64, img_joggers), time = 0.12 },
	},
	loop_point = 1,
}

local anim_def2 = {
	image = img_joggers,
	frames = {
		{ quad = love.graphics.newQuad(64*2, 64*1, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*3, 64*1, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*0, 64*2, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*1, 64*2, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*2, 64*2, 64, 64, img_joggers), time = 0.12 },
		{ quad = love.graphics.newQuad(64*3, 64*2, 64, 64, img_joggers), time = 0.12 },
	},
	loop_point = 1,
}


local spr_slice1 = astro.newSlice(img_window, slice_def, false)
spr_slice1.w = 56
spr_slice1.h = 48
spr_slice1.sx = 2
spr_slice1.sy = 2

local spr_anim1 = astro.newAnim(anim_def1)

spr_anim1.animate = true
spr_anim1.sx = 3
spr_anim1.sy = 3

local spr_anim2 = astro.newAnim(anim_def2)
spr_anim2.animate = true
spr_anim2.sx = 3
spr_anim2.sy = 3
spr_anim2.anim_speed_scale = -0.5


pages[#pages + 1] = {

	description = "image, anim, 9slice",
	color_bg = {0.2, 0.5, 0.2, 1.0},
	color_text = {1.0, 1.0, 1.0, 1.0},

	update = function(self, dt)

		local width, height
		width, height = getFrameDimensions(spr_pumpkin1)

		spr_pumpkin1.x = math.floor(width/2)
		spr_pumpkin1.y = math.floor(height/2)
		spr_pumpkin1.ox = math.floor(width/2)
		spr_pumpkin1.oy = math.floor(height/2)

		spr_pumpkin1.rad = spr_pumpkin1.rad + math.pi/256
		spr_pumpkin1.sx = math.abs(math.cos(time)) * math.sin(time)*4
		spr_pumpkin1.sy = math.abs(math.sin(time)) * 4

		width, height = getFrameDimensions(spr_pumpkin1)

		spr_pumpkin2.x = math.floor(width/2)
		spr_pumpkin2.y = math.floor(height/2)
		spr_pumpkin2.ox = math.floor(width/2)
		spr_pumpkin2.oy = math.floor(height/2)

		spr_pumpkin2.kx = math.cos(time/2)
		spr_pumpkin2.ky = math.sin(time/2)

		spr_pumpkin3.sx = 3.0
		spr_pumpkin3.sy = 3.0

		local rr = math.abs(math.sin(time + (math.pi/4)*0))
		local gg = math.abs(math.sin(time + (math.pi/4)*1))
		local bb = math.abs(math.sin(time + (math.pi/4)*2))
		spr_palette.r, spr_palette.g, spr_palette.b, spr_palette.a = rr, gg, bb, 1

		spr_anim1:updateAnimation(dt)
		spr_anim2:updateAnimation(dt)
	end,
	draw = function(self)

		spr_pumpkin1:draw(96, 96)
		spr_pumpkin2:draw(256, 96)
		printLabel("transform state (rad,sx,sy; kx,ky)", 16, 4)

		spr_pumpkin3:draw(384, 96)
		printLabel("with quad", 370, 48)

		love.graphics.setColor(1,1,1,1)
		spr_palette_ref:draw(500, 32)
		spr_palette:draw(500, 64)

		love.graphics.setColor(1,0,0,1)
		spr_palette:draw(500, 96)

		love.graphics.setColor(0,1,0,1)
		spr_palette:draw(500, 128)

		love.graphics.setColor(0,0,1,1)
		spr_palette:draw(500, 160)

		love.graphics.setColor(1, 1, 1, 1)
		printLabel("color mix", 500, 4)


		spr_anim1:draw(16, 288)
		spr_anim2:draw(256, 288)
		printLabel("animation (forwards, backwards 1/2spd)", 16, 256)


		love.graphics.push("all")

		spr_palette.r, spr_palette.g, spr_palette.b, spr_palette.a = 1, 1, 1, 1

		spr_palette.blend_mode = "add"
		spr_palette:draw(600, 64)

		spr_palette.blend_mode = "subtract"
		spr_palette:draw(600, 96)

		spr_palette.blend_mode = "alpha"

		love.graphics.pop()
		printLabel("Blend mode", 600, 4)


		spr_slice1.w = math.floor(64 + math.cos(time) * 16)
		spr_slice1.h = math.floor(48 + math.sin(time) * 8)

		spr_slice1.ox = spr_slice1.w/2
		spr_slice1.oy = spr_slice1.h/2

		--spr_slice1.rad = time
		spr_slice1:draw(600, 450)
		printLabel("9Slice", 600, 325)
	end,
}


-- Page 2 ---------------------------------------------------------------------

local points_spiral = {}
do
	for i = 1, 48 do
		points_spiral[#points_spiral + 1] = math.floor(50.5 + math.cos(i/4.5*math.pi) * i*0.95)
		points_spiral[#points_spiral + 1] = math.floor(50.5 + math.sin(i/4.5*math.pi) * i*0.95)
	end
end

local points_octogon = {
	 20, -40,
	 40, -20,
	 40,  20,
	 20,  40,
	-20,  40,
	-40,  20,
	-40, -20,
	-20, -40,
}

local spr_line1 = astro.newLine(points_spiral)
local spr_line2 = astro.newLine(points_spiral)

local spr_rect1p2 = astro.newRect(64, 64)
spr_rect1p2.r, spr_rect1p2.g, spr_rect1p2.b, spr_rect1p2.a = 1, 0, 0, 1

local spr_rect2p2 = astro.newRect(64, 64)
spr_rect2p2.r, spr_rect2p2.g, spr_rect2p2.b, spr_rect2p2.a = 1, 0, 0, 1

local spr_poly1 = astro.newPolygon(points_octogon)
local spr_poly2 = astro.newPolygon(points_octogon)

local spr_points1 = astro.newPoints(points_spiral)
local points_color = {}
do
	local rng = love.math.newRandomGenerator(2023-04-04)
	for i = 1, 64 do
		local point = {}

		point[1] = rng:random(1, 100) -- x
		point[2] = rng:random(1, 100) -- y
		point[3] = rng:random() -- r
		point[4] = rng:random() -- g
		point[5] = rng:random() -- b
		point[6] = 1.0 -- a

		table.insert(points_color, point)
	end
end

local spr_points2 = astro.newPoints(points_color)

pages[#pages + 1] = {

	description = "point-based shapes",
	color_bg = {0.5, 0.2, 0.5, 1.0},
	color_text = {1.0, 1.0, 1.0, 1.0},

	update = function(self, dt)

		spr_line1.line_style = "smooth"
		spr_line1.line_width = 1
		spr_line1.line_join = "miter"
		spr_line1.sx = 1
		spr_line1.sy = 1

		spr_line1.rad = time
		spr_line1.ox = 50
		spr_line1.oy = 50

		spr_line2.line_style = "rough"
		spr_line2.line_width = 4
		spr_line2.line_join = "none"
		spr_line2.sx = 2 -- magnify to get a better look at the line-joins
		spr_line2.sy = 2

		spr_line2.rad = time
		spr_line2.ox = 50
		spr_line2.oy = 50

		spr_rect1p2.line_join = "none"
		spr_rect1p2.line_width = 6
		spr_rect1p2.mode = "line"

		spr_rect2p2.mode = "fill"
		spr_rect2p2:draw(328, 32)

		spr_poly1.rad = time
		spr_poly1.mode = "line"

		spr_poly2.rad = -time
		spr_poly2.mode = "fill"

		spr_points1.point_size = 1 + math.abs(math.sin(time) * 7)
		spr_points1.rad = time*1.25
		spr_points1.ox = 50
		spr_points1.oy = 50

		spr_points2.point_size = 1 + math.abs(math.cos(time) * 7)
		spr_points2.rad = -time*1.25
		spr_points2.ox = 50
		spr_points2.oy = 50

		spr_points2.sx = math.sin(time)
	end,
	draw = function(self)

		spr_line1:draw(100, 100)
		printLabel("(poly)line", 8, 8)

		spr_line2:draw(100, 320)
		printLabel("line style, width, join", 8, 200)

		spr_rect1p2:draw(256, 32)
		spr_rect2p2:draw(328, 32)
		printLabel("rectangle (line; fill)", 256, 8)

		spr_poly1:draw(540, 100)
		spr_poly2:draw(640, 100)
		printLabel("polygon (line; fill)", 500, 8)

		spr_points1:draw(500 + 50, 290 + 50)
		spr_points2:draw(650 + 50, 290 + 50)
		printLabel("points (non-colored; colored)", 500, 256)
	end,
}

-- Page 3 ---------------------------------------------------------------------

local spr_circ1 = astro.newCircle(64)
local spr_circ2 = astro.newCircle(64)

local spr_ellipse1 = astro.newEllipse(64, 64)
local spr_ellipse2 = astro.newEllipse(64, 64)

local spr_arc1 = astro.newArc(64, 0, math.pi/2)
local spr_arc2 = astro.newArc(64, 0, math.pi/2)
local spr_arc3 = astro.newArc(64, 0, math.pi/2)
local spr_arc4 = astro.newArc(64, 0, math.pi/2)

pages[#pages + 1] = {

	description = "circular shapes",
	color_bg = {0.2, 0.2, 0.6, 1.0},
	color_text = {1.0, 1.0, 1.0, 1.0},

	update = function(self, dt)

		spr_circ1.line_join = "bevel"
		spr_circ1.line_width = 4

		spr_circ1.mode = "line"
		spr_circ1.radius = 55
		spr_circ1.segments = math.floor(3 + math.abs(math.sin(time) * 18))

		--spr_circ2.kx = math.cos(time)*0.25 -- best not to distort the circles when also demonstrating ellipses.
		spr_circ2.mode = "fill"
		spr_circ2.radius = 55
		spr_circ2.segments = math.floor(3 + math.abs(math.sin(time) * 18))

		spr_ellipse1.mode = "line"
		spr_ellipse1.radius_x = 50 + math.cos(time)*32
		spr_ellipse1.radius_y = 50 + math.sin(time*0.89)*32
		spr_ellipse1.segments = math.floor(3 + math.abs(math.cos(time) * 18))

		spr_ellipse2.mode = "fill"
		spr_ellipse2.radius_x = 50 + math.cos(time)*32
		spr_ellipse2.radius_y = 50 + math.sin(time*0.89)*32
		spr_ellipse2.segments = math.floor(3 + math.abs(math.cos(time) * 18))

		spr_arc1.mode = "line"
		spr_arc1.arctype = "pie"
		spr_arc1.radius = 64
		spr_arc1.angle1 = time * 2.15
		spr_arc1.angle2 = spr_arc1.angle1 + ((time * 1.24) % math.pi*2)
		--spr_arc1.segments = math.floor(3 + math.abs(math.cos(time) * 18))
		spr_arc1.line_width = 3
		spr_arc1.line_join = "none"

		spr_arc2.angle1 = -spr_arc1.angle1
		spr_arc2.angle2 = -spr_arc1.angle2

		spr_arc3.arctype = "open"
		--spr_arc3.mode = "fill"
		spr_arc3.line_width = 2.0
		spr_arc3.angle1 = spr_arc1.angle1
		spr_arc3.angle2 = spr_arc1.angle2

		spr_arc4.arctype = "closed"
		--spr_arc4.mode = "fill"
		spr_arc4.line_width = 2.0
		spr_arc4.angle1 = spr_arc2.angle1
		spr_arc4.angle2 = spr_arc2.angle2

		spr_arc2.mode = "fill"
	end,
	draw = function(self)

		spr_circ1:draw(64, 96)
		spr_circ2:draw(192, 96)
		printLabel("circle (line; fill)", 8, 8)

		spr_ellipse1:draw(112, 325)
		spr_ellipse2:draw(312, 325)
		printLabel("ellipse (line; fill)", 8, 200)

		spr_arc1:draw(500, 128)
		spr_arc2:draw(675, 128)
		printLabel("arc (pie): line, fill)", 500, 8)

		spr_arc3:draw(500, 320)
		spr_arc4:draw(675, 320)
		printLabel("arc: open, closed", 500, 224)
	end,
}

-- Page 4 ---------------------------------------------------------------------

local blurps = { "beep", "boop", "blop", "bap", "borp", "blip", "bip", "bap", "bi", }
local blurp_time = 0
local blurp_time_max = 0.33
local blurp_count = 0
local max_blurp_lines = 12
local blurped_out = false


local spr_print = astro.newPrint("", love.graphics.newFont(20))
spr_print.formatted = true
spr_print.align = "left"
spr_print.limit = love.graphics.getWidth() - 16

local spr_text = astro.newTextBatch(_newTextBatch(spr_print.font))
do
	local temp_c = {1,1,1,1}
	local temp_t = {temp_c, "ö"}
	for i = 1, 300 do
		temp_c[1] = love.math.random()
		temp_c[2] = love.math.random()
		temp_c[3] = love.math.random()
		spr_text.text_batch:add(temp_t, love.math.random(8 + love.graphics.getWidth() - 16), love.math.random(190))
	end
end


pages[#pages + 1] = {

	description = "text, print",
	color_bg = {0.8, 0.8, 0.8, 1.0},
	color_text = {0.0, 0.0, 0.0, 1.0},

	update = function(self, dt)
		if not blurped_out then
			blurp_time = blurp_time + dt

			if blurp_time >= blurp_time_max then
				local selected_blurp = blurps[love.math.random(#blurps)]
				local _, lines = spr_print.font:getWrap(spr_print.text .. " " .. selected_blurp, spr_print.limit)

				if #lines >= max_blurp_lines then
					blurped_out = true

				else
					blurp_time = blurp_time - blurp_time_max
					blurp_time_max = blurp_time_max * 0.99
					blurp_count = blurp_count + 1

					if blurp_count > 1 then
						spr_print.text = spr_print.text .. " "
					end

					spr_print.text = spr_print.text .. selected_blurp
				end
			end
		end

		spr_print.r, spr_print.g, spr_print.b, spr_print.a = text_color[1], text_color[2], text_color[3], text_color[4]
	end,

	draw = function(self)

		spr_print:draw(8, 32)
		printLabel("'print' object", 4, 4)

		spr_text:draw(8, 350)
		printLabel("LÖVE Text Object", 4, 324)
	end,
}


-- Page 5 ---------------------------------------------------------------------

local img_pumpkin_p5 = love.graphics.newImage("demo_res/furious_pumpkin.png")
img_pumpkin_p5:setFilter("linear", "linear")
local love_sprite_batch = love.graphics.newSpriteBatch(img_pumpkin_p5)
local spr_batch = astro.newSpriteBatch(love_sprite_batch)

do
	local temp = {}
	for i = 1, 4096 do
		temp[#temp + 1] = {
			love.math.random(love.graphics.getWidth() - img_pumpkin_p5:getWidth()),
			love.math.random(300 - img_pumpkin_p5:getHeight()),
		}
	end
	--table.sort(temp, function(a, b) return a[1] < b[1]; end)
	for i, v in ipairs(temp) do
		love_sprite_batch:add(v[1], v[2])
	end
end


local mesh_vertices = {
	{50,0, 0,0, 1,0,0,1},
	{0,50, 0,0.5, 0,1,0,1},
	{50,100, 0,1, 0,0,1,1},
	{150,50, 1,1, 0,1,1,1},
}

local love_mesh = love.graphics.newMesh(mesh_vertices, "fan")
local spr_mesh = astro.newMesh(love_mesh)
spr_mesh.ox = 50
spr_mesh.oy = 50

pages[#pages + 1] = {

	description = "spritebatch, mesh",
	color_bg = {0.5, 0.2, 0.1, 1.0},
	color_text = {1.0, 1.0, 1.0, 1.0},

	update = function(self, dt)

		spr_batch.ox = 400
		spr_batch.oy = 150
		spr_batch.sx = math.cos(time)
		spr_batch.kx = math.sin(time / 2) / 2

		spr_mesh.rad = math.sin(time) * 8
	end,

	draw = function(self)

		spr_batch:draw(400, 158)
		printLabel("SpriteBatch", 4, 4)

		spr_mesh:draw(400, 450)
		printLabel("Mesh", 4, 300)
	end,
}


-- Page 6 ---------------------------------------------------------------------

local spr_p6_img = astro.newImage(img_pumpkin)

local spr_p6_circ0 = astro.newCircle(24)
local spr_p6_circ1 = astro.newCircle(4)
local spr_p6_circ2 = astro.newCircle(4)
local spr_p6_rect1 = astro.newRect(2, 4)
local spr_p6_rect2 = astro.newRect(2, 4)
local spr_p6_arc = astro.newArc(9, 0, 0)

local spr_group = astro.newGroup()
table.insert(spr_group.sprites, spr_p6_img)
table.insert(spr_group.sprites, spr_p6_circ0)
table.insert(spr_group.sprites, spr_p6_circ1)
table.insert(spr_group.sprites, spr_p6_circ2)
table.insert(spr_group.sprites, spr_p6_rect1)
table.insert(spr_group.sprites, spr_p6_rect2)
table.insert(spr_group.sprites, spr_p6_arc)


pages[#pages + 1] = {

	description = "groups",
	color_bg = {0.5, 0.5, 0.5, 1.0},
	color_text = {1.0, 1.0, 1.0, 1.0},

	update = function(self, dt)

		spr_group.sx = 1.0 + (1.0 + math.cos(time) / 3) * 5
		spr_group.sy = 1.0 + (1.0 + math.cos(time) / 3) * 5
		spr_group.kx = math.sin(time) / 3
		spr_group.ky = math.sin(time) / 3
		spr_group.rad = math.cos(time) / 7

		spr_p6_circ0.mode = "line"
		spr_p6_circ0.r = 0.0
		spr_p6_circ0.g = 0.0
		spr_p6_circ0.b = 1.0
		spr_p6_circ0.a = 1.0
		spr_p6_circ0.x = 0
		spr_p6_circ0.y = 0

		spr_p6_circ1.mode = "fill"
		spr_p6_circ1.r = 0.0
		spr_p6_circ1.g = 0.0
		spr_p6_circ1.b = 1.0
		spr_p6_circ1.a = 1.0
		spr_p6_circ1.x = -8
		spr_p6_circ1.y = -6

		spr_p6_circ2.mode = "fill"
		spr_p6_circ2.r = 0.0
		spr_p6_circ2.g = 0.0
		spr_p6_circ2.b = 1.0
		spr_p6_circ2.a = 1.0
		spr_p6_circ2.x = 12
		spr_p6_circ2.y = -3

		spr_p6_rect1.mode = "fill"
		spr_p6_rect1.r = 0.0
		spr_p6_rect1.g = 0.0
		spr_p6_rect1.b = 1.0
		spr_p6_rect1.a = 1.0
		spr_p6_rect1.x = -2
		spr_p6_rect1.y = -4

		spr_p6_rect2.mode = "fill"
		spr_p6_rect2.r = 0.0
		spr_p6_rect2.g = 0.0
		spr_p6_rect2.b = 1.0
		spr_p6_rect2.a = 1.0
		spr_p6_rect2.x = 2
		spr_p6_rect2.y = -3

		spr_p6_arc.mode = "fill"
		spr_p6_arc.r = 0.0
		spr_p6_arc.g = 0.0
		spr_p6_arc.b = 1.0
		spr_p6_arc.a = 1.0
		spr_p6_arc.x = 2
		spr_p6_arc.y = 7
		spr_p6_arc.angle1 = math.pi
		spr_p6_arc.angle2 = 0

		local w, h = getFrameDimensions(spr_p6_img)
		spr_p6_img.r = 0.0
		spr_p6_img.g = 0.0
		spr_p6_img.b = 1.0
		spr_p6_img.a = math.sin(time)
		spr_p6_img.x = 0
		spr_p6_img.y = 0
		spr_p6_img.ox = math.floor(w/2)
		spr_p6_img.oy = math.floor(h/2)
	end,

	draw = function(self)
		printLabel("image + circles + rectangles + arc in one group", 8, 8)

		local win_w, win_h = love.graphics.getDimensions()
		spr_group:draw(math.floor(win_w/2), math.floor(win_h/2))
	end,
}


-------------------------------------------------------------------------------


refreshPage()


function love.update(dt)

	time = time + dt

	local page = pages[page_n]
	if page then
		page:update(dt)
	end
end


function love.draw()

	love.graphics.setFont(disp_font)

	local page = pages[page_n]
	if page then
		love.graphics.push("all")

		love.graphics.clear(page.color_bg)
		page:draw()

		love.graphics.pop()
	end

	local hud_w = love.graphics.getWidth() + 1
	local hud_h = math.ceil(disp_font:getHeight() * 2.5)
	local hud_x = 0
	local hud_y = love.graphics.getHeight() - hud_h

	love.graphics.setColor(0.0, 0.0, 0.0, 0.8)
	love.graphics.rectangle("fill", hud_x, hud_y, hud_w, hud_h)
	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

	local pad = 4
	love.graphics.print(
		"(left/right) Page " .. page_n .. "/" .. #pages .. ": " .. page.description,
		hud_x + pad,
		hud_y + pad
	)
end


--[=[
-- Assertion tests
do
	local spr
	local font = love.graphics.newFont(10)
	local id = love.image.newImageData(32, 32)
	local pic = love.graphics.newImage(id)
	local sprite_batch = love.graphics.newSpriteBatch(pic)
	local text_batch = _newTextBatch(font)

	--spr = astro.newAnim(nil) -- #1 bad type

	-- The integrity of the AnimDef table itself is not checked.
	--spr = astro.newAnim({}) -- Non-specific error due to lack of 'frames' sub-table.

	--spr = astro.newArc(false, 2, 3) -- #1 bad type
	--spr = astro.newArc(1, false, 3) -- #2 bad type
	--spr = astro.newArc(1, 2, false) -- #3 bad type

	--spr = astro.newCircle(false) -- #1 bad type

	--spr = astro.newEllipse(false, 2) -- #1 bad type
	--spr = astro.newEllipse(1, false) -- #2 bad type

	--spr = astro.newGroup() -- correct
	--spr = astro.newGroup(false) -- correct
	--spr = astro.newGroup({}) -- correct
	--spr = astro.newGroup(function() end) -- #1 bad type

	--spr = astro.newImage(false) -- #1 bad type
	--spr = astro.newImage(pic) -- correct
	--spr = astro.newImage(pic, false) -- correct
	--spr = astro.newImage(pic, {}) -- #2 bad type

	--spr = astro.newLine() -- #1 bad type

	--spr = astro.newMesh({}) -- #1 bad type

	--spr = astro.newPoints(false) -- #1 bad type

	--spr = astro.newPolygon("foobar") -- #1 bad type

	--spr = astro.newPrint(false, font) -- #1 bad type
	--spr = astro.newPrint("foo", false) -- #2 bad type
	--spr = astro.newPrint("foo", font) -- correct
	--spr = astro.newPrint("", font) -- correct
	--spr = astro.newPrint(640, font) -- correct
	--spr = astro.newPrint({}, font) -- correct (empty coloredtext)

	--spr = astro.newRect(0, 0) -- correct
	--spr = astro.newRect(false, 0) -- #1 bad type
	--spr = astro.newRect(0, false) -- #2 bad type

	--spr = astro.newSlice(pic, {}) -- accepted by assertions, though it won't work due to an empty Slice Def.
	--spr = astro.newSlice(false, {}) -- #1 bad type
	--spr = astro.newSlice(pic, {}, "ding") -- #3 bad type

	--spr = astro.newSpriteBatch(sprite_batch) -- correct
	--spr = astro.newSpriteBatch("boo") -- #1 bad type

	--spr = astro.newTextBatch(text_batch) -- correct
	--spr = astro.newTextBatch("far") -- #1 bad type
end
--]=]
