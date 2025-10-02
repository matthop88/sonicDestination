return {
	listArgs = function(self, args)
		key = nil
		params = {}

		for n, arg in ipairs(args) do
			if key ~= nil then
				params[key] = arg
				key = nil
			elseif string.sub(arg, 1, 1) == "-" then
				key = string.sub(arg, 2, -1)
			end

		end

		for k, v in pairs(params) do
			print(k .. " = " .. v)
		end

	end,
}
