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

			validateParams = function(self, args)
				local params = self:getParams(args)

				local missingParams = self:findMissingParams(params)
				
				if #missingParams > 0 then
					print("\nERROR! The following parameters are missing:")
					for _, p in ipairs(missingParams) do
						local s = p
						if self.schema.COMMANDS[p].shortcut then
							s = s .. " (shortcut: '-" .. self.schema.COMMANDS[p].shortcut .. "')"
						end
						print(s)
					end
					print("\n")
					love.event.quit()
				else
					return true
				end
			end,

			findMissingParams = function(self, params)
				local missingParams = {}

				for k, v in pairs(self.schema.COMMANDS) do
					if v.required and params[k] == nil then
						table.insert(missingParams, k)
					end
				end
				
				return missingParams
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

			generateHelp = function(self)
				print("\n\nAccepted commands include:")
				print("  --help,                      -h  Show this help.")

				local keys = {}
				for k, v in pairs(self.schema.COMMANDS) do
					table.insert(keys, k)
				end

				table.sort(keys)

				for _, k in pairs(keys) do
					local v = self.schema.COMMANDS[k]
					print("  --" .. k .. "," .. string.rep(" ", 20 - string.len(k)) .. "      -" .. v.shortcut .. "  " .. v.description)
				end
				print("\n")
				love.event.quit()
			end,
		}
	end,

}
