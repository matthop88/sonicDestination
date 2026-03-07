return {
	create = function(self, params)
		return ({
			graphics = require("tools/lib/graphics"):create(),
			soundObject = params.soundObject,
			samplingRate = params.samplingRate or 64,
			marginLeft = params.marginLeft or 100,
			sampleData = {},

			init = function(self)
				self:moveImage(self.marginLeft, 0)
				return self
			end,
			
			analyzeData = function(self)
				local min, max = 0, 0
				local indexInChunk = 0
				local NUM_SAMPLES = self.soundObject:getSampleCount()

				for i = 0, NUM_SAMPLES - 1 do
					local currentSample = self.soundObject:getSample(i) * 256
					min = math.min(currentSample, min)
					max = math.max(currentSample, max)
					indexInChunk = indexInChunk + 1
					if indexInChunk >= self.samplingRate or indexInChunk >= NUM_SAMPLES - 1 then
						table.insert(self.sampleData, { min = min, max = max })
						indexInChunk, min, max = 0, 0, 0
					end
				end
			end,

			draw = function(self)
				-- Draw waveform
				for k, v in ipairs(self.sampleData) do
					local screenX, _ = self:imageToScreenCoordinates(k, 0)
					
					love.graphics.setColor(1, 1, 1)
					love.graphics.line(screenX, 256 - v.max, screenX, 256 - v.min)
				end

				-- Draw cursor line
				love.graphics.setColor(0, 1, 0)
				local mx = self:getConstrainedMouseX()
				love.graphics.line(mx, 0, mx, 512)
			end,

			getConstrainedMouseX = function(self)
				local mx, _ = love.mouse.getPosition()
				return math.min(math.max(mx, self.marginLeft), self.marginLeft + #self.sampleData)
			end,

			getSampleXFromMouseX = function(self)
				local mx, my = love.mouse.getPosition()
				local imageX, _ = self:screenToImageCoordinates(mx, my)
				local relativeX = imageX - self.marginLeft
				return math.max(0, math.min(relativeX * self.samplingRate, self.soundObject:getSampleCount() - 1))
			end,

			---------------------- Graphics Object Methods ------------------------

		    moveImage = function(self, deltaX, deltaY)
		        self.graphics:moveImage(deltaX / self.graphics:getScale(), deltaY / self.graphics:getScale())
		        
		        -- Constrain left scrolling
		        local currentX = self.graphics:getX()
		        if currentX > self.marginLeft then
		            self.graphics:setX(self.marginLeft)
		        end
		    end,

		    screenToImageCoordinates = function(self, screenX, screenY)
		        return self.graphics:screenToImageCoordinates(screenX, screenY)
		    end,

		    imageToScreenCoordinates = function(self, imageX, imageY)
		        return self.graphics:imageToScreenCoordinates(imageX, imageY)
		    end,

		    adjustScaleGeometrically = function(self, deltaScale)
		        self.graphics:adjustScaleGeometrically(deltaScale)
		    end,

		    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
		        self.graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
		    end,
		}):init()
	end,
}
