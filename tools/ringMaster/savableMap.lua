return {
	create = function(self, srcImg, filename)
		return {
			srcImg   = srcImg,
			filename = filename,

			save = function(self, objList, objInfo)
				local dataString = self:construct(objList, objInfo)
				love.filesystem.createDirectory("resources/zones/maps")
				love.filesystem.write("resources/zones/maps/" .. self.filename, dataString)
			end,

			saveImage = function(self, imgData, imgName)
				love.filesystem.createDirectory("resources/zones/maps")
				return imgData:encode("png", imgName .. ".png")
			end,

			construct = function(self, objList, objInfo)
				local dataString = "return {\n"
				dataString = dataString .. "  sourceImage = \"" .. self.srcImg .. "\",\n"

				for _, obj in ipairs(objList) do
		        	dataString = dataString .. "  { obj = \"" .. objInfo.name .. "\", x = " .. obj.x .. ", y = " .. obj.y .. ", },\n"
		        end

		    	return dataString .. "}\n"
		    end,

		}
	end,
}
