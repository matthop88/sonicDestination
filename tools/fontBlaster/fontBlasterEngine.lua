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

        return {
            graphics = params.graphics,
            
            init = function(self)
                self.fontEngine = require("tools/fontBlaster/fontEngine"):create()
                print("INITIALIZED FONT ENGINE")
                return self
            end,

            draw = function(self)
                self:drawBackground()
                if self.fontEngine then
                    self.fontEngine:draw(self.graphics, "captions1", captions1, 300, 300)
                    self.fontEngine:draw(self.graphics, "time1",     time1,     100, 100)
                    self.fontEngine:draw(self.graphics, "time2",     time2,     100, 120)
                end
            end,

            drawBackground = function(self)
                love.graphics.clear(COLOR_SKY_BLUE)
            end,

            update = function(self, dt)
                -- Do nothing
            end,

            handleKeypressed = function(self, key)
                -- Do nothing
            end,

            handleMousepressed = function(self, mx, my)
                -- Do nothing
            end,

            handleMousereleased = function(self, mx, my)
                -- Do nothing
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

