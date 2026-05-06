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

        return {
            graphics = params.graphics,
            objects  = { },
            
            init = function(self)
                self.fontEngine = require("tools/fontBlaster/fontEngine"):create()
                table.insert(self.objects, self.fontEngine:newFontBlock(self.graphics, captions1, 300, 300))
                table.insert(self.objects, self.fontEngine:newFontBlock(self.graphics, time1,     100, 100))
                table.insert(self.objects, self.fontEngine:newFontBlock(self.graphics, time2,     100, 120))
                table.insert(self.objects, self.fontEngine:newFontBlock(self.graphics, credits,   200, 50))
                table.insert(self.objects, self.fontEngine:newFontBlock(self.graphics, lifeHud,   200, 100))
                return self
            end,

            draw = function(self)
                self:drawBackground()
                for _, obj in ipairs(self.objects) do
                    obj:draw()
                end
            end,

            drawBackground = function(self)
                love.graphics.clear(COLOR_SKY_BLUE)
            end,

            update = function(self, dt)
                for _, obj in ipairs(self.objects) do
                    obj:update(dt)
                end
            end,

            handleKeypressed = function(self, key)
                if key == "escape" then
                    self:deselectAll()
                end
            end,

            handleMousepressed = function(self, mx, my)
                for _, obj in ipairs(self.objects) do
                    obj:mousepressed(mx, my)
                end
            end,

            handleMousereleased = function(self, mx, my)
                -- Do nothing
            end,

            deselectAll = function(self)
                for _, obj in ipairs(self.objects) do
                    obj:deselect()
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

