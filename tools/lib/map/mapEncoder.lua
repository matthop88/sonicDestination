return {
	encode = function(self, mapData)
		local serializedData = "return {\n" .. self:encodeParams(mapData)
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
			if type(v) == "string" then
				paramString = paramString .. "  " .. k .. " = \"" .. v .. "\",\n"
			end
		end
		return paramString
	end,
}
