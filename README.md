**Version 1.0.0**

# Astro

Astro is a sprite container library for the LÖVE Framework.


# What's Included

* Sprite objects for:
  * Textures + Quads
  * 9-Slices (via [QuadSlice](https://github.com/rabbitboots/quad_slice))
  * Meshes
  * SpriteBatches
  * TextBatches
  * `love.graphics.print` and `love.graphics.printf`
  * `love.graphics` shapes: Arc, Circle, Ellipse, Line, Points, Polygon, Rectangle
* *Group* Sprites to draw multiple Sprites with shared color and transform state
* Alternative *Fill+Stroke* draw methods for shapes with both [DrawModes](https://love2d.org/wiki/DrawMode)


# What's Missing

* Considerations for stencils and GL scissor-boxes
* Considerations for shaders
* Considerations for sprite pooling
* Missing an object for LÖVE Particle Systems


# A Small Example

```lua
-- Draw a rotating image at 300% scale.
local astro = require("astro.astro")

local img = love.graphics.newImage("demo_res/furious_pumpkin.png")
local spr = astro.newImage(img)

spr.ox = math.floor(img:getWidth() / 2)
spr.oy = math.floor(img:getHeight() / 2)
spr.sx, spr.sy = 3.0, 3.0

function love.update(dt)
	spr.rad = spr.rad + dt
end

function love.draw()

	local xx = math.floor(love.graphics.getWidth() / 2)
	local yy = math.floor(love.graphics.getHeight() / 2)

	spr:draw(xx, yy)
end
```

See `demo.lua` for more examples.


# Common Parameters and Methods

All Astro Sprites have the following parameters, with defaults set in their style (`__index`) tables:

Transform fields: `x`, `y`, `rad` (rotation in radians), `sx`, `sy`, `ox`, `oy`, `kx` and `ky`

Color: `r`, `g`, `b`, `a`

Blend Mode: `blend_mode`, `alpha_mode`

Only draws when true: `visible`

Astro Sprites have a `setColor` method which mixes the Sprite color with the LÖVE global graphics state color. When gamma-correct rendering is detected, a gamma-correct version of the function is used.

All Astro Sprites have a `draw` method which takes `x` and `y` offsets as its first two arguments. Any additional arguments depend on the Sprite implementation.

Width, height, additional colors, etc. depend on the Sprite implementation. Check the Sprite Def source files for more info.


# Sprite Types

## Animated Image Sprite

Displays an animated Image.

Implementation: `spr_anim.lua`

LÖVE: [Image](https://love2d.org/wiki/Image), [Quad](https://love2d.org/wiki/Quad)

**NOTE:** This is a pretty basic animation system, included mainly as a demonstration.

AnimDefs provide the Sprite with a texture, a sequence of quads, and the amount of time to hold on each frame:

```lua
local anim_def = {
	-- The LÖVE Image for this animation.
	image = my_image,

	-- Table of frames. At least one frame is required.
	frames = {
		-- Frame #1
		{
			quad = love.graphics.newQuad(64*0, 64*0, 64, 64, my_image),
			time = 0.25, -- (in seconds, if using dt)
		},
		-- (Additional frames)
	},
}
```


### astro.newAnim

Creates an Animated Image Sprite.

`local spr_anim = astro.newAnim(anim_def)`

* `anim_def`: The starting AnimDef table. Required.

**Returns:** A new Animated Sprite.


### AnimSpr:draw

Draws the Animated Sprite.

`AnimSpr:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


### AnimSpr:updateAnimation

Updates the timing and current frame for an Animated Image Sprite.

`AnimSpr:updateAnimation(time)`

* `time` Elapsed time since the last update. This is typically the frame delta from `love.update`.


### AnimSpr:refreshAnimation

Refreshes the quad for the Animated Image Sprite. Used internally. Should also be used after changing the Sprite's AnimDef or adjusting the current frame index.

`AnimSpr:refreshAnimation()`


## Arc Sprite

Displays an arc (portion of a circle).

Implementation: `spr_arc.lua`

LÖVE: [love.graphics.arc](https://love2d.org/wiki/love.graphics.arc)


### astro.newArc

Creates a new Arc Sprite.

`local spr_arc = astro.newArc(radius, angle1, angle2)`

* `radius`: Radius of the arc.

* `angle1`: Starting angle.

* `angle2`: Ending angle.


**Returns:** A new Arc Sprite.


### SprArc:draw

Draws the Arc Sprite.

`SprArc:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.

**NOTE:** This can be overwritten with `astro.defs.arc.drawB`, An alternative draw method that renders both the fill and stroke. See `spr_arc.lua` for more info.


## Circle Sprite

Displays a circle.

Implementation: `spr_circle.lua`

LÖVE: [love.graphics.circle](https://love2d.org/wiki/love.graphics.circle)


### astro.newCircle

Creates a new Circle Sprite.

`local spr_circle = astro.newCircle(raduis)`

* `radius`: Radius of the circle.

**Returns:** A new Circle Sprite.


### SprCircle:draw

Draws the Circle Sprite.

`SprArc:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.

**NOTE:** This can be overwritten with `astro.defs.circle.drawB`, An alternative draw method that renders both the fill and stroke. See `spr_circle.lua` for more info.


## Ellipse Sprite

Displays an ellipse.

Implementation: `spr_ellipse.lua`

LÖVE: [love.graphics.ellipse](https://love2d.org/wiki/love.graphics.ellipse)


### astro.newEllipse

Creates a new Ellipse Sprite.

`local spr_ellipse = astro.newEllipse(radius_x, radius_y)`

* `radius_x`: X axis radius.

* `radius_y`: Y axis radius.

**Returns:** A new Ellipse Sprite.


### SprEllipse:draw

Draws the Ellipse Sprite.

`SprEllipse:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.

**NOTE:** This can be overwritten with `astro.defs.ellipse.drawB`, An alternative draw method that renders both the fill and stroke. See `spr_ellipse.lua` for more info.


## Group Sprite

Displays an array of sub-Sprites.

Implementation: `spr_group.lua`

LÖVE: *N/A*


### astro.newGroup

Creates a new Group Sprite.

`local spr_group = astro.newGroup(sprites)`

* `sprites` *(new table)* Optional table of sprites to draw. If none is provided, a new table will be created.

**Returns:** A new Group Sprite.


## SprGroup:draw

Draws the Group Sprite.

`SprGroup:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


**NOTE:** If a Group Sprite's visibility is false, none of its sub-Sprites will be drawn.


## Image Sprite

Displays an Image with an optional Quad viewport.

Implementation: `spr_image.lua`

LÖVE: [Image](https://love2d.org/wiki/Image), [Quad](https://love2d.org/wiki/Quad)


### astro.newImage

Creates an Image Sprite with an optional Quad viewport.

`local spr_img = astro.newImage(img, quad)`

* `img`: A LÖVE Image.

* `quad`: *(nil)* An optional Quad.

**Returns:** A new Image Sprite.


### SprImage:draw

Draws the Image Sprite.

`SprImage:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


## Line Sprite

Displays a line or polyline.

Implementation: `spr_line.lua`

LÖVE: [love.graphics.line](https://love2d.org/wiki/love.graphics.line)


### astro.newLine

Creates a new Line Sprite.

`local spr_line = astro.newLine(points)`

* `points`: Table of X,Y coordinate pairs.

**Returns:** A new Line Sprite.


### SprLine:draw

Draws the Line Sprite.

`SprLine:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


## Mesh Sprite

Displays a LÖVE Mesh.

Implementation: `spr_mesh.lua`

LÖVE: [Mesh](https://love2d.org/wiki/Mesh)


### astro.newMesh

Creates a new Mesh Sprite.

`local spr_mesh = astro.newMesh(mesh)`

* `mesh`: The LÖVE Mesh to use.

**Returns:** A new Mesh Sprite.


### SprMesh:draw

Draws the Mesh Sprite.

`SprMesh:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


## Points Sprite

Displays a sequence of points.

Implementation: `spr_points.lua`

LÖVE: [love.graphics.points](https://love2d.org/wiki/love.graphics.points)

**NOTE:** While the positions of LÖVE points are affected by the coordinate system, the actual size of points rendered is in DPI-scaled units, and not affected by the current scale. As an alternative, you could draw a sequence of small rectangles or circles in a loop.


### astro.newPoints

Creates a new Points Sprite.

`local spr_points = astro.newPoints(points)`

* `points`: A table of X,Y coordinate pairs.

**Returns:** A new Points Sprite.


### SprPoints:draw

Draws the Points Sprite.

`SprPoints:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


## Polygon Sprite

Displays a polygon.

Implementation: `spr_polygon.lua`

LÖVE: [love.graphics.polygon](https://love2d.org/wiki/love.graphics.polygon)

**NOTE:** Not all shapes render correctly in `fill` mode. See the above LÖVE wiki link for details.


### astro.newPolygon

Creates a new Polygon Sprite.

`local spr_polygon = astro.newPolygon(points)`

* `points`: Table of X,Y coordinate pairs.

**Returns:** A new Polygon Sprite.


### SprPolygon:draw

Draws the Polygon Sprite.

`SprPolygon:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.

**NOTE:** This can be overwritten with `astro.defs.polygon.drawB`, An alternative draw method that renders both the fill and stroke. See `spr_polygon.lua` for more info.


## Print Sprite

Displays one string or coloredtext sequence.

Implementation: `spr_print.lua`

LÖVE: [love.graphics.print](https://love2d.org/wiki/love.graphics.print), [love.graphics.printf](https://love2d.org/wiki/love.graphics.printf)


### astro.newPrint

Creates a new Print Sprite.

`local spr_print = astro.newPrint(text, font)`

* `text` A string or `coloredtext` table sequence.

* `font` A LÖVE Font to use when printing the text.

**Returns:** A new Print Sprite.


### SprPrint:draw

Draws the Print Sprite.

`SprPrint:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


## Rectangle Sprite

Displays a rectangle.

Implementation: `spr_rect.lua`

LÖVE: [love.graphics.rectangle](https://love2d.org/wiki/love.graphics.rectangle)


### astro.newRect

Creates a new Rectangle Sprite.

`local spr_rect = astro.newRect(w, h)`

* `w`: Rectangle width.

* `h`: Rectangle height.

**Returns:** A new Rectangle Sprite.


### sprRect:draw

Draws the Rectangle Sprite.

`SprRect:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.

**NOTE:** This can be overwritten with `astro.defs.rect.drawB`, An alternative draw method that renders both the fill and stroke. See `spr_rect.lua` for more info.


## Slice Sprite

Displays a 9-Slice (nine textures arranged in a 3x3 grid).

Implementation: `spr_slice.lua` (See also `lib/quad_slice.lua`)

LÖVE: *N/A*


### astro.newSlice

Creates a new 9-Slice Sprite.

`local spr_slice = astro.newSlice(image, slice, hollow)`

* `image`: The LÖVE Image to use.

* `slice`: The Slice Definition, created with `lib/quad_slice.lua`.

* `hollow`: When true, omit the center tile when drawing.


**Returns:** A new 9-Slice Sprite.


### SprSlice:draw

Draws the 9-Slice Sprite.

`SprSlice:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


## SpriteBatch Sprite

Displays a LÖVE SpriteBatch object.

Implementation: `spr_sprite_batch.lua`

LÖVE: [SpriteBatch](https://love2d.org/wiki/SpriteBatch)


### astro.newSpriteBatch

Creates a new SpriteBatch Sprite.

`local spr_batch = astro.newSpriteBatch(sprite_batch)`

* `sprite_batch`: The LÖVE SpriteBatch to use.

**Returns:** A new SpriteBatch Sprite.


### SprBatch:draw

Draws the SpriteBatch Sprite.

`SprBatch:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


## TextBatch Sprite

Displays a LÖVE Text object (renamed *TextBatch* in 12).

Implementation: `spr_text_batch.lua`

LÖVE: [TextBatch](https://love2d.org/wiki/Text)


### astro.newTextBatch

Creates a new TextBatch Sprite.

`local spr_text_batch = astro.newTextBatch(text_batch)`

* `text_batch`: The LÖVE Text Batch to use.

**Returns:** A new TextBatch Sprite.


### SprTextBatch:draw

Draws the TextBatch Sprite.

`SprTextBatch:draw(x, y)`

* `x`: X drawing offset.

* `y`: Y drawing offset.


# Usage Notes

* Gamma correct rendering: During LÖVE's boot-up, if JIT and FFI are active, then optimized versions of `love.math.gammaToLinear()` and `love.math.linearToGamma()` are swapped in. If you need to disable JIT for whatever reason, do so in conf.lua before this optimization takes effect.

* LÖVE 11.3: the `smooth` line style is linked to a rare crashing bug. This is fixed in 11.4. Upgrading is strongly recommended.

* There are a couple of crash bugs with TextBatches in LÖVE 11.x that are fixed in 12. They involve adding whitespace-only strings, and using small `wraplimit` values when calling `Text:addf()`.


# MIT License

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
