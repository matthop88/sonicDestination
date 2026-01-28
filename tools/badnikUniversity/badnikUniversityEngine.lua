local BADNIK = "BADNIK"
local SELECT = "SELECT"
local SOLIDS = "SOLIDS"

local BACKGROUND_COLOR = { 0.24, 0.1, 0.1 }

return {
    create = function(self, params)
        local FILENAME = "untitled"

        return ({
            graphics   = require("tools/lib/graphics"):create(), 
            mode       = SELECT,
            badniks    = require("tools/badnikUniversity/badnikList"),
            solids     = require("tools/badnikUniversity/solidsList"),
            sensorsOn  = false,

            badnikRoster = {
                "motobug",
                "patabata",
            },
            badnikTemplates = require("tools/lib/dataStructures/navigableList"):create {},
            
            init = function(self, params)
                local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                for _, badnikName in ipairs(self.badnikRoster) do
                    local badnikTemplate = require("tools/badnikUniversity/factories/badnikTemplateFactory"):createTemplate(badnikName, self.solids)
                    self.badnikTemplates:add(badnikTemplate)
                    self.badnikTemplates[badnikName] = badnikTemplate
                    self:refreshFromFile(FILENAME)
                end
                return self
            end,

            draw = function(self)
                self:drawBackground()
                self:drawWorld()
                self:drawMode()
                self:drawSelectedElements()
                if self.sensorsOn then self:drawSensors() end
            end,

            drawBackground = function(self)
                love.graphics.setColor(BACKGROUND_COLOR)
                love.graphics.rectangle("fill", 0, 0, 1200, 800)
            end,

            drawWorld = function(self)
                self.badniks:draw(self.graphics)
                self.solids:draw(self.graphics)
            end,

            drawMode = function(self)
                if     self.mode == SELECT then self:drawSelectMode()
                elseif self.mode == BADNIK then self:drawBadnikMode()
                elseif self.mode == SOLIDS then self:drawSolidsMode() end
            end,

            drawSelectMode = function(self)
                love.mouse.setVisible(true)
                self.badniks:drawMouseOver(self.graphics)
                self.solids:drawMouseOver(self.graphics)
            end,

            drawBadnikMode = function(self)
                love.mouse.setVisible(false)
                local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                self.badnikTemplates:get():drawPreviewSprite(self.graphics, math.floor(x), math.floor(y))
            end,

            drawSolidsMode = function(self)
                self.solids:drawCursor(self.graphics)
            end,

            drawSelectedElements = function(self)
                self.badniks:drawSelected(self.graphics)
                self.solids:drawSelected(self.graphics)
            end,

            drawSensors = function(self)
                self.badniks:drawSensors(self.graphics)
                self.solids:drawScanTrail(self.graphics)
            end,

            update = function(self, dt)
                self.badniks:update(dt, self.graphics)
                self.solids:update(dt, self.graphics)
            end,

            handleKeypressed = function(self, key)
                if     key == "R" then self:refreshFromFile(FILENAME)
                elseif key == "G" then self.badniks:toggleRunning()
                else
                    if     self.mode == SELECT then self:handleKeypressedSelectMode(key)
                    elseif self.mode == BADNIK then self:handleKeypressedBadnikMode(key)
                    elseif self.mode == SOLIDS then self:handleKeypressedSolidsMode(key) end
                end
            end,

            handleKeypressedSelectMode = function(self, key)
                if     key == "b"          then 
                    self.mode = BADNIK
                    self.solids:deselect()
                elseif key == "s"          then 
                    self.mode = SOLIDS
                    self.solids:deselect()
                elseif key == "S"          then self:toggleSensors()
                elseif key == "x"          then self:flipSelectedBadnik()
                elseif key == "escape"     then 
                    self.badniks:deselect()
                    self.solids:deselect()
                elseif key == "backspace"  then self:deleteSelected()
                elseif key == "shiftleft"  then self:nudgeSelectedBadnik(-1,  0)
                elseif key == "shiftright" then self:nudgeSelectedBadnik( 1,  0)
                elseif key == "shiftup"    then self:nudgeSelectedBadnik( 0, -1)
                elseif key == "shiftdown"  then self:nudgeSelectedBadnik( 0,  1)
                end
            end,

            flipSelectedBadnik = function(self)
                self.badniks:flipSelected()
                self:writeToFile(FILENAME)
            end,

            deleteSelected = function(self)
                self.badniks:deleteSelected()
                self.solids:deleteSelected()
                self:writeToFile(FILENAME)
            end,

            nudgeSelectedBadnik = function(self, dx, dy)
                self.badniks:nudgeSelected(dx, dy)
                self:writeToFile(FILENAME)
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
                    self:placeBadnik(self:screenToImageCoordinates(mx, my))
                    self.mode = SELECT
                elseif self.mode == SOLIDS then
                    self:addSolid(self:screenToImageCoordinates(mx, my))
                else
                    self.solids:deselect()
                    if not self.badniks:selectBadnikAt(mx, my, self.graphics) then
                        self.solids:selectSolidAt(mx, my, self.graphics)
                    end
                    self.mode = SELECT
                end
            end,

            placeBadnik = function(self, x, y)
                self.badniks:placeBadnik(self.badnikTemplates:get():create(math.floor(x), math.floor(y)), self.graphics)
                self:writeToFile(FILENAME)
            end,

            addSolid = function(self, x, y)
                self.solids:add(x, y)
                self:writeToFile(FILENAME)
            end,

            handleMousereleased = function(self, mx, my)
                -- mouse released functionality goes here
            end,

            toggleSensors = function(self)
                self.sensorsOn = not self.sensorsOn
            end,

            getBadnikList = function(self)
                return self.badniks
            end,

            writeToFile = function(self, filename)
                love.filesystem.createDirectory("tools/badnikUniversity/labs")
                local data = self:encodeData()
                print(data)
                love.filesystem.write("tools/badnikUniversity/labs/" .. filename .. ".lua", data)
                print("Saved to " .. love.filesystem.getSaveDirectory())
            end,

            encodeData = function(self)
                local stringData = "return {\n"
                stringData = stringData .. self.badniks:getStringData()
                stringData = stringData .. self.solids:getStringData()
                return stringData .. "}"
            end,

            refreshFromFile = function(self, filename)
                local labData = dofile(love.filesystem.getSaveDirectory() .. "/tools/badnikUniversity/labs/" .. filename .. ".lua")
                self.badniks:refreshFromData(labData.badniks, self.badnikTemplates, self.graphics)
                self.solids:refreshFromData(labData.solids)
                self.mode = SELECT
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

