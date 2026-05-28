
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 600

local destTiles = { 272, 273, 274, 275 }

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
        self.offset = self.offset + (9 * dt)
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

local IMG_GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), 1024, 256)
local GRAFX     = require("tools/lib/graphics"):create(WINDOW_WIDTH, WINDOW_HEIGHT)

local imgData   = love.image.newImageData(imgPath)
local image     = love.graphics.newImage(imgData)

image:setFilter("nearest", "nearest")

local drawPhase = 1
local chunkMaxX = 512

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if drawPhase == 1 then
        drawPhaseOne()
    else
        drawPhaseTwo()
    end
end

function drawPhaseOne()
    IMG_GRAFX:clear(0, 0, 0)
    IMG_GRAFX:setColor(1, 1, 1)
    IMG_GRAFX:draw(image, 0, 0)
    GRAFX:setColor(1, 1, 1)
    GRAFX:draw(IMG_GRAFX:getBuffer(), 0, 0)
end

function drawPhaseTwo()
    GRAFX:setColor(1, 1, 1)
    GRAFX:draw(image, 0, 0)
end

function love.update(dt)
    animColors:update(dt)
end

function love.mousepressed(mx, my)
    local x, y = GRAFX:screenToImageCoordinates(mx, my)
    x, y = math.floor(math.floor(x) / 16) * 16, math.floor(math.floor(y) / 16) * 16
    printToReadout("Tile Coordinates: { x = " .. x .. ", y = " .. y .. " }")
    selectedTile = calculateTileID(x, y)
end

function love.keypressed(key)
    if     key == "space"  then addRects()
    elseif key == "W"      then waterfallOn = not waterfallOn
    elseif key == "return" then 
        saveImage()
        saveTileMap()
    end
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function drawOverlays()
    local scale = GRAFX:getScale()
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
        local quad = love.graphics.newQuad(tileX, tileY, 16, 16, imgData:getWidth(), imgData:getHeight())
        love.graphics.draw(image, quad, 300, 300, 0, 5, 5)
        for i = 1, 4 do
            love.graphics.setColor(animColors:get(i))
            local tileX, tileY = calculateTileXYFromID(tileMap[selectedTile][i])
            local quad = love.graphics.newQuad(tileX, tileY, 16, 16, imgData:getWidth(), imgData:getHeight())
            love.graphics.draw(image, quad, 300, 300, 0, 5, 5)
        end
    end
end

function calculateTileCoordinates(mx, my)
    local px, py = GRAFX:screenToImageCoordinates(mx, my)
    local tx, ty = GRAFX:imageToScreenCoordinates(math.floor(px / 16) * 16, math.floor(py / 16) * 16)
    return math.floor(tx), math.floor(ty)
end

function onColorSelected(color)
    selectedColor = color
    local r, g, b = unpack(color)
    print(string.format("{ r = %.2f, g = %.2f, b = %.2f }", r, g, b))
    printToReadout(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))
end 

extractColor = function(x, y, r, g, b, a)
    local tileX, tileY = calculateTileXYFromID(selectedTile)
    if x >= tileX and y >= tileY
        and x <  tileX + 16 and y < tileY + 16 then
            for n, c in ipairs(waterfallColors) do
                local destTileX, destTileY = calculateTileXYFromID(destTiles[n])
                if colorsMatch(r, g, b, c.color[1], c.color[2], c.color[3]) then
                    table.insert(c.data, { x = destTileX + x - tileX, y = destTileY + y - tileY })
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
        local destTileX, destTileY = calculateTileXYFromID(destTiles[n])
        if x >= destTileX and y >= destTileY and x < destTileX + 16 and y < destTileY + 16 then
            for _, d in ipairs(waterfallColors[n].data) do
                if x == d.x and y == d.y then
                    return 1, 1, 1, 1
                end
            end
            return 0, 0, 0, 0
        end
    end
    return r, g, b, a
end   

function addRects()
    for i = 1, 16 do
        addRect()
        selectedTile = selectedTile + 1
    end
end

function addRect()
    if drawPhase == 1 then
        updateImage()
        drawPhase = 2
    end
    waterfallColors:resetData()
    imgData:mapPixel(extractColor)
    imgData:mapPixel(addExtractedColor)
    image = love.graphics.newImage(imgData)
    image:setFilter("nearest", "nearest")

    if waterfallColors:isExtractionData() then
        tileMap[selectedTile] = { 
            destTiles[1],
            destTiles[2],
            destTiles[3],
            destTiles[4],
        }
        
        for n, t in ipairs(destTiles) do
            destTiles[n] = destTiles[n] + 4
        end
    end
end

function calculateTileID(x, y)
    local tX, tY = math.floor(x / 16), math.floor(y / 16)
    local chunkID = math.floor(tX / 16)
    return (chunkID * 256) + (tY * 16) + (tX - (chunkID * 16))
end

function calculateTileXYFromID(id)
    local chunkID = math.floor(id / 256)
    id = id - (chunkID * 256)
    local tX = ((id % 16) * 16) + (chunkID * 256)
    local tY = id - (id % 16)
    return tX, tY
end

function updateImage()
    imgData = IMG_GRAFX:getImageData()
    image = love.graphics.newImage(imgData)
    image:setFilter("nearest", "nearest")
end

function saveImage()
    print("Saved to " .. love.filesystem.getSaveDirectory())
    return imgData:encode("png", "ghzBGTiles.png")
end

function saveTileMap()
    local keys = {}
    for k in pairs(tileMap) do
        table.insert(keys, k)
    end
    table.sort(keys)
    local data = "return {\n  tilesImageName = \"ghzBGTiles\",\n"
    for _, k in ipairs(keys) do
        local destTiles = ""
        for _, t in ipairs(tileMap[k]) do
            destTiles = destTiles .. t .. ", "
        end
        data = data .. "  [" .. k .. "] = { " .. destTiles .. "},\n"
    end
    data = data .. "}\n"

    love.filesystem.createDirectory("resources/zones/backgrounds")
    love.filesystem.write("resources/zones/backgrounds/ghzBGAltTiles.lua", data)
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("drawingLayer", { drawingFn      = drawOverlays     })
    :add("readout",      { printFnName    = "printToReadout" })
    :add("zooming",      { imageViewer    = GRAFX })
    :add("scrolling",    { imageViewer    = GRAFX })
