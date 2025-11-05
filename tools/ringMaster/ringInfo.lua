--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local OBJECT_DATA   = love.image.newImageData("tools/ringMaster/resources/commonObj.png")
local OBJECT_IMG    = love.graphics.newImage(OBJECT_DATA)
local RING_QUAD     = love.graphics.newQuad(24, 198, 16, 16, OBJECT_IMG:getWidth(), OBJECT_IMG:getHeight())
local COLOR_FREQ    = require("tools/ringMaster/colorClassifier"):classifyImageData(OBJECT_DATA, 24, 198, 16, 16)
local MATCH_PERCENT = 50

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

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
    data       = OBJECT_DATA, 
    width      = 16,
    height     = 16, 
    startX     = 24, 
    startY     = 198,
    keyColor   = COLOR_FREQ[bestKey],
    maxStrikes = math.ceil(COLOR_FREQ[bestKey].frequency * (100 - MATCH_PERCENT) / 100),

    draw = function(self, x, y, scale, color)
        love.graphics.setColor(color)
        love.graphics.draw(OBJECT_IMG, RING_QUAD, x, y, 0, scale, scale)
    end,
}
