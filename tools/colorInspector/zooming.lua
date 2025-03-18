local ZOOM_SPEED = 2

ZOOMING = {
    scaleDelta = 0,

    handleKeypressed = function(self, key)
        if     key == "z" then self:startIn()
        elseif key == "a" then self:startOut()
        end
    end,

    handleKeyreleased = function(self, key)
        if     key == "z" then self:stopIn()
        elseif key == "a" then self:stopOut()
        end
    end,
    
    update = function(self, dt)
        if self.scaleDelta ~= 0 then
            self:zoomFromCoordinates(dt, love.mouse.getPosition())
        end
    end,

    zoomFromCoordinates= function(self, dt, screenX, screenY)
        local imageX, imageY = IMAGE_VIEWER:screenToImageCoordinates(screenX, screenY)
        IMAGE_VIEWER:adjustScaleGeometrically(self.scaleDelta * dt)
        IMAGE_VIEWER:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

    startIn  = function(self)  self.scaleDelta =  ZOOM_SPEED end,
    startOut = function(self)) self.scaleDelta = -ZOOM_SPEED end,

    stopIn   = function(self)  self.scaleDelta =  0          end,
    stopOut  = function(self)  self.scaleDelta =  0          end,
}
