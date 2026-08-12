local guiList = require("tools/lib/guiList/list")

local EFFECT_OPTIONS = {
	"None",
	"Reverb",
	"Echo",
}

return {
	create = function(self, params)
		local onEffectSelected = params.onEffectSelected
		
		local guiListObj = guiList:create {
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 400,
			height = params.height or 200,
			fontSize = params.fontSize or 24,
			items = EFFECT_OPTIONS,
			onItemSelected = function(listOrPane, item, index)
				listOrPane:setVisible(false)
				if onEffectSelected then
					onEffectSelected(item, index)
				end
			end,
		}
		
		return {
			draw = function(self)
				guiListObj:draw()
			end,
			
			update = function(self, dt)
				guiListObj:update(dt)
			end,
			
			handleMousePressed = function(self, mx, my)
				return guiListObj:handleMousePressed(mx, my)
			end,

			handleKeyPressed = function(self, key)
				return guiListObj:handleKeyPressed(key)
			end,
			
			setVisible = function(self, visible)
				guiListObj:setVisible(visible)
			end,
			
			isVisible = function(self)
				return guiListObj.visible
			end,
			
			getListHeight = function(self)
				return guiListObj:getListHeight()
			end,
			
			setY = function(self, y)
				guiListObj:setY(y)
			end,
		}
	end,
}
