local COLOR_SKY_BLUE = { 0, 0.57, 1.0 }
                
return {
    create = function(self, params)
        local captions1 = {
            fontName = "captions", 
            keys = { 
                "g", "r", "e", "e", "n", " ", "h", "i", "l", "l", " ", "z", "o", "n", "e", 
            },
        }

        local time1 = {
            fontName = "hud",
            keys = {
                "t", "i", "m", "e",
            },
        } 

        local time2 = {
            fontName = "hud",
            keys = { "TIME", },
        }

        local credits = {
            fontName = "credits",
            keys = { 
                "p", "r", "e", "s", "e", "n", "t", "e", "d", " ", "b", "y", " ", 
                "s", "o", "n", "i", "c", " ", "t", "e", "a", "m",
            },
        }

        local lifeHud = {
            fontName = "hudSmall",
            keys = { "$", "s", "o", "n", "i", "c", "x", "0", "3", },
        }

        local hudTemplate = {
            fontName = "hud",
            keys = { "TEMPLATE", },
        }

        return {
            graphics = params.graphics,
            objects  = require("game/util/dataStructures/linkedList"):create(),  
    
            init = function(self)
                self.fontEngine = require("tools/fontBlaster/fontEngine"):create()
                self.objects:add(self.fontEngine:newFontBlock(self.graphics, hudTemplate, 300,  75))
                self.objects:add(self.fontEngine:newFontBlock(self.graphics, captions1,   300, 300))
                self.objects:add(self.fontEngine:newFontBlock(self.graphics, time1,       100, 100))
                self.objects:add(self.fontEngine:newFontBlock(self.graphics, time2,       100, 120))
                self.objects:add(self.fontEngine:newFontBlock(self.graphics, credits,     200,  50))
                self.objects:add(self.fontEngine:newFontBlock(self.graphics, lifeHud,     200, 100))
                return self
            end,

            draw = function(self)
                self:drawBackground()
                self.objects:forEach(function(obj)
                    obj:draw()
                end)
            end,

            drawBackground = function(self)
                love.graphics.clear(COLOR_SKY_BLUE)
            end,

            update = function(self, dt)
                self.objects:forEach(function(obj)
                    obj:update(dt)
                    if obj:isDeleted() then
                        self.objects:remove()
                        return true
                    end
                end)
            end,

            handleKeypressed = function(self, key)
                if     key == "escape"     then self:deselectAll()
                elseif key == "backspace"  then self:delete(self:getSelected())
                elseif key == "shiftleft"  then self:nudge(self:getSelected(), -1,  0)
                elseif key == "shiftright" then self:nudge(self:getSelected(),  1,  0)
                elseif key == "shiftup"    then self:nudge(self:getSelected(),  0, -1)
                elseif key == "shiftdown"  then self:nudge(self:getSelected(),  0,  1)
                end
            end,

            handleMousepressed = function(self, mx, my)
                local selectedObj = nil
                self.objects:forEach(function(obj)
                    obj:deselect()
                    if obj:mouseInBounds(mx, my) then
                        selectedObj = obj
                    end
                end)
                if selectedObj ~= nil then selectedObj:select(mx, my) end
            end,

            handleMousereleased = function(self, mx, my)
                -- Do nothing
            end,

            getSelected = function(self)
                local selected = nil
                self.objects:forEach(function(obj)
                    if obj:isSelected() then 
                        selected = obj
                        return true
                    end
                end)

                return selected
            end,

            delete = function(self, obj)
                if obj ~= nil then obj:setDeleted() end
            end,

            nudge = function(self, obj, deltaX, deltaY)
                if obj ~= nil then obj:nudge(deltaX, deltaY) end
            end,

            deselectAll = function(self)
                self.objects:forEach(function(obj)
                    obj:deselect()
                end)
            end,

            -- IMAGE VIEWER METHODS --
            moveImage = function(self, deltaX, deltaY)
                self.graphics:moveImage(deltaX / self.graphics:getScale(), deltaY / self.graphics:getScale())
            end,

            screenToImageCoordinates = function(self, screenX, screenY)
                return self.graphics:screenToImageCoordinates(screenX, screenY)
            end,

            imageToScreenCoordinates = function(self, imageX, imageY)
                return self.graphics:imageToScreenCoordinates(imageX, imageY)
            end,

            adjustScaleGeometrically = function(self, deltaScale)
                self.graphics:adjustScaleGeometrically(deltaScale)
            end,

            syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
                self.graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
            end,
            
        }
    end,
}

