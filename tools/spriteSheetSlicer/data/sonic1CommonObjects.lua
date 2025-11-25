return {
    imagePath = "resources/images/spriteSheets/commonObj.png",

    MARGIN_BG_COLOR = { r = 0.15, g = 0.40, b = 0.10, a = 1 },
    SPRITE_BG_COLOR = { r = 0,    g = 0,    b = 0,    a = 0 },

    animations  = {
        spinning = { fps = 8,
            rect    = { x = 24,  y = 198, w = 78, h = 16 },
            sprites = {
                { x =  24, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
                { x =  48, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
                { x =  72, y = 198, w =  8, h = 16, offset = { x =  4, y =  8 }, },
                { x =  88, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
            },
        },
        dissolving = { fps = 8,
            rect    = { x = 112, y = 198, w = 88, h = 14 },
            sprites = {
                { x = 112, y = 198, w = 16, h = 14, offset = { x =  8, y =  7 }, },
                { x = 136, y = 200, w = 16, h = 14, offset = { x =  8, y =  7 }, },
                { x = 160, y = 198, w = 16, h = 14, offset = { x =  8, y =  7 }, },
                { x = 184, y = 200, w = 16, h = 14, offset = { x =  8, y =  7 }, },
            },
        },
    },
}
