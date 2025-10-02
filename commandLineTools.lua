return {
	listParams = function(self, args)
		local params = self:getParams(args)

		for k, v in pairs(params) do
			print(k .. " = " .. v)
		end
	end,

	getParams = function(self, args)
		local key = nil
		params = {}

		for n, arg in ipairs(args) do
			if key ~= nil then
				params[key] = arg
				key = nil
			elseif string.sub(arg, 1, 2) == "--" then
				key = string.sub(arg, 3, -1)
			elseif string.sub(arg, 1, 1) == "-" then
				key = string.sub(arg, 2, -1)
			end

		end

		return params
	end,
}
