return require("plugins/engine")
    :add("modKeyEnabler")
    :add("mouseTracking",
    {
        object  = SONIC,
        originX = 512,
        originY = 514,
    })
    :add("scrolling", { 
        imageViewer = graphics,
        leftKey     = "shiftleft",
        rightKey    = "shiftright",
        upKey       = "shiftup",
        downKey     = "shiftdown"
    })
    :add("zooming",   { imageViewer = graphics })
    :add("tweakAttributes", {
        object          = SONIC,
        incAttributeKey = ">",
        decAttributeKey = "<",
        attributes      = {
            frameIndex = {
                name = "Frame Index",
                incrementFn = function()
                    SONIC.sprite:setCurrentFrameIndex(SONIC.sprite:getCurrentFrameIndex() + 1)
                end,
                decrementFn = function()
                    SONIC.sprite:setCurrentFrameIndex(SONIC.sprite:getCurrentFrameIndex() - 1)
                end,
                getValueFn  = function()
                    return SONIC.sprite:getCurrentFrameIndex()
                end,
                toggleShowKey = "f",
            },
            fps = {
                name = "FPS",
                incrementFn = function()
                    SONIC.sprite.animations:setFPS(SONIC.sprite.animations:getFPS() + 1)
                end,
                decrementFn = function()
                    SONIC.sprite.animations:setFPS(SONIC.sprite.animations:getFPS() - 1)
                end,
                getValueFn  = function()
                    return SONIC.sprite.animations:getFPS()
                end,
                toggleShowKey = "F",
            },
            offsetX = {
                name = "X Offset",
                incrementFn = function()
                    SONIC.sprite:getCurrentOffset().x = SONIC.sprite:getCurrentOffset().x + 1
                end,
                decrementFn = function()
                    SONIC.sprite:getCurrentOffset().x = SONIC.sprite:getCurrentOffset().x - 1
                end,
                getValueFn  = function()
                    return SONIC.sprite:getCurrentOffset().x
                end,
                toggleShowKey = "x"
            },
            offsetY = {
                name = "Y Offset",
                incrementFn = function()
                    SONIC.sprite:getCurrentOffset().y = SONIC.sprite:getCurrentOffset().y + 1
                end,
                decrementFn = function()
                    SONIC.sprite:getCurrentOffset().y = SONIC.sprite:getCurrentOffset().y - 1
                end,
                getValueFn  = function()
                    return SONIC.sprite:getCurrentOffset().y
                end,
                toggleShowKey = "y"
            },
        }
    })
