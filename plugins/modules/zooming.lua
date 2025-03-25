local ZOOM_SPEED = 2

return {
    --[[
        Depends upon these initialization parameters:
        -------------------------------------------------------
        imageViewer    -> Image Viewer object, with methods
                          screenToImageCoordinates(),
                          adjustScaleGeometrically(),
                          syncImageCoordinatesWithScreen()
        -------------------------------------------------------
    --]]
    
    scaleDelta = 0,

    init             = function(self, params)
        self.imageViewer = params.imageViewer
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
            self:zoomFromCoordinates(dt, love.mouse.getPosition())
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
