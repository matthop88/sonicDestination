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
		elseif __PARAMS["chunkDataIn"] then
			self:loadChunkDataAndConstructMap(__PARAMS["chunkDataIn"])
		else
			-- throw error
		end
		
		return self
	end,

	loadMapData = function(self)
		self.mapData = dofile("resources/zones/maps/" .. __PARAMS["mapIn"] .. ".lua")

		if self.mapData.chunksImageName then
			local chunkImgPath = "resources/zones/chunks/" .. self.mapData.chunksImageName .. ".png"
			self.chunkImg = self:loadImgFromPath(chunkImgPath)
		else
			-- do something else
		end
	end,

	loadChunkImgAndConstructMap = function(self)
		local chunkImgPath = "resources/zones/chunks/" .. __PARAMS["chunkImageIn"] .. ".png"
		self.chunkImg = self:loadImgFromPath(chunkImgPath)
		self:constructMap()
	end,

	loadImgFromPath = function(self, imgPath)
		local img = love.graphics.newImage(imgPath)
		img:setFilter("nearest", "nearest")
		return img
	end,

	constructMap = function(self)
		self.mapData = require("tools/mapViewer/mapConstructor"):create(self.chunkImg)
	end,

	loadChunkDataAndConstructMap = function(self, chunksDataName)
		self.chunksData = dofile("resources/zones/chunks/" .. chunksDataName .. ".lua")
		self.tilesImgPath = "resources/zones/tiles/" .. chunksData.tilesImageName .. ".png"
		self.tilesImg = self:loadImgFromPath(tilesImgPath)

		-- Now construct an image using a chunks constructor object
	end,

	refresh = function(self)
		if __PARAMS["mapIn"] then
			self:loadMapData()
		end
	end,
	
}):init()
