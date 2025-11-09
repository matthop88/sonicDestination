return {
	create = function(self, srcImg, filename)
		return {
			srcImg   = srcImg,
			filename = filename,

			save = function(self, objList)
				local dataString = self:construct(objList)
				print(dataString)
			end,

			construct = function(self, objList)
				local dataString = "return {\n"
				dataString = dataString .. "  sourceImage = \"" .. self.srcImg .. "\",\n"

				for _, obj in ipairs(objList) do
		        	dataString = dataString .. "  { obj = \"ring\", x = " .. obj.x .. ", y = " .. obj.y .. ", },\n"
		        end

		    	return dataString .. "}\n"
		    end,

		}
	end,
}
