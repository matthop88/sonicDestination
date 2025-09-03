return {
    imagePath = "game/resources/images/spriteSheets/sonic1Transparent.png",

    MARGIN_BG_COLOR = { r = 0.05, g = 0.28, b = 0.03, a = 1 },
    SPRITE_BG_COLOR = { r = 0,    g = 0,    b = 0,    a = 0 },

    animations  = {
        running = { fps = 8,
            rect    = { x = 24, y = 334, w = 416, h = 66 },
            sprites = {
                { x =  46, y = 349, w = 24, h = 40, offset = { x = 12, y = 20 }, },
                { x = 109, y = 347, w = 40, h = 40, offset = { x = 20, y = 20 }, },
                { x = 178, y = 348, w = 32, h = 40, offset = { x = 20, y = 20 }, },
                { x = 249, y = 349, w = 40, h = 40, offset = { x = 20, y = 20 }, },
                { x = 319, y = 347, w = 40, h = 40, offset = { x = 20, y = 20 }, },
                { x = 390, y = 348, w = 40, h = 40, offset = { x = 20, y = 20 }, },
            },
        },
        braking = { fps = 6,
            rect    = { x = 460, y = 334, w = 136, h = 66 },
            sprites = {
                { x = 481, y = 352, w = 30, h = 36, offset = { x = 13, y = 18 }, },
                { x = 547, y = 352, w = 34, h = 36, offset = { x = 17, y = 18 }, },
            },
        },
        jumping = { fps = 12,
            rect    = { x = 24, y = 607, w = 346, h = 66 },
            sprites = {
                {   x =  44, y = 626, w = 29, h = 30, },
                {   x = 114, y = 626, w = 30, h = 29, },
                {   x = 185, y = 626, w = 29, h = 30, },
                {   x = 254, y = 627, w = 30, h = 29, },
                {   x = 324, y = 626, w = 30, h = 30, },
            },
        },
    },
    spriteRects = {
        { x =  46, y = 349, w = 24, h = 40, offset = { x = 12, y = 20 }, },
        { x = 109, y = 347, w = 40, h = 40, offset = { x = 20, y = 20 }, },
        { x = 178, y = 348, w = 32, h = 40, offset = { x = 20, y = 20 }, },
        { x = 249, y = 349, w = 40, h = 40, offset = { x = 20, y = 20 }, },
        { x = 319, y = 347, w = 40, h = 40, offset = { x = 20, y = 20 }, },
        { x = 390, y = 348, w = 40, h = 40, offset = { x = 20, y = 20 }, },
    },
}
