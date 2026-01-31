return {
    imagePath = "game/resources/images/spriteSheets/PTPBadniksTransparent.png",

    MARGIN_BG_COLOR = { r = 0.15, g = 0.40, b = 0.10, a = 1 },
    SPRITE_BG_COLOR = { r = 0,    g = 0,    b = 0,    a = 0 },

    animations  = {
        patabataFlying = { fps = 8,
            rect    = { x = 407, y = 60, w = 106, h = 30 },
            sprites = {
                { x = 407, y = 60, w = 28, h = 27, offset = { x = 13, y = 17, }, },
                { x = 448, y = 61, w = 26, h = 17, offset = { x = 13, y =  8, }, },
                { x = 487, y = 63, w = 26, h = 22, offset = { x = 13, y =  9, }, },
                { x = 448, y = 61, w = 26, h = 17, offset = { x = 13, y =  8, }, },
            },
        },
    },
}
