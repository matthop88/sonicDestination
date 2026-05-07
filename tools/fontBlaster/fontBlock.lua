local GLYPH       = require("tools/fontBlaster/glyph")
local FONT_OBJECT = require("tools/fontBlaster/fontObject")

local drawEditingBlock  = function(self)
	local graphics = self.graphics
	graphics:setColor(1, 1, 1)
	graphics:setLineWidth(1)
	graphics:rectangle("line", self.x - 4, self.y - 4, self.w + 7, self.h + 8)
end

local drawSelectedBlock = function(self)
	local graphics = self.graphics
	graphics:setColor(0, 0, 0, 0.3)
	graphics:rectangle("fill", self.x - 1, self.y - 1, self.w + 1, self.h + 2)
	graphics:setColor(1, 1, 1)
	graphics:setLineWidth(3)
	graphics:rectangle("line", self.x - 2, self.y - 2, self.w + 3, self.h + 4)
	graphics:setColor(0, 0, 0)
	graphics:setLineWidth(1)
	graphics:rectangle("line", self.x - 1, self.y - 1, self.w + 1, self.h + 2)
	graphics:rectangle("line", self.x - 4, self.y - 4, self.w + 7, self.h + 8)
	graphics:setColor(0, 0, 0, 0.5)
	graphics:rectangle("fill", self.x - 32, self.y - 24, 32, 24)
	graphics:setColor(1, 1, 1)
	graphics:rectangle("line", self.x - 32, self.y - 24, 32, 24)
	graphics:setFontSize(8)
	local coordinateString = "" .. math.floor(self.x) .. ",\n" .. math.floor(self.y)
	graphics:printf(coordinateString, self.x - 32, self.y - 20, 32, "center")
end

local drawFontObject = function(self)
	local graphics = self.graphics
	self.obj:draw(graphics, self.x, self.y)
	if self.editing then
		drawEditingBlock(self)
	elseif self.selected then
		drawSelectedBlock(self)
	elseif self.highlighted then
		graphics:setColor(1, 1, 0)
		graphics:rectangle("line", self.x - 1, self.y - 1, self.w + 1, self.h + 2)
	end
end

local calculateWidth = function(self)
	local width = 0
	self.obj.glyphs:forEach(function(glyph) 
		width = width + glyph.w
	end)
	return width
end

local calculateHeight = function(self)
	local height = 0
	self.obj.glyphs:forEach(function(glyph) 
		height = math.max(height, glyph.h)
	end)
	return height
end

return {
	create = function(self, params)
		return ({
			obj         = params.fontObj,
			x           = params.x,
			y           = params.y,
			highlighted = false,
			selected    = false,
			graphics    = params.graphics,
			deleted     = false,
			editing     = false,

			draw = drawFontObject,

			init = function(self)
				self.w = calculateWidth(self)
				self.h = calculateHeight(self)

				return self
			end,

			update = function(self, dt)
				local px, py = self.graphics:screenToImageCoordinates(love.mouse.getPosition())
				self.highlighted = self:ptInBounds(px, py)
				if self.selected and love.mouse.isDown(1) then
					self.x = self.x + (math.floor(px) - self.selectedAt.x)
					self.y = self.y + (math.floor(py) - self.selectedAt.y)
					self.selectedAt.x = math.floor(px)
					self.selectedAt.y = math.floor(py)
				end
			end,

			mouseInBounds = function(self, mx, my)
				return self:ptInBounds(self.graphics:screenToImageCoordinates(mx, my))
			end,

			ptInBounds = function(self, px, py)
				return px >= self.x and py >= self.y and px < self.x + self.w and py < self.y + self.h
			end,

			deselect   = function(self) self.selected = false end,

			setDeleted = function(self) self.deleted = true   end,
			isDeleted  = function(self) return self.deleted   end,
			select     = function(self, mx, my) 
				self.selected = true  
				local px, py  = self.graphics:screenToImageCoordinates(mx, my)
				self.selectedAt = { x = math.floor(px), y = math.floor(py) }
			end,
			deselect     = function(self) 
				self.selected = false 
				if self:getGlyphCount() == 0 then self:setDeleted() end
			end,
			isSelected   = function(self) return self.selected  end,
			startEditing = function(self) 
				self.editing = true   
				self:backupGlyphs()
				getInputLayer():activate()
			end,
			stopEditing  = function(self) 
				if self:isEditing() then
					self.editing = false 
					self.buGlyphs = nil
					getInputLayer():deactivate()
				end
			end,
			isEditing    = function(self) return self.editing   end,  

			deleteLastGlyph  = function(self)
				self.obj.glyphs:tail()
				self.obj.glyphs:remove()
				self.obj.glyphs:head()
				self.w = calculateWidth(self)
				self.h = calculateHeight(self)
			end,

			appendGlyph = function(self, key)
				if key == "return" then
					self:stopEditing()
					self:deselect()
				else
					local glyph = GLYPH:create(self.obj.font, key)
					self.obj.glyphs:add(glyph)
					self.w = calculateWidth(self)
					self.h = calculateHeight(self)
				end
			end,

			backupGlyphs = function(self)
				self.buGlyphs = require("game/util/dataStructures/linkedList"):create()
				self.obj.glyphs:forEach(function(glyph) 
					self.buGlyphs:add(glyph)
				end)
			end,

			revert = function(self)
				if self.buGlyphs then
					self.obj.glyphs = self.buGlyphs
					self.w = calculateWidth(self)
					self.h = calculateHeight(self)
				end
			end,
	
			nudge = function(self, deltaX, deltaY)
				self.x = self.x + deltaX
				self.y = self.y + deltaY
			end,

			getGlyphCount = function(self)
				return self.obj.glyphs:size()
			end,

		}):init()
	end,
}
