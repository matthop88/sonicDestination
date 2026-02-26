local BADNIK_TEMPLATE = require("tools/constructionSet/templates/badnikTemplate")
local ITEM_TEMPLATE   = require("tools/constructionSet/templates/itemTemplate")

local BADNIK          = require("tools/constructionSet/templates/badnik")
local ITEM            = require("tools/constructionSet/templates/item")

return {
	library = {
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
	},
	
}
