return {
    init = function(self, params)
        self.SONIC    = params.SONIC
        self.GRAPHICS = params.GRAPHICS

        return self:initPlugins()
    end,

    initPlugins = function(self)
        return require("plugins/engine")
            :add("modKeyEnabler")
            :add("mouseTracking",
            {
                object  = self.SONIC,
                originX = 512,
                originY = 514,
            })
            :add("scrolling", { 
                imageViewer = self.GRAPHICS,
                leftKey     = "shiftleft",
                rightKey    = "shiftright",
                upKey       = "shiftup",
                downKey     = "shiftdown"
            })
            :add("zooming",   { imageViewer = self.GRAPHICS })
            :add("tweakAttributes", {
                incAttributeKey = ">",
                decAttributeKey = "<",
                attributes      = {
                    frameIndex = {
                        name = "Frame Index",
                        incrementFn = function()
                            self.SONIC.sprite:setCurrentFrameIndex(self.SONIC.sprite:getCurrentFrameIndex() + 1)
                        end,
                        decrementFn = function()
                            self.SONIC.sprite:setCurrentFrameIndex(self.SONIC.sprite:getCurrentFrameIndex() - 1)
                        end,
                        getValueFn  = function()
                            return self.SONIC.sprite:getCurrentFrameIndex()
                        end,
                        toggleShowKey = "f",
                    },
                    fps = {
                        name = "FPS",
                        incrementFn = function()
                            self.SONIC.sprite.animations:setFPS(self.SONIC.sprite.animations:getFPS() + 1)
                        end,
                        decrementFn = function()
                            self.SONIC.sprite.animations:setFPS(self.SONIC.sprite.animations:getFPS() - 1)
                        end,
                        getValueFn  = function()
                            return self.SONIC.sprite.animations:getFPS()
                        end,
                        toggleShowKey = "F",
                    },
                    offsetX = {
                        name = "X Offset",
                        incrementFn = function()
                            self.SONIC.sprite:getCurrentOffset().x = self.SONIC.sprite:getCurrentOffset().x + 1
                        end,
                        decrementFn = function()
                            self.SONIC.sprite:getCurrentOffset().x = self.SONIC.sprite:getCurrentOffset().x - 1
                        end,
                        getValueFn  = function()
                            return self.SONIC.sprite:getCurrentOffset().x
                        end,
                        toggleShowKey = "x"
                    },
                    offsetY = {
                        name = "Y Offset",
                        incrementFn = function()
                            self.SONIC.sprite:getCurrentOffset().y = self.SONIC.sprite:getCurrentOffset().y + 1
                        end,
                        decrementFn = function()
                            self.SONIC.sprite:getCurrentOffset().y = self.SONIC.sprite:getCurrentOffset().y - 1
                        end,
                        getValueFn  = function()
                            return self.SONIC.sprite:getCurrentOffset().y
                        end,
                        toggleShowKey = "y"
                    },
                }
            })
    end,
}

