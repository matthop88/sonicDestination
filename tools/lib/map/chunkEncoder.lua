return {
	encode = function(self, chunksData)
		local serializedData = "return {\n" .. self:encodeParams(chunksData)
		for _, chunk in ipairs(chunksData) do
			local chunkString = "  { chunkID = " .. chunk.chunkID .. ",\n"
			for _, chunkRow in ipairs(chunk) do
				chunkString = chunkString .. "    { "
				for _, tileID in ipairs(chunkRow) do
					chunkString = chunkString .. (string.rep(" ", 3 - string.len("" .. tileID))) .. tileID .. ", "
				end
				if chunkRow.S == nil or not self:solidsExistForRow(chunkRow) then chunkString = chunkString .. "},\n"
				else                      
					chunkString = chunkString .. "\n"  
					chunkString = chunkString .. "  S={ "
					for _, solidCode in ipairs(chunkRow.S) do
						chunkString = chunkString .. (string.rep(" ", 3 - string.len("" .. solidCode))) .. solidCode .. ", "
					end
					chunkString = chunkString .. "}},\n"  
				end
			end
			serializedData = serializedData .. chunkString .. "  },\n"
		end
		return serializedData .. "}\n"
	end,

	encodeParams = function(self, params)
		local paramString = ""
		for k, v in pairs(params) do
			if type(v) == "string" then
				paramString = paramString .. "  " .. k .. " = \"" .. v .. "\",\n"
			end
		end
		return paramString
	end,

	solidsExistForRow = function(self, chunkRow)
		for _, s in ipairs(chunkRow.S) do 
			if s ~= 0 then return true end
		end
	end,
}
