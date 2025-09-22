:--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local INSET = 16
local GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), 1200, 800)

local OFFSET  = { x = 0, y = 0 }

local modes = require("tools/chunkalyzer/modes")

local prevGraphics = { x = GRAFX.x, y = GRAFX.y }

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

return {
	isChunkVisible = true,

	yBlit = 0,

	image = nil,

    chunkTags = {
        isUnique = function(self, x, y)
            for _, c in ipairs(self) do
                if c.x == x and c.y == y then return false end
            end

            return true
        end,
    },

	init = function(self, image)
		self.image = image
		return self
	end,

	draw = function(self)
        GRAFX:setColor(0, 0, 0)
        GRAFX:rectangle("fill", GRAFX:calculateViewport())

        self:drawWorldMap()
        self:drawTags()

        if self.isChunkVisible and self.inFocus then self:drawCurrentChunk() end
    end,

    update = function(self, dt)
        self:updateChunkVisibility(dt)
		self:keepImageInBounds()
    end,

    handleKeypressed = function(self, key)
        if     key == "optionleft"  then OFFSET.x = math.max(0,   OFFSET.x - 1)
        elseif key == "optionright" then OFFSET.x = math.min(128, OFFSET.x + 1)
        elseif key == "optionup"    then OFFSET.y = math.max(0,   OFFSET.y - 1)
        elseif key == "optiondown"  then OFFSET.y = math.min(128, OFFSET.y + 1)
        elseif key == "backspace"   then modes:next()
     	elseif key == "escape"      then modes:reset()
    	end
    end,

    handleMousepressed = function(self, mx, my)
        local cX, cY = self:getChunkXY(self:getMousePositionFn())
        local currentMode = modes:get()

        if currentMode.fn then currentMode.fn(cX, cY) end
        
        modes:next()
    end,

    --------------------------------------------------------------
    --               Specialized Draw Functions                 --
    --------------------------------------------------------------

    drawWorldMap = function(self)
        GRAFX:setColor(1, 1, 1)
        GRAFX:draw(self.image, INSET, INSET)
    end,

    drawCurrentChunk = function(self)
        if self:isInImageBounds(self:getQuadFromMouseCoordinates()) then
            local cX, cY = self:getChunkXY(self:getMousePositionFn())
            local x,  y  = self:getWorldCoordinatesOfChunk(cX, cY)

            if love.mouse.isDown(1) then self:drawChunkSelection(x, y)
            else                         self:drawChunkOutline(  x, y) end
        end
    end,

    getChunkXY = function(self, x, y)
        local imgX, imgY = GRAFX:screenToImageCoordinates(x, y)
        return math.floor(imgX / 256), math.floor(imgY / 256)
    end,

	getImageCoordinatesOfChunk = function(self, cX, cY)
		return (cX * 256) + OFFSET.x, (cY * 256) + OFFSET.y
	end,
	
    getWorldCoordinatesOfChunk = function(self, cX, cY)
		local iX, iY = self:getImageCoordinatesOfChunk(cX, cY)
        return iX + INSET, iY + INSET
    end,

	getQuadFromMouseCoordinates = function(self)
		local mX, mY = self:getMousePositionFn()
		return self:getImageCoordinatesOfChunk(self:getChunkXY(mX, mY))
	end,

    drawChunkSelection = function(self, x, y)
        GRAFX:setColor(1, 1, 0, 0.7)
        GRAFX:rectangle("fill", x, y, 256, 256)
    end,

    drawChunkOutline = function(self, x, y)
        GRAFX:setColor(1, 1, 1)
        GRAFX:setLineWidth(3)
        GRAFX:rectangle("line", x - 2, y - 2, 260, 260)
    end,

    blitToScreen = function(self, x, y)
		self.yBlit = y
        GRAFX:blitToScreen(x, y, { 1, 1, 1 }, 0, 1, 1)
    end,

    --------------------------------------------------------------
    --              Specialized Update Functions                --
    --------------------------------------------------------------

    isInImageBounds = function(self, x, y)
        return x >= 0 and y >= 0 and x < self.image:getWidth() and y < self.image:getHeight()
    end,
    
	gainFocus = function(self) self.inFocus = true  end,
	loseFocus = function(self) self.inFocus = false end,
	hasFocus  = function(self) return self.inFocus  end,
	
    updateChunkVisibility = function(self, dt)
        self.isChunkVisible = not self:isScreenInMotion()

        self:updateScreenMotionDetection(dt)
    end,

    isScreenInMotion = function(self)
        return GRAFX:getX() ~= prevGraphics.x or GRAFX:getY() ~= prevGraphics.y or GRAFX:getScale() ~= prevGraphics.scale
    end,

    updateScreenMotionDetection = function(self, dt)
        prevGraphics.x, prevGraphics.y, prevGraphics.scale = GRAFX:getX(), GRAFX:getY(), GRAFX:getScale()
    end,

    keepImageInBounds = function(self)
        GRAFX:setX(math.min(0, math.max(GRAFX:getX(), (love.graphics:getWidth()  / GRAFX:getScale()) - self:getPageWidth())))
        GRAFX:setY(math.max(math.min(-self.yBlit / GRAFX:getScale(), GRAFX:getY()), (love.graphics.getHeight() / GRAFX:getScale()) - self:getPageHeight()))
	end,

    getPageWidth  = function(self) return self.image:getWidth()  + (INSET * 2) end,
    getPageHeight = function(self) return self.image:getHeight() + (INSET * 2) end,

	moveImage = function(self, deltaX, deltaY)
		GRAFX:moveImage(deltaX, deltaY)
	end,

	screenToImageCoordinates = function(self, screenX, screenY)
        return GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        GRAFX:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

    --------------------------------------------------------------
    --          Specialized Event Response Functions            --
    --------------------------------------------------------------

    getMousePositionFn = function(self)
		local mx, my = love.mouse.getPosition()
		return mx, my - self.yBlit
	end,

    resetMode = function(self)
        modes:reset()
    end,

    --------------------------------------------------------------
    --          Specialized Chunk Tagging Functions             --
    --------------------------------------------------------------

    tagChunk = function(self, chunkID, x, y)
        if self.chunkTags:isUnique(x, y) then
            table.insert(self.chunkTags, { x = x, y = y, chunkID = chunkID })
        end
    end,

    drawTags = function(self)
        GRAFX:setFontSize(64)
        
        for _, t in ipairs(self.chunkTags) do
            GRAFX:setColor(1, 1, 1, 0.6)
            GRAFX:rectangle("fill", t.x + INSET, t.y + INSET, 256, 256)
            GRAFX:setColor(0, 0, 0, 0.4)
            local numberWidth = GRAFX:getFontWidth("" .. t.chunkID) + 8
            GRAFX:rectangle("fill", t.x + 144 - (numberWidth / 2), t.y + 96, numberWidth, 64)
            GRAFX:setColor(1, 1, 1)
            GRAFX:printf("" .. t.chunkID, t.x + 16, t.y + 94, 256, "center")
            GRAFX:setColor(0, 0, 0)
            GRAFX:setLineWidth(3)
            GRAFX:rectangle("line", t.x + INSET, t.y + INSET, 256, 256)
        end
    end,
}
