
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 600

local destRects = {
    { x = 256, y = 16 },
    { x = 272, y = 16 },
    { x = 288, y = 16 },
    { x = 304, y = 16 },
}

local selectedTileCoordinates = { x = 0, y = 0 }

local waterfallColors = {
    { 
        color     = { 0.87, 0.47, 0.87 },
        data      = {},
    },
    { 
        color     = { 0.73, 0.33, 0.73 },
        data      = {},
    },
    { 
        color     = { 0.60, 0.20, 0.60 },
        data      = {},
    },
    { 
        color     = { 0.47, 0.07, 0.47 },
        data      = {},
    },
    
    resetData = function(self)
        for _, c in ipairs(self) do
            c.data = {}
        end
    end,

    isExtractionData = function(self)
        for _, d in ipairs(self) do
            if #d.data > 0 then
                return true
            end
        end
    end,
}

local animColors = {
    { base = { 0.71, 0.85, 0.99 }, delta = { -0.15, -0.14,  0.0  } },
    { base = { 0.56, 0.71, 0.99 }, delta = { -0.14, -0.15,  0.0  } },
    { base = { 0.42, 0.56, 0.99 }, delta = {  0.0,   0.0,  -0.28 } },
    { base = { 0.42, 0.56, 0.71 }, delta = {  0.29,  0.29,  0.28 } },
    offset = 1,
    dx     = 0,
    update = function(self, dt)
        self.offset = self.offset + (18 * dt)
        self.dx = self.offset - math.floor(self.offset)
        if self.offset >= 5 then self.offset = self.offset - 4 end
    end,
    get = function(self, n)
        local index = n + math.floor(self.offset)
        if index > 4 then index = index - 4 end
        local c = self[index]
        return { c.base[1] + (c.delta[1] * self.dx), c.base[2] + (c.delta[2] * self.dx), c.base[3] + (c.delta[3] * self.dx) }
    end,
}

local waterfallOn = false

local tileMap = {}

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Color Extractor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

local imgPath = "game/resources/images/backgrounds/ghzBGTiles.png"

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.update(dt)
    animColors:update(dt)
end

function love.mousepressed(mx, my)
    local x, y = getImageViewer():screenToImageCoordinates(mx, my)
    x, y = math.floor(math.floor(x) / 16) * 16, math.floor(math.floor(y) / 16) * 16
    printToReadout("Tile Coordinates: { x = " .. x .. ", y = " .. y .. " }")
    selectedTileCoordinates = { x = x, y = y }
    selectedTile = calculateTileID(x, y)
end

function love.keypressed(key)
    if     key == "space" then addRect()
    elseif key == "W"     then waterfallOn = not waterfallOn
    end
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function drawOverlays()
    local scale = getImageViewer():getScale()
    local x, y = calculateTileCoordinates(love.mouse.getPosition())
    love.graphics.setLineWidth(scale)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x - scale, y - scale, 18 * scale, 18 * scale)
    drawWaterfall()
end

function drawWaterfall()
    if waterfallOn and tileMap[selectedTile] then
        local tileX, tileY = calculateTileXYFromID(selectedTile)
        love.graphics.setColor(1, 1, 1)
        local quad = love.graphics.newQuad(tileX, tileY, 16, 16, getImageViewer():getImageWidth(), getImageViewer():getImageHeight())
        love.graphics.draw(getImageViewer():getImage(), quad, 300, 300, 0, 5, 5)
        for i = 1, 4 do
            love.graphics.setColor(animColors:get(i))
            local quad = love.graphics.newQuad(tileMap[selectedTile][i].x, tileMap[selectedTile][i].y, 16, 16, getImageViewer():getImageWidth(), getImageViewer():getImageHeight())
            love.graphics.draw(getImageViewer():getImage(), quad, 300, 300, 0, 5, 5)
        end
    end
end

function calculateTileCoordinates(mx, my)
    local imageViewer = getImageViewer()
    local px, py = imageViewer:screenToImageCoordinates(mx, my)
    local tx, ty = imageViewer:imageToScreenCoordinates(math.floor(px / 16) * 16, math.floor(py / 16) * 16)
    return math.floor(tx), math.floor(ty)
end

function onColorSelected(color)
    selectedColor = color
    local r, g, b = unpack(color)
    print(string.format("{ r = %.2f, g = %.2f, b = %.2f }", r, g, b))
    printToReadout(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))
end 

extractColor = function(x, y, r, g, b, a)
    if x >= selectedTileCoordinates.x and y >= selectedTileCoordinates.y
        and x <  selectedTileCoordinates.x + 16 and y < selectedTileCoordinates.y + 16 then
            for n, c in ipairs(waterfallColors) do
                if colorsMatch(r, g, b, c.color[1], c.color[2], c.color[3]) then
                    table.insert(c.data, { x = destRects[n].x + x - selectedTileCoordinates.x, y = destRects[n].y + y - selectedTileCoordinates.y })
                    return 0, 0, 0, 0
                end
            end
    end
    return r, g, b, a
end

colorsMatch = function(r1, g1, b1, r2, g2, b2)
    return math.abs(r1 - r2) < 0.005 and math.abs(g1 - g2) < 0.005 and math.abs(b1 - b2) < 0.005
end

addExtractedColor = function(x, y, r, g, b, a)
    for n = 1, 4 do
        if x >= destRects[n].x and y >= destRects[n].y and x < destRects[n].x + 16 and y < destRects[n].y + 16 then
            for _, d in ipairs(waterfallColors[n].data) do
                if x == d.x and y == d.y then
                    return 1, 1, 1, 1
                end
            end
        end
    end
    return r, g, b, a
end
    

function addRect()
    print("selectedTileCoordinates: x = " .. selectedTileCoordinates.x .. ", y = " .. selectedTileCoordinates.y)
    waterfallColors:resetData()
    getImageViewer():editPixels(extractColor)
    getImageViewer():editPixels(addExtractedColor)
    if waterfallColors:isExtractionData() then
        tileMap[selectedTile] = { 
            { x = destRects[1].x, y = destRects[1].y },
            { x = destRects[2].x, y = destRects[2].y },
            { x = destRects[3].x, y = destRects[3].y },
            { x = destRects[4].x, y = destRects[4].y },
        }

        for _, r in ipairs(destRects) do
            r.x = r.x + 64
            if r.x >= 512 then
                r.x = r.x - 256
                r.y = r.y + 16
            end
        end
    end
end

function calculateTileID(x, y)
    local tX, tY = math.floor(x / 16), math.floor(y / 16)
    local chunkID = math.floor(tX / 16)
    return (chunkID * 256) + (tY * 16) + (tX - (chunkID * 16))
end

function calculateTileXYFromID(id)
    local tX = (id % 16) * 16
    local tY = id - (id % 16)
    return tX, tY
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("imageViewer", 
    { 
        imagePath         = imgPath,
        pixelated         = true,
        accessorFnName    = "getImageViewer"
    })
    :add("drawingLayer", { drawingFn      = drawOverlays     })
    :add("readout",      { printFnName    = "printToReadout" })
    :add("zooming",      { imageViewer    = getImageViewer() })
    :add("scrolling",    { imageViewer    = getImageViewer() })
