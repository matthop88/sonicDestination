local BADNIK = "BADNIK"
local SELECT = "SELECT"
local SOLIDS = "SOLIDS"

return {
    create = function(self, params)
        return ({
            graphics   = require("tools/lib/graphics"):create(), 
            mode       = SELECT,
            badniks    = require("tools/badnikUniversity/badnikList"),
            badnikRoster = {
                "motobug",
                "patabata",
            },
            badnikTemplates = require("tools/lib/dataStructures/navigableList"):create {},
            
            init = function(self, params)
                local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                for _, badnikName in ipairs(self.badnikRoster) do
                    self.badnikTemplates:add(require("tools/badnikUniversity/factories/badnikTemplateFactory"):createTemplate(badnikName))
                end
                return self
            end,

            draw = function(self)
                love.graphics.setColor(0.24, 0.1, 0.1)
                love.graphics.rectangle("fill", 0, 0, 1200, 800)
                
                self.badniks:draw(self.graphics)

                if self.mode == BADNIK then
                    love.mouse.setVisible(false)
                    local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                    self.badnikTemplates:get():drawPreviewSprite(self.graphics, math.floor(x), math.floor(y))
                else
                    self.badniks:drawMouseOver(self.graphics)
                    love.mouse.setVisible(true)
                end

                self.badniks:drawSelected(self.graphics)
            end,

            update = function(self, dt)
                self.badniks:update(dt, self.graphics)
            end,

            handleKeypressed = function(self, key)
                if key == "b" then
                    if   self.mode == BADNIK then self.mode = SELECT
                    else                          self.mode = BADNIK end
                elseif key == "x" then
                    if self.mode == BADNIK then self.badnikTemplates:get():flipX()
                    else                        self.badniks:flipSelected()    end
                elseif key == "tab" and self.mode == BADNIK then
                    self.badnikTemplates:next()
                elseif key == "shifttab" and self.mode == BADNIK then
                    self.badnikTemplates:prev()
                elseif key == "escape" then
                    if   self.mode == SELECT then self.badniks:deselect()
                    else                          self.mode = SELECT  end 
                elseif key == "backspace" and self.mode == SELECT then
                    self.badniks:deleteSelected()
                elseif key == "shiftleft"  and self.mode == SELECT then self.badniks:nudgeSelected(-1,  0)
                elseif key == "shiftright" and self.mode == SELECT then self.badniks:nudgeSelected( 1,  0)
                elseif key == "shiftup"    and self.mode == SELECT then self.badniks:nudgeSelected( 0, -1)
                elseif key == "shiftdown"  and self.mode == SELECT then self.badniks:nudgeSelected( 0,  1)
                end
            end,

            handleMousepressed = function(self, mx, my)
                if self.mode == BADNIK then
                    local x, y = self:screenToImageCoordinates(mx, my)
                    self.badniks:placeBadnik(self.badnikTemplates:get():create(math.floor(x), math.floor(y)), self.graphics)
                    self.mode = SELECT
                else
                    self.badniks:selectBadnikAt(mx, my, self.graphics)
                end
            end,

            handleMousereleased = function(self, mx, my)
                -- mouse released functionality goes here
            end,

            getBadnikList = function(self)
                return self.badniks
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

