local ZOOM_SPEED = 2

return {
    scaleDelta = 0,
    getMousePositionFn = love.mouse.getPosition,

    init = function(self, params)
        self.imageViewer        = params.imageViewer
        self.getMousePositionFn = params.getMousePositionFn or self.getMousePositionFn
        
        return self
    end,
    
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
            self:zoomFromCoordinates(dt, self.getMousePositionFn())
            self:adjustImagePositionIfZoomingOut()
            return true
        end
    end,

    adjustImagePositionIfZoomingOut = function(self)
        if self.scaleDelta < 0 and self.imageViewer.keepImageInBounds then
            self.imageViewer:keepImageInBounds()
        end
    end,

    zoomFromCoordinates= function(self, dt, screenX, screenY)
        local imageX, imageY = self.imageViewer:screenToImageCoordinates(screenX, screenY)
        self.imageViewer:adjustScaleGeometrically(self.scaleDelta * dt)
        self.imageViewer:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

    startIn  = function(self) self.scaleDelta =  ZOOM_SPEED end,
    startOut = function(self) self.scaleDelta = -ZOOM_SPEED end,

    stopIn   = function(self) self.scaleDelta =  0          end,
    stopOut  = function(self) self.scaleDelta =  0          end,
}
