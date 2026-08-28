
--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

local GRAPHICS   = require("tools/lib/graphics"):create()

local bgPath      = "game/resources/zones/backgrounds/" .. __PARAMS["backgroundTestData"]
local bgData      = require(bgPath)
local bgImageName = bgData.bgImageName
local imgPath     = "game/resources/images/backgrounds/" .. bgImageName .. ".png"
local image       = love.graphics.newImage(imgPath)

image:setFilter("nearest", "nearest")

local LAYERS = ({
    init = function(self, image, data)
        self.image  = image
        self.data   = data
        self.slices = {}

        for _, slice in ipairs(data.slices) do
            local quad = love.graphics.newQuad(slice.x, slice.y, slice.w, slice.h, self.image:getWidth(), self.image:getHeight())
            if slice.lineScrolling then
                self:addLineScrollingSlice(slice)
            else
                table.insert(self.slices, { x = 0, w = slice.w, h = slice.h, quad = quad, xScalar = slice.xScalar, xSpeed = slice.xSpeed, lineScrolling = slice.lineScrolling, })
            end
        end

        return self
    end,

    addLineScrollingSlice = function(self, slice)
        local delay = 0
        for i = 0, slice.h - 1 do
            local quad = love.graphics.newQuad(slice.x, slice.y + i, slice.w, 1, self.image:getWidth(), self.image:getHeight())
            table.insert(self.slices, { x = 0, w = slice.w, h = 1, quad = quad, xScalar = slice.xScalar, xSpeed = slice.xSpeed, 
                lineScrolling = { amount = slice.lineScrolling.amount, speed = slice.lineScrolling.speed, delay = delay, timer = 0, hOffset = 0, xVelocity = -1 }})
            delay = delay + (slice.lineScrolling.delaySpread or 1)
        end
    end,

    draw = function(self)
        GRAPHICS:setColor(1, 1, 1)
        local y = 0
        for _, slice in ipairs(self.slices) do
            local x = slice.x
            if slice.lineScrolling then x = x + slice.lineScrolling.hOffset end
            GRAPHICS:draw(self.image, slice.quad, x, y, 0, 1, 1)
            y = y + slice.h
        end
    end,

    update = function(self, dt)
        for _, slice in ipairs(self.slices) do
            if slice.xSpeed then
                slice.x = slice.x + (slice.xSpeed * dt)
            end
            if slice.lineScrolling then
                slice.lineScrolling.timer = slice.lineScrolling.timer + (60 * dt)
                if slice.lineScrolling.timer > slice.lineScrolling.delay then
                    slice.lineScrolling.hOffset = slice.lineScrolling.hOffset + (slice.lineScrolling.xVelocity * slice.lineScrolling.speed * dt)
                    if (slice.lineScrolling.hOffset > slice.lineScrolling.amount and slice.lineScrolling.xVelocity > 0) or (slice.lineScrolling.hOffset < -slice.lineScrolling.amount and slice.lineScrolling.xVelocity < 0) then
                        slice.lineScrolling.xVelocity = slice.lineScrolling.xVelocity * -1
                    end
                end
            end
        end
    end,

    ---------------------- Graphics Object Methods ------------------------

    moveImage = function(self, deltaX, deltaY)
        GRAPHICS:moveImage(0, deltaY / GRAPHICS:getScale())
        for _, slice in ipairs(self.slices) do
            slice.x = slice.x + (deltaX / (slice.xScalar or 1))
        end
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return GRAPHICS:screenToImageCoordinates(screenX, screenY)
    end,

    imageToScreenCoordinates = function(self, imageX, imageY)
        return GRAPHICS:imageToScreenCoordinates(imageX, imageY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        GRAPHICS:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        GRAPHICS:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,
}):init(image, bgData)

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if LAYERS then LAYERS:draw() end
end

function love.update(dt)
    if LAYERS then LAYERS:update(dt) end
end

function love.mousepressed(mx, my)
    -- Do something
end

function love.keypressed(key)
    -- Scrolling
end

-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------


--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("zooming",      { imageViewer    = LAYERS })
    :add("scrolling",    { imageViewer    = LAYERS })
    :add("questionBox",
    {   x     = 750,
        w     = 600,
        destX = 100,
        useDoubleClick = true,
        getDoubleClickFn = getDoubleClick,
        lines = {
            "Use arrow keys to scroll with parallax",
        },
    })
