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
				chunkString = chunkString .. "},\n"
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
}
