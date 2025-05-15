return {
    image    = love.graphics.newImage(relativePath("resources/images/spriteSheets/sonic1Transparent.png")),
    data = {
        standing = {
            rects = {
                { x =  43, y = 257, w = 32, h = 40, offset = { x = 12, y = 20 }, },
            },
            quads = { },
        },
        running  = {
            rects = {
                { x =  46, y = 349, w = 24, h = 40, offset = { x =  8, y = 19 }, },
                { x = 109, y = 347, w = 40, h = 40, offset = { x = 16, y = 19 }, },
                { x = 178, y = 348, w = 32, h = 40, offset = { x = 16, y = 19 }, },
                { x = 249, y = 349, w = 40, h = 40, offset = { x = 16, y = 19 }, },
                { x = 319, y = 347, w = 40, h = 40, offset = { x = 16, y = 19 }, },
                { x = 390, y = 348, w = 40, h = 40, offset = { x = 16, y = 19 }, },
            },
            quads = { },
        },
    },
}
    
