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
        	local fileName = string.sub(v, 1, -5)
        	table.insert(self.spriteList, fileName)
        end
    end,

    create = function(self, x, y)
    	return require("tools/spriteSandbox/sprite"):create("objects/" .. self.spriteList[self.index], x, y)
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
