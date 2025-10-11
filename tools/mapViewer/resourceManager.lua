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
			self:loadChunkData(__PARAMS["chunkDataIn"])
			self:constructMap()
		else
			-- throw error
		end
		
		return self
	end,

	loadMapData = function(self)
		self.mapData = dofile("resources/zones/maps/" .. __PARAMS["mapIn"] .. ".lua")

		if self.mapData.chunksDataName then
			self:loadChunkData(self.mapData.chunksDataName)
		elseif self.mapData.chunksImageName then
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

	loadChunkData = function(self, chunksDataName)
		local chunksData = dofile("resources/zones/chunks/" .. chunksDataName .. ".lua")
		local tilesImgPath = "resources/zones/tiles/" .. chunksData.tilesImageName .. ".png"
		local tilesImg = self:loadImgFromPath(tilesImgPath)

		self.chunkImg = require("tools/mapViewer/chunkImageConstructor"):create(chunksData, tilesImg)
	end,

	refresh = function(self)
		self:init()
	end,
	
}):init()
