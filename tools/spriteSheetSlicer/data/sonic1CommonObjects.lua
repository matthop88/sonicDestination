return {
    imagePath = "resources/images/spriteSheets/commonObj.png",

    MARGIN_BG_COLOR = { r = 0.15, g = 0.40, b = 0.10, a = 1 },
    SPRITE_BG_COLOR = { r = 0,    g = 0,    b = 0,    a = 0 },

    animations  = {
        spinningRing = { fps = 8,
            rect    = { x = 24,  y = 198, w = 78, h = 16 },
            sprites = {
                { x =  24, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
                { x =  48, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
                { x =  72, y = 198, w =  8, h = 16, offset = { x =  4, y =  8 }, },
                { x =  88, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
            },
        },
        dissolvingRing = { fps = 8,
            rect    = { x = 112, y = 198, w = 88, h = 14 },
            sprites = {
                { x = 112, y = 198, w = 16, h = 14, offset = { x =  8, y =  7 }, },
                { x = 136, y = 200, w = 16, h = 14, offset = { x =  8, y =  7 }, },
                { x = 160, y = 198, w = 16, h = 14, offset = { x =  8, y =  7 }, },
                { x = 184, y = 200, w = 16, h = 14, offset = { x =  8, y =  7 }, },
            },
        },
        spinningGiantRing = { fps = 8,
            rect    = { x = 24, y = 239, w = 208, h = 64 },
            sprites = {
                { x =  24, y = 239, w = 64, h = 64, offset = { x = 32, y = 32 }, },
                { x =  96, y = 239, w = 48, h = 64, offset = { x = 24, y = 32 }, },
                { x = 152, y = 239, w = 24, h = 64, offset = { x = 12, y = 32 }, },
                { x = 184, y = 239, w = 48, h = 64, offset = { x = 24, y = 32 }, },
            },
        },
    },
}
