return {
    imagePath = "tools/ringMaster/resources/commonObj.png",

    MARGIN_BG_COLOR = { r = 0.15, g = 0.40, b = 0.10 },
    SPRITE_BG_COLOR = { r = 0, g = 0, b = 0, a = 0 },

    animations  = {
        spinning = { fps = 8,
            rect    = { x = 24, y = 198, w = 78, h = 16 },
            sprites = {
                { x =  24, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
                { x =  50, y = 198, w = 12, h = 16, offset = { x =  5, y =  8 }, },
                { x =  73, y = 198, w =  6, h = 16, offset = { x =  3, y =  8 }, },
                { x =  90, y = 198, w = 12, h = 16, offset = { x =  6, y =  8 }, },
            },
        },
    },
}
