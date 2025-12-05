
return {
    imagePath = "resources/images/spriteSheets/sonic1Badniks.png",

    MARGIN_BG_COLOR = { r = 0.15, g = 0.40, b = 0.10, a = 1 }, 
    SPRITE_BG_COLOR = { r = 0.05, g = 0.28, b = 0.03, a = 1 },

    animations  = {
        motobugRoving = { fps = 4,
            rect    = { x = 174,  y = 276, w = 103, h = 68 },
            sprites = {
                { x = 174, y = 276, w = 47, h = 29, offset = { x = 24, y = 14 }, },
				{ x = 229, y = 276, w = 48, h = 29, offset = { x = 24, y = 14 }, },
				{ x = 174, y = 316, w = 47, h = 28, offset = { x = 24, y = 14 }, },
				{ x = 229, y = 316, w = 48, h = 28, offset = { x = 24, y = 14 }, },
            },
        },
        motobugPutt = { fps = 4,
            rect    = { x = 285, y = 277, w = 8, h = 38 },
            sprites = {
                { x = 287, y = 277, w = 4, h = 4, offset = { x = 2, y = 2 }, },
				{ x = 285, y = 291, w = 8, h = 8, offset = { x = 4, y = 4 }, },
				{ x = 285, y = 307, w = 8, h = 8, offset = { x = 4, y = 4 }, },
 			},
        },
    },
}
