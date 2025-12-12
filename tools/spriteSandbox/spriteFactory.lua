local NO_BUMP_ID = true

return ({
	spriteList = {},
	index      = 1,

	init = function(self)
		self:loadSprites()
		return self
	end,

	loadSprites = function(self)
		local directory = "tools/spriteSandbox/data/objects"
		local directoryItems = love.filesystem.getDirectoryItems(directory)
    	for _, v in ipairs(directoryItems) do
        	if string.sub(v, -3, -1) == "lua" then
                local fileName = string.sub(v, 1, -5)
                table.insert(self.spriteList, { name = fileName, sprite = nil })
            end
        end
    end,

    getFromCache = function(self, x, y)
    	local spriteInfo = self.spriteList[self.index]
    	if not spriteInfo.sprite then
    		spriteInfo.sprite = require("tools/spriteSandbox/sprite"):create("objects/" .. spriteInfo.name, x, y, NO_BUMP_ID)
    	end
    	return spriteInfo.sprite
    end,

    create = function(self, x, y)
    	local spriteInfo = self.spriteList[self.index]
        return require("tools/spriteSandbox/sprite"):create("objects/" .. spriteInfo.name, x, y)
    end,

    next = function(self)
    	self.index = self.index + 1
    	if self.index > #self.spriteList then self.index = 1 end
    end,

    prev = function(self)
    	self.index = self.index - 1
    	if self.index < 1 then self.index = #self.spriteList end
    end,
}):init()
