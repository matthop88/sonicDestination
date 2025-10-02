local getSchema = function(path)
	local cmdSchema
	local status, err = pcall(function() cmdSchema = require(path .. "/cmdSchema") end)

	if status == true then
		return cmdSchema
	else
		print("XXX Command Schema not found for path " .. path .. "!")
		return nil
	end
end

return {
	create = function(self, appDirectory)
		return {
			schema = getSchema(appDirectory),

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
					if     string.sub(arg, 1, 2) == "--" then
						key = string.sub(arg, 3, -1)
						params[key] = true
					elseif string.sub(arg, 1, 1) == "-" then
						key = string.sub(arg, 2, -1)
						params[key] = true
					elseif key ~= nil then
						params[key] = arg
						key = nil
					end
				end

				return self:transformParams(params)
			end,

			transformParams = function(self, params)
				params2 = {}
				for k, v in pairs(params) do
					if string.len(k) == 1 then
						local fullCmd = self:expandShortcut(k)
						if fullCmd ~= nil then
							params2[fullCmd] = v
						else
							params2[k] = v
						end
					else
						params2[k] = v
					end
				end

				return params2
			end,

			expandShortcut = function(self, shortcut)
				for k, v in pairs(self.schema.COMMANDS) do
					if v.shortcut == shortcut then return k end
				end
			end,
		}
	end,

}
