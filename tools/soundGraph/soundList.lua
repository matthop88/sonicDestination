local SOUND_DATA = require("tools/soundGraph/soundData")
local MUSIC_DATA = require("tools/soundGraph/musicData")

return {
	buildListItems = function(self, labelToKeyMap)
		local items = {}
		
		-- Add sound items
		local soundItems = self:buildSoundItems(labelToKeyMap)
		for _, item in ipairs(soundItems) do
			table.insert(items, item)
		end
		
		-- Add separator
		table.insert(items, self:buildSeparator())
		
		-- Add music items
		local musicItems = self:buildMusicItems(labelToKeyMap)
		for _, item in ipairs(musicItems) do
			table.insert(items, item)
		end
		
		return items
	end,
	
	buildSoundItems = function(self, labelToKeyMap)
		local items = {}
		local soundLabels = {}
		
		for soundKey, soundInfo in pairs(SOUND_DATA) do
			table.insert(soundLabels, soundInfo.label)
			labelToKeyMap[soundInfo.label] = soundKey
		end
		table.sort(soundLabels)
		
		for _, label in ipairs(soundLabels) do
			table.insert(items, label)
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
			table.insert(musicLabels, musicInfo.label)
			labelToKeyMap[musicInfo.label] = musicKey
		end
		table.sort(musicLabels)
		
		for _, label in ipairs(musicLabels) do
			table.insert(items, label)
		end
		
		return items
	end,
	
	create = function(self, params)
		local onSoundSelected = params.onSoundSelected
		
		-- Map from display label to original key
		local labelToKeyMap = {}
		
		local soundList = {
			list = nil,
			labelToKeyMap = labelToKeyMap,
			
			-- Delegate methods to the underlying list
			draw = function(self)
				self.list:draw()
			end,
			
			update = function(self, dt)
				self.list:update(dt)
			end,
			
			handleMousePressed = function(self, mx, my)
				return self.list:handleMousePressed(mx, my)
			end,
			
			handleMouseReleased = function(self)
				self.list:handleMouseReleased()
			end,
			
			setVisible = function(self, visible)
				self.list:setVisible(visible)
			end,
			
			getSoundKeyFromLabel = function(self, label)
				return self.labelToKeyMap[label]
			end,
			
			getSoundInfo = function(self, soundKey)
				return SOUND_DATA[soundKey] or MUSIC_DATA[soundKey]
			end,
			
			isMusicTrack = function(self, soundKey)
				return MUSIC_DATA[soundKey] ~= nil
			end,
		}
		
		-- Create the actual list widget
		soundList.list = require("tools/lib/guiList/list"):create {
			x = params.x or (1280 - 400) / 2,
			y = params.y or (512 - 400) / 2,
			width = params.width or 400,
			height = params.height or 400,
			fontSize = params.fontSize or 28,
			scrollSpeed = params.scrollSpeed or 1200,
			items = self:buildListItems(labelToKeyMap),
			onItemSelected = function(listOrPane, label, index)
				local soundKey = labelToKeyMap[label]
				if soundKey and onSoundSelected then
					onSoundSelected(soundKey, label, index)
				end
				listOrPane:setVisible(false)
			end,
		}
		
		return soundList
	end,
}
