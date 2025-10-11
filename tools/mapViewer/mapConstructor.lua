return {
	create = function(self, chunkImg)
		return ({
			chunkImg = chunkImg,
			mapData  = nil,

			constructMap = function(self)
				local width, height = self:calculateMapDimensions()

				self:createMapData(width, height)

				return self.mapData
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

			getMapData = function(self)
				return self.mapData
			end,
		}):constructMap()
	end,
}
