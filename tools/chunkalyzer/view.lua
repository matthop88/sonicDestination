local IMAGE

local TALLY_SOUND = require("tools/chunkalyzer/sounds/tally")

local CHUNKALYZATION_DONE = false
local PIPELINE

return {
	mapMode      = false,
	repoMode     = false,
	showMapAlpha = true,

	chunkRepo = {
		add = function(self, c)
			local quad = love.graphics.newQuad(c.x, c.y, 256, 256, IMAGE:getWidth(), IMAGE:getHeight())
			local cID = #self + 1
			local X = (((cID - 1) % 9) * 272) + 16
			local Y = (math.floor((cID - 1) / 9) * 272) + 16
			table.insert(self, { x = c.x, y = c.y, X = X, Y = Y, quad = quad, numberAlpha = 1 })
			return #self
		end,
	},

	init = function(self, img, model)
		IMAGE   = img
		self.model = model

		self:initViewModel()

		self.GRAFX = require("tools/lib/graphics"):create()

		self.pageWidth  = ((IMAGE:getWidth()  / 256) * 272) + 32
		self.pageHeight = ((IMAGE:getHeight() / 256) * 272) + 32

		return self
	end,

	initViewModel = function(self)
		self.viewModel = {}

		local cX, cY = 0, 0

		for _, c in ipairs(self.model:getChunks()) do
			local quad = love.graphics.newQuad(c.x, c.y, 256, 256, IMAGE:getWidth(), IMAGE:getHeight())
			local cX, cY = math.floor(c.x / 256), math.floor(c.y / 256)
			table.insert(self.viewModel, { alpha = 1, mapX = c.x, mapY = c.y, x = (cX * 272) + 16, origX = (cX * 272) + 16, y = (cY * 272) + 16, origY = (cY * 272) + 16, quad = quad, mapOverlayAlpha = 0.9 })
		end
	end,

	getChunkRepo = function(self) return self.chunkRepo end,

	draw = function(self)
		self.GRAFX:setColor(1, 1, 1)
		if     self.mapMode   then self:drawMap()
		elseif self.repoMode  then self:drawRepo()
		else                       self:drawChunks()        end
	end,

	drawMap = function(self)
		local mx, my = self:screenToImageCoordinates(love.mouse.getPosition())

		local highlightRect = nil

		for _, c in ipairs(self.viewModel) do
			if self:isChunkOnScreen(c.mapX, c.mapY) then
				self.GRAFX:setColor(1, 1, 1)
				if c.id and self.chunkRepo[c.id] then
					self.GRAFX:draw(IMAGE, self.chunkRepo[c.id].quad, c.mapX, c.mapY, 0, 1, 1)
				else
					self.GRAFX:draw(IMAGE, c.quad, c.mapX, c.mapY, 0, 1, 1)
				end
				if self:ptInChunk(mx, my, c.mapX, c.mapY) then
					highlightRect = { x = c.mapX - 3, y = c.mapY - 3, w = 262, h = 262 }
				end
				
				local mapOverlayAlpha = c.mapOverlayAlpha
				if not self.showMapAlpha then mapOverlayAlpha = 0.33 end
				
				if c.id then
					self.GRAFX:setColor(0.56, 0.84, 1, mapOverlayAlpha - 0.33)
					self.GRAFX:rectangle("fill", c.mapX, c.mapY, 256, 256)
					self.GRAFX:setColor(1, 1, 1, mapOverlayAlpha + 0.2)
					self.GRAFX:setFontSize(96)
					self.GRAFX:printf("" .. c.id, c.mapX + 6, c.mapY + 84, 256, "center")
					self.GRAFX:setColor(0, 0, 0, mapOverlayAlpha - 0.33)
					self.GRAFX:setLineWidth(5)
					self.GRAFX:rectangle("line", c.mapX + 3, c.mapY + 3, 250, 250)
				end
			end
		end 

		if highlightRect then
			self.GRAFX:setColor(1, 1, 0)
			self.GRAFX:setLineWidth(5)
			self.GRAFX:rectangle("line", highlightRect.x, highlightRect.y, highlightRect.w, highlightRect.h)
		end
	end,

	drawRepo = function(self)
		local mx, my = self:screenToImageCoordinates(love.mouse.getPosition())

		for cID, c in ipairs(self.chunkRepo) do
			if self:isChunkOnScreen(c.X, c.Y) then
				self.GRAFX:setColor(1, 1, 1)
				self.GRAFX:draw(IMAGE, c.quad, c.X, c.Y, 0, 1, 1)
				self.GRAFX:setFontSize(96)
				self.GRAFX:setColor(0, 0, 0, 0.4 * c.numberAlpha)
				local numberWidth = self.GRAFX:getFontWidth("" .. cID) + 8
				self.GRAFX:rectangle("fill", c.X + 134 - (numberWidth / 2), c.Y + 86, numberWidth, 96)
				self.GRAFX:setColor(1, 1, 1, c.numberAlpha)
				self.GRAFX:printf("" .. cID, c.X + 6, c.Y + 84, 256, "center")
				if self:ptInChunk(mx, my, c.X, c.Y) then
					self.GRAFX:setColor(1, 1, 0, c.alpha)
					self.GRAFX:setLineWidth(5)
					self.GRAFX:rectangle("line", c.X - 3, c.Y - 3, 262, 262)
				end
			end
		end
	end,

	drawChunks = function(self)
		local mx, my = self:screenToImageCoordinates(love.mouse.getPosition())

		for _, c in ipairs(self.viewModel) do
			if c.alpha > 0 and (not c.id or (c.id and not c.isUnique)) then
				self.GRAFX:setColor(1, 1, 1, c.alpha)
				self.GRAFX:draw(IMAGE, c.quad, c.x, c.y, 0, 1, 1)
				if self:ptInChunk(mx, my, c.x, c.y) then
					self.GRAFX:setColor(1, 1, 0, c.alpha)
					self.GRAFX:setLineWidth(5)
					self.GRAFX:rectangle("line", c.x - 3, c.y - 3, 262, 262)
				end
			end
		end

		for _, c in ipairs(self.viewModel) do
			if c.id and c.isUnique and self:isChunkOnScreen(c.x, c.y) then
				self.GRAFX:setColor(1, 1, 1, c.alpha)
				self.GRAFX:draw(IMAGE, c.quad, c.x, c.y, 0, 1, 1)
				self.GRAFX:setColor(1, 1, 1, c.highlightAlpha)
				self.GRAFX:rectangle("fill", c.x, c.y, 256, 256)
				self.GRAFX:setFontSize(96)
				self.GRAFX:setColor(0, 0, 0, 0.4 * c.numberAlpha)
				local numberWidth = self.GRAFX:getFontWidth("" .. c.id) + 8
				self.GRAFX:rectangle("fill", c.x + 134 - (numberWidth / 2), c.y + 86, numberWidth, 96)
				self.GRAFX:setColor(1, 1, 1, c.numberAlpha)
				self.GRAFX:printf("" .. c.id, c.x + 6, c.y + 84, 256, "center")
				if self:ptInChunk(mx, my, c.x, c.y) then
					self.GRAFX:setColor(1, 1, 0, c.alpha)
					self.GRAFX:setLineWidth(5)
					self.GRAFX:rectangle("line", c.x - 3, c.y - 3, 262, 262)
				end
			end
		end
	end,

	ptInChunk = function(self, x, y, rX, rY)
		return x >= rX and x <= rX + 256 and y >= rY and y <= rY + 256
	end,

	isChunkOnScreen = function(self, cX, cY)
		local leftX, topY     = self:screenToImageCoordinates(0, 0)
		local rightX, bottomY = self:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

		return cX < rightX and cX + 256 > leftX and cY < bottomY and cY + 256 > topY
	end,

	update = function(self, dt)
		if     self.mapMode  then self:updateMap(dt)
		elseif self.repoMode then self:updateRepo(dt)
		else                      self:updateChunks(dt) end
	end,

	updateRepo = function(self, dt)
		local mx, my = self:screenToImageCoordinates(love.mouse.getPosition())

		for _, c in ipairs(self.chunkRepo) do
			if self:ptInChunk(mx, my, c.X, c.Y) then
				c.numberAlpha = math.max(0.33, c.numberAlpha - (2 * dt))
			else
				c.numberAlpha = math.min(1, c.numberAlpha + (1 * dt))
			end
		end
	end,

	updateMap = function(self, dt)
		local mx, my = self:screenToImageCoordinates(love.mouse.getPosition())

		for _, c in ipairs(self.viewModel) do
			if c.clicked then
				c.mapOverlayAlpha = math.max(0.33, c.mapOverlayAlpha - (3 * dt))
			end
		end
	end,

	updateChunks = function(self, dt)
		for _, c in ipairs(self.viewModel) do
			if c.id then
				if c.isUnique then self:updateUniqueChunk(c, dt)
				else               self:updateNonUniqueChunk(c, dt)  end
			end
		end

		if self:areChunksDoneMoving() and not CHUNKALYZATION_DONE then
			self:onChunkalyzationComplete()
		end
	end,

	setPipeline = function(self, pipeline)
		PIPELINE = pipeline
	end,

	areChunksDoneMoving = function(self)
		if not PIPELINE:isComplete() then
			return false
		end
		local n = 0
		for _, c in ipairs(self.viewModel) do
			if c.isUnique then
				n = n + 1
				if c.targetX then
					if c.targetX ~= c.x and c.targetY ~= c.y then
						return false
					end
				end
			end
		end
		return true
	end,

	onChunkalyzationComplete = function(self)
		print("Chunkalyzation complete in " .. PIPELINE:getTotalElapsedTime() .. " seconds.")
		printToReadout("Press 'return' to save to file.")
		TALLY_SOUND:play()
		self:setRepoMode()
		CHUNKALYZATION_DONE = true
	end,

	updateUniqueChunk = function(self, c, dt)
		c.numberAlpha = math.min(1, c.numberAlpha + (1 * dt))
					
		if not c.targetChunk or c.targetChunk.isMoved then
			c.x = c.x + (c.targetX - c.origX) * (2 * dt)
			if math.abs(c.origX - c.x) > math.abs(c.origX - c.targetX) then
				c.x = c.targetX
			end
			c.y = c.y + (c.targetY - c.origY) * (2 * dt)
			if math.abs(c.origY - c.y) > math.abs(c.origY - c.targetY) then
				c.y = c.targetY
			end
			c.isMoved = true
		end
		if c.x == c.targetX and c.y == c.targetY then
			c.highlightAlpha = math.max(0, c.highlightAlpha - (0.5 * dt))
		else
			c.highlightAlpha = math.min(0.5, c.highlightAlpha + (0.5 * dt))
		end
	end,

	updateNonUniqueChunk = function(self, c, dt)
		c.alpha = math.max(0, c.alpha - (1 * dt))
		if c.alpha == 0 then
			c.isMoved = true
		end
	end,

	handleKeypressed = function(self, key)
		if key == "escape" then self:toggleMapAlpha() end
	end,

	handleMousepressed = function(self, mx, my)
		if self.mapMode and self.repoMode then
			mx, my = self:screenToImageCoordinates(mx, my)

			for _, c in ipairs(self.viewModel) do
				if self:ptInChunk(mx, my, c.mapX, c.mapY) then
					c.clicked = true
				end
			end
		end
	end,

	tagChunk = function(self, chunk)
		for _, c in ipairs(self.viewModel) do
			if c.mapX == chunk.x and c.mapY == chunk.y then 
				c.id = chunk.repoChunkID
				c.targetX = (((chunk.repoChunkID - 1) % 9) * 272) + 16
				c.targetY = (math.floor((chunk.repoChunkID - 1) / 9) * 272) + 16
				c.isUnique = not chunk.isDuplicate 
				c.highlightAlpha = 0
				c.numberAlpha = 0
				
				for _, k in ipairs(self.viewModel) do
					if k.origX == c.targetX and k.origY == c.targetY then
						c.targetChunk = k
					end
				end
			end
		end

		self:updatePageWidthAndHeight()
	end,

	updatePageWidthAndHeight = function(self)
		self.pageWidth, self.pageHeight = self:calculatePageWidthAndHeight()
	end,

	calculatePageWidthAndHeight = function(self)
		local width, height = 0, 0
		for _, c in ipairs(self.viewModel) do
			width, height = self:updateWidthAndHeightBasedOnSingleChunk(c, width, height)
		end
		return width, height
	end,

	updateWidthAndHeightBasedOnSingleChunk = function(self, c, width, height)
		if c.targetX and c.targetY then
			width  = math.max(width,  c.targetX + 304)
			height = math.max(height, c.targetY + 304)
		else
			width  = math.max(width,  c.x + 304)
			height = math.max(height, c.y + 304)
		end
		return width, height
	end,
	
	toggleMapMode  = function(self) self.mapMode      = not self.mapMode      end,
	toggleMapAlpha = function(self) self.showMapAlpha = not self.showMapAlpha end,
	setRepoMode    = function(self) self.repoMode     = true                  end,

	getPageWidth = function(self)
		if self.mapMode then return IMAGE:getWidth()
		else                 return self.pageWidth  end
	end,

	getPageHeight = function(self)
		if self.mapMode then return IMAGE:getHeight()
		else                 return self.pageHeight  end
	end,

    keepImageInBounds = function(self)
        self.GRAFX:setX(math.min(0, math.max(self.GRAFX:getX(), (love.graphics:getWidth()  / self.GRAFX:getScale()) - self:getPageWidth())))
        self.GRAFX:setY(math.min(0, math.max(self.GRAFX:getY(), (love.graphics:getHeight() / self.GRAFX:getScale()) - self:getPageHeight())))
    end,

    moveImage = function(self, deltaX, deltaY)
	    self.GRAFX:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return self.GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
    	if not self.repoMode then
    		if (deltaScale < 0 and self.GRAFX:getScale() >= 0.15) or (deltaScale > 0 and self.GRAFX:getScale() <= 3.0) then
				self.GRAFX:adjustScaleGeometrically(deltaScale)
			end
		else
			self.GRAFX:adjustScaleGeometrically(deltaScale)
		end
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        self.GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

    save = function(self, chunkImageName, mapLayoutName)
    	if self.repoMode then
    		self:saveChunkImage(chunkImageName)
    		self:saveMapLayout(mapLayoutName, chunkImageName)
    	end
    end,

	saveChunkImage = function(self, chunkImageName)
    	local savableChunkImage = require("tools/chunkalyzer/savableChunkImage"):create(self.chunkRepo, IMAGE)
    	local fileData = savableChunkImage:save(chunkImageName)

    	printToReadout("Changes have been saved (" .. fileData:getSize() .. " bytes.)")
    	print("Saved to " .. love.filesystem.getSaveDirectory())
    end,

    saveMapLayout = function(self, mapLayoutName, chunkImageName)
    	local savableMapLayout = require("tools/chunkalyzer/savableMapLayout"):create(self.viewModel)
    	savableMapLayout:save(mapLayoutName, chunkImageName)
    end,
}
