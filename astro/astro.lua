-- Astro: a sprite module for LÖVE.
-- Version: 1.0.0


--[[
Copyright (c) 2023 RBTS

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]


local astro = {}


local REQ_PATH = ... and (...):match("(.-)[^%.]+$") or ""


astro.defs = {}
do
	local defs = astro.defs
	defs.anim = require(REQ_PATH .. "spr_anim")
	astro.newAnim = defs.anim.new -- (anim_def)

	defs.arc = require(REQ_PATH .. "spr_arc")
	astro.newArc = defs.arc.new -- (radius, angle1, angle2)

	defs.circle = require(REQ_PATH .. "spr_circle")
	astro.newCircle = defs.circle.new -- (radius)

	defs.ellipse = require(REQ_PATH .. "spr_ellipse")
	astro.newEllipse = defs.ellipse.new -- (radius_x, radius_y)

	defs.group = require(REQ_PATH .. "spr_group")
	astro.newGroup = defs.group.new -- ()

	defs.image = require(REQ_PATH .. "spr_image")
	astro.newImage = defs.image.new -- (image, [quad])

	defs.line = require(REQ_PATH .. "spr_line")
	astro.newLine = defs.line.new -- (points)

	defs.mesh = require(REQ_PATH .. "spr_mesh")
	astro.newMesh = defs.mesh.new -- (mesh)

	defs.points = require(REQ_PATH .. "spr_points")
	astro.newPoints = defs.points.new -- (points)

	defs.polygon = require(REQ_PATH .. "spr_polygon")
	astro.newPolygon = defs.polygon.new -- (points)

	defs.print = require(REQ_PATH .. "spr_print")
	astro.newPrint = defs.print.new -- (text, font)

	defs.rect = require(REQ_PATH .. "spr_rect")
	astro.newRect = defs.rect.new -- (w, h)

	defs.slice = require(REQ_PATH .. "spr_slice")
	astro.newSlice = defs.slice.new -- (image, slice, hollow)

	defs.sprite_batch = require(REQ_PATH .. "spr_sprite_batch")
	astro.newSpriteBatch = defs.sprite_batch.new -- (sprite_batch)

	defs.text_batch = require(REQ_PATH .. "spr_text_batch")
	astro.newTextBatch = defs.text_batch.new -- (text_batch)
end


return astro
