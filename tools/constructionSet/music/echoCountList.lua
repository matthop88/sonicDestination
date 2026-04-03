local guiList = require("tools/lib/guiList/list")

local ECHO_COUNT_OPTIONS = {
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
}

return {
	create = function(self, params)
		local onEchoCountSelected = params.onEchoCountSelected
		
		local guiListObj = guiList:create {
			x = params.x,
			y = params.y,
			width = params.width or 200,
			maxHeight = params.maxHeight or 400,
			items = ECHO_COUNT_OPTIONS,
			onItemSelected = function(listOrPane, item, index)
				listOrPane:setVisible(false)
				if onEchoCountSelected then
					onEchoCountSelected(item, index)
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
