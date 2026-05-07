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
            graphics   = params.graphics,
            objects    = require("game/util/dataStructures/linkedList"):create(),  
            fontEngine = require("tools/fontBlaster/fontEngine"):create(),
    
            init = function(self)
                self.objects:add(self:newFontBlock(hudTemplate, 300,  75))
                self.objects:add(self:newFontBlock(captions1,   300, 300))
                self.objects:add(self:newFontBlock(time1,       100, 100))
                self.objects:add(self:newFontBlock(time2,       100, 120))
                self.objects:add(self:newFontBlock(credits,     200,  50))
                self.objects:add(self:newFontBlock(lifeHud,     200, 100))
                return self
            end,

            newFontBlock = function(self, objectData, x, y)
                local fontObject = self.fontEngine:newFontObject(objectData)
                return require("tools/fontBlaster/fontBlock"):create { fontObj = fontObject, x = x, y = y, graphics = self.graphics }
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
                else                            self:handleKeyTyped(self:getSelected(), key)
                end
            end,

            handleMousepressed = function(self, mx, my, params)
                local selectedObj = nil
                self.objects:forEach(function(obj)
                    obj:deselect()
                    if obj:mouseInBounds(mx, my) then
                        selectedObj = obj
                        if params.doubleClicked then 
                            obj:startEditing()
                        end
                    else
                        obj:stopEditing()
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
                if obj ~= nil then 
                    if obj:isEditing() then
                        obj:deleteLastGlyph()
                    else
                        obj:setDeleted() 
                    end
                end
            end,

            nudge = function(self, obj, deltaX, deltaY)
                if obj ~= nil then obj:nudge(deltaX, deltaY) end
            end,

            deselectAll = function(self)
                self.objects:forEach(function(obj)
                    if obj:isEditing() then
                        obj:revert()
                        obj:stopEditing()
                    end
                    obj:deselect()
                end)
            end,

            handleKeyTyped = function(self, obj, key)
                if obj ~= nil and obj:isEditing() then
                    obj:appendGlyph(key)
                end
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

