
return {
    create = function(self, params)
        return ({
            graphics   = require("tools/lib/graphics"):create(), 
            badnikMode = false,
            badniks    = require("tools/badnikUniversity/badnikList"),
            badnikRoster = {
                "motobug",
                "patabata",
            },
            badnikTemplates = {
                index = 1,
                get  = function(self) return self[self.index] end,
                next = function(self)
                    self.index = self.index + 1
                    if self.index > #self then self.index = 1 end
                end,
                prev = function(self)
                    self.index = self.index - 1
                    if self.index < 1 then self.index = #self end
                end,
            },
            
            init = function(self, params)
                local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                for _, badnikName in ipairs(self.badnikRoster) do
                    table.insert(self.badnikTemplates, require("tools/badnikUniversity/factories/badnikTemplateFactory"):createTemplate(badnikName))
                end
                return self
            end,

            draw = function(self)
                love.graphics.setColor(0.24, 0.1, 0.1)
                love.graphics.rectangle("fill", 0, 0, 1200, 800)
                
                self.badniks:draw(self.graphics)

                if self.badnikMode then
                    love.mouse.setVisible(false)
                    local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                    self.badnikTemplates:get():drawPreviewSprite(self.graphics, math.floor(x), math.floor(y))
                else
                    love.mouse.setVisible(true)
                end
            end,

            update = function(self, dt)
                -- update functionality goes here
            end,

            handleKeypressed = function(self, key)
                if key == "b" then
                    self.badnikMode = not self.badnikMode
                elseif key == "x" and self.badnikMode then
                    self.badnikTemplates:get():flipX()
                elseif key == "tab" and self.badnikMode then
                    self.badnikTemplates:next()
                elseif key == "shifttab" and self.badnikMode then
                    self.badnikTemplates:prev()
                end
            end,

            handleMousepressed = function(self, mx, my)
                if self.badnikMode then
                    local x, y = self:screenToImageCoordinates(mx, my)
                    self.badniks:placeBadnik(self.badnikTemplates:get():create(math.floor(x), math.floor(y)), self.graphics)
                    self.badnikMode = false
                end
            end,

            handleMousereleased = function(self, mx, my)
                -- mouse released functionality goes here
            end,

            ---------------------- Graphics Object Methods ------------------------

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

        }):init(params)
    end,
}

