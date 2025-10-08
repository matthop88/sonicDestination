return {
	encode = function(self, mapData, params)
		local serializedData = "return {\n" .. self:encodeParams(params)
		for _, row in ipairs(mapData) do
			local rowString = "  { "
			for _, chunkID in ipairs(row) do
				rowString = rowString .. (string.rep(" ", 3 - string.len("" .. chunkID))) .. chunkID .. ", "
			end
			serializedData = serializedData .. rowString .. "},\n"
		end
		return serializedData .. "}\n"
	end,

	encodeParams = function(self, params)
		local paramString = ""
		for k, v in pairs(params) do
			paramString = paramString .. "  " .. k .. " = \"" .. v .. "\",\n"
		end
		return paramString
	end,
}
