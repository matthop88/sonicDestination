return {
    init = function(self, params)
        self.SONIC      = params.SONIC
        self.SPRITE     = self.SONIC.sprite
        self.ANIMATIONS = self.SPRITE.animations
        self.GRAPHICS   = params.GRAPHICS
        self.DRAWING_FN = function()   self.SONIC:draw()     end
        self.UPDATE_FN  = function(dt) 
            params.PROP_LOADER:update(dt)
            self.SONIC:update(dt) 
        end

        love.update = function(dt)
            -- Do nothing
        end
        
        self:initPlugins()
    end,

    initPlugins = function(self)
        require("plugins/engine")
            :add("updateLayer", { updateFn = self.UPDATE_FN })
            :add("modKeyEnabler")
            :add("grid3D",         { 
                graphics      = self.GRAPHICS,
                toggleGridKey = "g",
            })
            :add("cameraTracking", {
                graphics        = self.GRAPHICS,
                toggleCameraKey = "g",
                positionFn      = function() return self.SONIC:getX(), self.SONIC:getY() end,
            })
            :add("scrolling",      { 
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
                            return math.floor(self.ANIMATIONS:getFPS())
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
                        getValueFn = function()
                            if self.SONIC.mphMode then
                                local mph = self.SONIC.velocity.x * 0.0568
                                return string.format("%.1f MPH", math.abs(mph) + 0.5)
                            else
                                return "" .. math.floor(math.abs(self.SONIC.velocity.x) + 0.5) .. " Pixels / Second"
                            end
                        end,
                        toggleShowKey = "v",
                    },
                    mphMode = {
                        special = {
                            key = "m",
                            fn  = function() self.SONIC.mphMode = not self.SONIC.mphMode end,
                        },
                    },
                }
            })
    end,
}
