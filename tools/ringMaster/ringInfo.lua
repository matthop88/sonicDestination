--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local PIXEL_UTIL    = require("tools/lib/pixelUtil")
local STRING_UTIL   = require("tools/lib/stringUtil")

local RING_PARAMS = {
    imageName    = "commonObj",
    startX       = 24,
    startY       = 198,
    w            = 16,
    h            = 16,
    matchPercent = 60,
}

local MOTOBUG_PARAMS = {
    imageName    = "sonic1BadniksTransparent",
    startX       = 174,
    startY       = 276,
    w            = 39,
    h            = 29,
    matchPercent = 60,
}

local OBJECT_PARAMS = {
    ring    = RING_PARAMS,
    motobug = MOTOBUG_PARAMS,
}

return {
    OBJECT_DATA   = nil,
    OBJECT_IMG    = nil,
    OBJECT_QUAD   = nil,
    COLOR_FREQ    = nil,
    MATCH_PERCENT = nil,

    create = function(self, objectType)
        local params = OBJECT_PARAMS[objectType]

        local OBJECT_DATA   = love.image.newImageData("resources/images/spriteSheets/" .. params.imageName .. ".png")
        local OBJECT_IMG    = love.graphics.newImage(OBJECT_DATA)
        local OBJECT_QUAD   = love.graphics.newQuad(params.startX, params.startY, params.w, params.h, OBJECT_IMG:getWidth(), OBJECT_IMG:getHeight())
        local COLOR_FREQ    = require("tools/ringMaster/colorClassifier"):classifyImageData(OBJECT_DATA, params.startX, params.startY, params.w, params.h)
        local MATCH_PERCENT = params.matchPercent or 60

        OBJECT_IMG:setFilter("nearest", "nearest")

        local maxInstances = 0
        local bestKey      = 0

        for n, v in ipairs(COLOR_FREQ) do
            if maxInstances < v.frequency and v.color.a ~= 0 then
                maxInstances = v.frequency
                bestKey = n
            end
        end

        return {
            name        = objectType,
            objectsName = STRING_UTIL:capitalize(objectType) .. "s",
            data        = OBJECT_DATA, 
            width       = params.w,
            height      = params.h, 
            startX      = params.startX, 
            startY      = params.startY,
            keyColor    = COLOR_FREQ[bestKey],
            maxStrikes  = math.ceil(COLOR_FREQ[bestKey].frequency * (100 - MATCH_PERCENT) / 100),

            draw = function(self, x, y, scale, color)
                love.graphics.setColor(color)
                love.graphics.draw(OBJECT_IMG, OBJECT_QUAD, x - ((self.width / 2) * scale), y - ((self.height / 2) * scale), 0, scale, scale)
            end,

            erase = function(self, object, mapData)
                local er, eg, eb, ea = mapData:getPixel(object.x, object.y)
                for y = self.startY, self.startY + self.height - 1 do
                    for x = self.startX, self.startX + self.width - 1 do
                        local r, g, b, a = OBJECT_DATA:getPixel(x, y)
                        if a ~= 0 then
                            local mapX = object.x + x - self.startX - math.floor(self.width / 2)
                            local mapY = object.y + y - self.startY - math.floor(self.height / 2)
                            local mr, mg, mb, ma = mapData:getPixel(mapX, mapY)
                            if PIXEL_UTIL:colorsMatch(r, g, b, 1, mr, mg, mb, 1, 0.1) then
                                mapData:setPixel(mapX, mapY, er, eg, eb, 1)
                            end
                        end
                    end
                end
                object.erased = true
            end,
        }
    end,
}
