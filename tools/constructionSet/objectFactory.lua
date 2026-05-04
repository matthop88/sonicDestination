local BADNIK_TEMPLATE = require("tools/constructionSet/templates/badnikTemplate")
local ITEM_TEMPLATE   = require("tools/constructionSet/templates/itemTemplate")
local PLAYER_TEMPLATE = require("tools/constructionSet/templates/playerTemplate")

local BADNIK          = require("tools/constructionSet/templates/badnik")
local ITEM            = require("tools/constructionSet/templates/item")
local PLAYER          = require("tools/constructionSet/templates/player")

return {
	library = {
		sonic1 = {
			name       = "sonic1",
			spritePath = "sonic1",
			template   = PLAYER_TEMPLATE,
			object     = PLAYER,
		},
		sonic2 = {
			name       = "sonic2",
			spritePath = "sonic2",
			template   = PLAYER_TEMPLATE,
			object     = PLAYER,
		},
		motobug = {
			name       = "motobug",
			spritePath = "objects/motobug",
			template   = BADNIK_TEMPLATE,
			object     = BADNIK,
		},
		patabata = {
			name       = "patabata",
			spritePath = "objects/patabata",
			template   = BADNIK_TEMPLATE,
			object     = BADNIK,
		},
		tamabboh = {
			name       = "tamabboh",
			spritePath = "objects/tamabboh",
			template   = BADNIK_TEMPLATE,
			object     = BADNIK,
		},
		ring = {
			name       = "ring",
			spritePath = "objects/ring",
			template   = ITEM_TEMPLATE,
			object     = ITEM,
		},
		giantRing = {
			name       = "giantRing",
			spritePath = "objects/giantRing",
			template   = ITEM_TEMPLATE,
			object     = ITEM,
		},
		bigBall = {
			name       = "bigBall",
			spritePath = "objects/bigBall",
			template   = ITEM_TEMPLATE,
			object     = ITEM,
		},
	},

	getByName = function(self, name)
		return self.library[name]
	end,

	createTemplate = function(self, name, width, height)
		local info = self:getByName(name)
		return info.template:create(info.name, info.spritePath, width, height)
	end,

	createObject = function(self, name, xFlip)
		local info = self:getByName(name)
		if xFlip == true then xFlip = -1
		else                  xFlip =  1 end
		
		return info.object:create(info.name, info.spritePath, nil, nil, xFlip)
	end,
	
}
