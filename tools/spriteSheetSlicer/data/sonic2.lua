return {
    imagePath = "resources/images/spriteSheets/sonic2Transparent.png",

    MARGIN_BG_COLOR = { r = 0.15, g = 0.40, b = 0.10, a = 1 },
    SPRITE_BG_COLOR = { r = 0,    g = 0,    b = 0,    a = 0 },

    animations  = {
        running = { fps = 8,
            rect    = { x = 24, y = 335, w = 500, h = 59 },
            sprites = {
                { x =  41, y = 347, w = 26, h = 39, offset = { x = 13, y = 19 }, },
                { x = 102, y = 346, w = 29, h = 40, offset = { x = 15, y = 20 }, },
                { x = 162, y = 345, w = 39, h = 40, offset = { x = 18, y = 21 }, },
                { x = 224, y = 346, w = 39, h = 39, offset = { x = 19, y = 20 }, },
                { x = 293, y = 347, w = 26, h = 39, offset = { x = 13, y = 19 }, },
                { x = 355, y = 346, w = 28, h = 40, offset = { x = 14, y = 20 }, },
                { x = 412, y = 345, w = 40, h = 38, offset = { x = 20, y = 21 }, },
                { x = 476, y = 346, w = 39, h = 39, offset = { x = 19, y = 20 }, },
            },
        },
        jumping = { fps = 12, 
            rect    = { x = 813, y = 420, w = 307, h = 55 },
            sprites = {
                { x =  828, y = 435, w = 29, h = 30, offset = { x = 14, y = 14 }, },
                { x =  891, y = 435, w = 30, h = 29, offset = { x = 14, y = 15 }, },
                { x =  955, y = 435, w = 29, h = 30, offset = { x = 13, y = 15 }, },
                { x = 1017, y = 436, w = 30, h = 29, offset = { x = 14, y = 14 }, },
                { x = 1080, y = 435, w = 30, h = 30, offset = { x = 13, y = 14 }, },
            },
        },
    },
    spriteRects = {
        { x =  41, y = 347, w = 26, h = 39, offset = { x = 13, y = 19 }, },
        { x = 102, y = 346, w = 29, h = 40, offset = { x = 15, y = 20 }, },
        { x = 162, y = 345, w = 39, h = 40, offset = { x = 18, y = 21 }, },
        { x = 224, y = 346, w = 39, h = 39, offset = { x = 19, y = 20 }, },
        { x = 293, y = 347, w = 26, h = 39, offset = { x = 13, y = 19 }, },
        { x = 355, y = 346, w = 28, h = 40, offset = { x = 14, y = 20 }, },
        { x = 412, y = 345, w = 40, h = 38, offset = { x = 20, y = 21 }, },
        { x = 476, y = 346, w = 39, h = 39, offset = { x = 19, y = 20 }, },
    },
}
