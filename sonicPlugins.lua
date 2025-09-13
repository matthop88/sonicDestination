local GRAVITY = {
    {   name = "19.50 m/s2 (MOBIUS)",   value = 787.5, label = "MOBIUS",   },
    {   name = " 9.80 m/s2 (EARTH)",    value = 386,   label = "EARTH",    },
    {   name = " 3.71 m/s2 (MARS)",     value = 146,   label = "MARS",     },
    {   name = "24.79 m/s2 (JUPITER)",  value = 976,   label = "JUPITER",  },
    {   name = " 1.62 m/s2 (THE MOON)", value =  64,   label = "THE MOON", },

    index = 1,

    next = function(self)
        self.index = self.index + 1
        if self.index > #self then self.index = 1 end
    end,

    prev = function(self)
        self.index = self.index - 1
        if self.index < 1 then self.index = #self end
    end,

    get = function(self)
        return self[self.index]
    end,
}

return {
    init = function(self, params)
        self.SONIC      = params.SONIC
        self.SPRITE     = self.SONIC.sprite
        self.ANIMATIONS = self.SPRITE.animations
        self.GRAPHICS   = params.GRAPHICS
        self.DRAWING_FN = function()   
            self.SONIC:draw()  
        end
        self.UPDATE_FN  = function(dt) 
            params.PROP_LOADER:update(dt)
            self.SONIC:update(dt) 
        end

        self.AIR_DRAG   = self.SONIC.AIR_DRAG_VALUE

        love.update = function(dt)
            -- Do nothing
        end
        
        self:initPlugins()
    end,

    initPlugins = function(self)
        require("plugins/engine")
            :add("modKeyEnabler")
            :add("grid3D",         { 
                graphics      = self.GRAPHICS,
                toggleGridKey = "g",
            })
            :add("tracer", {
                toggleShowKey      = "t",
                switchModeKey      = "Y",
                toggleRecordingKey = "r",
                graphics           = self.GRAPHICS,
                posAndRadiusFn     = function()
                    local x = self.SONIC:getX()
                    local y = self.SONIC:getY()
                    local r = math.max(math.abs(x - self.SONIC:getGeneralX()), math.abs(y - self.SONIC:getGeneralY()))
                    return x, y, r
                end,
                colors             = {
                    { 1, 1, 0 },
                    { 0, 1, 1 },
                },
            })
            :add("heightTracker", {
                toggleShowKey  = "h",
                graphics       = self.GRAPHICS,
                posAndWidthFn  = function() 
                    local generalX = self.SONIC:getGeneralX()
                    local generalY = self.SONIC:getGeneralY()
                    local generalW = math.abs(self.SONIC:getX() - self.SONIC:getGeneralX()) * 2
                    return generalX, generalY, generalW
                end,
                mode           = GRAVITY:get().label,
                accessorFnName = "getHeightTracker",
            })
            :add("scrolling",      { 
                imageViewer = self.GRAPHICS,
                leftKey     = "shiftleft",
                rightKey    = "shiftright",
                upKey       = "shiftup",
                downKey     = "shiftdown"
            })
            :add("zooming",      { imageViewer = self.GRAPHICS })
            :add("pause")
            :add("updateLayer", { updateFn = self.UPDATE_FN })
            :add("cameraTracking", {
                graphics        = self.GRAPHICS,
                toggleCameraKey = "g",
                positionFn      = function() return self.SONIC:getX(), self.SONIC:getY() end,
            })
            :add("drawingLayer", { drawingFn = self.DRAWING_FN })
            :add("stateMachineViewer", {
                graphics = dofile("tools/lib/graphics.lua"),
                states   = { "runningBrakingJumping" },
                nextKey  = "tab",
                prevKey  = "shifttab",
                arrowFunctions = {
                    {   key = "Speed = 0",
                        fn  = function() return self.SONIC.velocity.x == 0 end,
                    },
                    {   key = "Land",
                        fn  = function() return self.SONIC:isGrounded() end,
                    },
                },
                customKeys = {
                    landKey      = nil,
                    zeroSpeedKey = nil,
                },
                accessorFnName = "getStateMachineViewer",
            })
            :add("splitScreen", {
                GFX1 = self.GRAPHICS,
                GFX2 = getStateMachineViewer():getGraphics(),
            })
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
                    gravity = {
                        name = "Gravity Force",
                        incrementFn = function()
                            GRAVITY:next()
                            self.SONIC.GRAVITY_FORCE = GRAVITY:get().value
                            getHeightTracker():setMode(GRAVITY:get().label)
                        end,
                        decrementFn = function()
                            GRAVITY:prev()
                            self.SONIC.GRAVITY_FORCE = GRAVITY:get().value
                            getHeightTracker():setMode(GRAVITY:get().label)
                        end,
                        getValueFn  = function()
                            return GRAVITY:get().name
                        end,
                        toggleShowKey = "G",
                    },
                    airDrag = {
                        name = "Air Drag",
                        toggleShowKey = "d",
                        incrementFn = function()
                            self.SONIC.AIR_DRAG_VALUE = self.AIR_DRAG - self.SONIC.AIR_DRAG_VALUE
                        end,
                        decrementFn = function()
                            self.SONIC.AIR_DRAG_VALUE = self.AIR_DRAG - self.SONIC.AIR_DRAG_VALUE
                        end,
                        getValueFn  = function()
                            return self.SONIC.AIR_DRAG_VALUE
                        end,
                    },
                }
            })
            :add("readout", { printFnName = "printMessage" })
    end,
}
