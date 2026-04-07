local MUSIC_DATA = require("game/music/musicData")

return {
	create = function(self, params)
		local labelToKeyMap = {}
		local items = self:buildListItems(labelToKeyMap)
		
		local onMusicTrackSelected = params.onMusicTrackSelected

		local guiList = require("tools/lib/guiList/list"):create {
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 400,
			height = params.height or 400,
			items = items,
			fontSize = params.fontSize or 24,
			scrollSpeed = params.scrollSpeed or 1200,
			onItemSelected = function(listOrPane, item, index)
				listOrPane:setVisible(false)
				if onMusicTrackSelected then
					onMusicTrackSelected(item, index)
				end
			end,
		}
		
		return {
			draw = function(self)
				guiList:draw()
			end,
			
			update = function(self, dt)
				guiList:update(dt)
			end,
			
			handleMousePressed = function(self, mx, my)
				return guiList:handleMousePressed(mx, my)
			end,
			
			handleMouseReleased = function(self)
				guiList:handleMouseReleased()
			end,
			
			setVisible = function(self, visible)
				guiList:setVisible(visible)
			end,
			
			isVisible = function(self)
				return guiList.visible
			end,
			
			getListHeight = function(self)
				return guiList:getListHeight()
			end,
				
			setY = function(self, y)
				guiList:setY(y)
			end,

			getSelectedItem = function(self)
				local value, index = guiList:getSelectedItem()
				if index == 1 then return nil
				else return value end
			end,
		}
	end,
	
	buildListItems = function(self, labelToKeyMap)
		local items = {}
		
		-- Add "None" option
		table.insert(items, "None")
		
		-- Add separator
		table.insert(items, self:buildSeparator())
		
		-- Add music items
		local musicItems = self:buildMusicItems(labelToKeyMap)
		for _, item in ipairs(musicItems) do
			table.insert(items, item)
		end
		
		return items
	end,
	
	buildSeparator = function(self)
		local RECTANGLE_ITEM = require("tools/lib/guiList/rectangleItem")
		return RECTANGLE_ITEM:create {
			color = { 0.5, 0.5, 0.5 },
			width = 390,
			height = 5,
			notSelectable = true,
		}
	end,
	
	buildMusicItems = function(self, labelToKeyMap)
		local items = {}
		local musicLabels = {}
		
		for musicKey, musicInfo in pairs(MUSIC_DATA) do
			if musicInfo.label then
				table.insert(musicLabels, musicInfo.label)
				labelToKeyMap[musicInfo.label] = musicKey
			end
		end
		table.sort(musicLabels)
		
		for _, label in ipairs(musicLabels) do
			table.insert(items, label)
		end
		
		return items
	end,
}
