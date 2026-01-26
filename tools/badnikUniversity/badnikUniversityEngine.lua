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
            solids          = require("tools/lib/dataStructures/linkedList"):create(),
            
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
                self.solids:forEach(function(s) self:drawSolidAt(s.x, s.y) end)

                if     self.mode == SELECT then self:drawSelectMode()
                elseif self.mode == BADNIK then self:drawBadnikMode()
                elseif self.mode == SOLIDS then self:drawSolidsMode()
                end
                
                self.badniks:drawSelected(self.graphics)
            end,

            drawSelectMode = function(self)
                love.mouse.setVisible(true)
                self.badniks:drawMouseOver(self.graphics)
            end,

            drawBadnikMode = function(self)
                love.mouse.setVisible(false)
                local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                self.badnikTemplates:get():drawPreviewSprite(self.graphics, math.floor(x), math.floor(y))
            end,

            drawSolidsMode = function(self)
                love.mouse.setVisible(false)
                local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                self.graphics:setColor(1, 1, 0, 0.7)
                self.graphics:setLineWidth(2)
                x = math.floor((x + 8) / 16) * 16
                y = math.floor((y + 8) / 16) * 16
                self.graphics:line(x, y, x + 16, y)
            end,

            drawSolidAt = function(self, x, y)
                self.graphics:setColor(1, 1, 1)
                self.graphics:setLineWidth(2)
                self.graphics:line(x, y, x + 16, y)
            end,

            update = function(self, dt)
                self.badniks:update(dt, self.graphics)
            end,

            handleKeypressed = function(self, key)
                if     self.mode == SELECT then self:handleKeypressedSelectMode(key)
                elseif self.mode == BADNIK then self:handleKeypressedBadnikMode(key)
                elseif self.mode == SOLIDS then self:handleKeypressedSolidsMode(key)
                end
            end,

            handleKeypressedSelectMode = function(self, key)
                if     key == "b"          then self.mode = BADNIK
                elseif key == "s"          then self.mode = SOLIDS
                elseif key == "x"          then self.badniks:flipSelected()
                elseif key == "escape"     then self.badniks:deselect()
                elseif key == "backspace"  then self.badniks:deleteSelected()
                elseif key == "shiftleft"  then self.badniks:nudgeSelected(-1,  0)
                elseif key == "shiftright" then self.badniks:nudgeSelected( 1,  0)
                elseif key == "shiftup"    then self.badniks:nudgeSelected( 0, -1)
                elseif key == "shiftdown"  then self.badniks:nudgeSelected( 0,  1)
                end
            end,

            handleKeypressedBadnikMode = function(self, key)
                if     key == "b"        then self.mode = SELECT
                elseif key == "s"        then self.mode = SOLIDS
                elseif key == "x"        then self.badnikTemplates:get():flipX()
                elseif key == "tab"      then self.badnikTemplates:next()
                elseif key == "shifttab" then self.badnikTemplates:prev()
                elseif key == "escape"   then self.mode = SELECT
                end
            end,

            handleKeypressedSolidsMode = function(self, key)
                if     key == "b"        then self.mode = BADNIK
                elseif key == "s"        then self.mode = SELECT
                elseif key == "escape"   then self.mode = SELECT
                end
            end,

            handleMousepressed = function(self, mx, my)
                if     self.mode == BADNIK then
                    local x, y = self:screenToImageCoordinates(mx, my)
                    self.badniks:placeBadnik(self.badnikTemplates:get():create(math.floor(x), math.floor(y)), self.graphics)
                    self.mode = SELECT
                elseif self.mode == SOLIDS then
                    local x, y = self:screenToImageCoordinates(mx, my)
                    self.solids:add({ x = math.floor((x + 8) / 16) * 16, y = math.floor((y + 8) / 16) * 16 })
                else
                    self.badniks:selectBadnikAt(mx, my, self.graphics)
                    self.mode = SELECT
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

