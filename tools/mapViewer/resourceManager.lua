return ({
	mapData  = nil,
	chunkImg = nil,

	getMapData = function(self)
		return self.mapData
	end,

	getChunkImage = function(self)
		return self.chunkImg
	end,

	init = function(self)
		if __PARAMS["mapIn"] then
			self:loadMapData()
		elseif __PARAMS["chunkImageIn"] then
			self:loadChunkImgAndConstructMap()
		else
			-- throw error
		end
		
		return self
	end,

	loadMapData = function(self)
		self.mapData = dofile("resources/zones/maps/" .. __PARAMS["mapIn"] .. ".lua")

		if self.mapData.chunksImageName then
			local chunkImgPath = "resources/zones/chunks/" .. self.mapData.chunksImageName .. ".png"
			self.chunkImg = love.graphics.newImage(chunkImgPath)
			self.chunkImg:setFilter("nearest", "nearest")
		else
			-- do something else
		end
	end,

	loadChunkImgAndConstructMap = function(self)
		local chunkImgPath = "resources/zones/chunks/" .. __PARAMS["chunkImageIn"] .. ".png"
		self.chunkImg = love.graphics.newImage(chunkImgPath)
		self:constructMap()
	end,

	constructMap = function(self)
		local width, height = self:calculateMapDimensions()

		self:createMapData(width, height)

	end,	

	calculateMapDimensions = function(self)
		local width  = math.floor(self.chunkImg:getWidth() / 256)
		local height = math.floor(self.chunkImg:getHeight() / 256)

		return width, height
	end,

	createMapData = function(self, width, height)
		self.mapData = {}

		local chunkID = 1

		for i = 1, height do 
			local currentRow = {}
				
			for j = 1, width do
				table.insert(currentRow, chunkID)
				chunkID = chunkID + 1
			end
			table.insert(self.mapData, currentRow)
		end
	end,

	refresh = function(self)
		if __PARAMS["mapIn"] then
			self:loadMapData()
		end
	end,
	
}):init()
