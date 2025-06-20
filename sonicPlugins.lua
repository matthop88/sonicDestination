return {
    init = function(self, params)
        self.SONIC      = params.SONIC
        self.SPRITE     = self.SONIC.sprite
        self.ANIMATIONS = self.SPRITE.animations
        self.GRAPHICS   = params.GRAPHICS
        self.DRAWING_FN = love.draw
        
        self:initPlugins()
    end,

    initPlugins = function(self)
        require("plugins/engine")
            :add("modKeyEnabler")
            :add("mouseTracking",
            {
                object  = self.SONIC,
                originX = 512,
                originY = 514,
            })
            :add("grid3D")
            :add("scrolling", { 
                imageViewer = self.GRAPHICS,
                leftKey     = "shiftleft",
                rightKey    = "shiftright",
                upKey       = "shiftup",
                downKey     = "shiftdown"
            })
            :add("zooming",      { imageViewer = self.GRAPHICS })
            :add("drawingLayer", { drawingFn = self.DRAWING_FN })
            :add("pause")
            :add("tweakAttributes", {
                incAttributeKey = ">",
                decAttributeKey = "<",
                attributes      = {
                    frameIndex = {
                        name = "Frame Index",
                        incrementFn = function()
                            self.SPRITE:setCurrentFrameIndex(self.SPRITE:getCurrentFrameIndex() + 1)
                        end,
                        decrementFn = function()
                            self.SPRITE:setCurrentFrameIndex(self.SPRITE:getCurrentFrameIndex() - 1)
                        end,
                        getValueFn  = function()
                            return self.SPRITE:getCurrentFrameIndex()
                        end,
                        toggleShowKey = "f",
                    },
                    fps = {
                        name = "FPS",
                        incrementFn = function()
                            self.ANIMATIONS:setFPS(self.ANIMATIONS:getFPS() + 1)
                        end,
                        decrementFn = function()
                            self.ANIMATIONS:setFPS(self.ANIMATIONS:getFPS() - 1)
                        end,
                        getValueFn  = function()
                            return self.ANIMATIONS:getFPS()
                        end,
                        toggleShowKey = "F",
                    },
                    offsetX = {
                        name = "X Offset",
                        incrementFn = function()
                            self.SPRITE:getCurrentOffset().x = self.SPRITE:getCurrentOffset().x + 1
                        end,
                        decrementFn = function()
                            self.SPRITE:getCurrentOffset().x = self.SPRITE:getCurrentOffset().x - 1
                        end,
                        getValueFn  = function()
                            return self.SPRITE:getCurrentOffset().x
                        end,
                        toggleShowKey = "x"
                    },
                    offsetY = {
                        name = "Y Offset",
                        incrementFn = function()
                            self.SPRITE:getCurrentOffset().y = self.SPRITE:getCurrentOffset().y + 1
                        end,
                        decrementFn = function()
                            self.SPRITE:getCurrentOffset().y = self.SPRITE:getCurrentOffset().y - 1
                        end,
                        getValueFn  = function()
                            return self.SPRITE:getCurrentOffset().y
                        end,
                        toggleShowKey = "y"
                    },
                    velocityX = {
                        name = "X Velocity",
                        incrementFn = function()
                            self.SONIC.RUNNING_SPEED = self.SONIC.RUNNING_SPEED + 30
                        end,
                        decrementFn = function()
                            self.SONIC.RUNNING_SPEED = self.SONIC.RUNNING_SPEED - 30
                        end,
                        getValueFn = function()
                            return math.abs(self.SONIC.velocity.x)
                        end,
                        toggleShowKey = "v",
                    },
                }
            })
    end,
}
