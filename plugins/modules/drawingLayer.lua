return {
    --[[
        Depends upon these initialization parameters:
        -------------------------------------------------------
        drawingFn      -> Function where drawing is to occur
        -------------------------------------------------------
    --]]
    
    drawingFn = function() end,
	
    init = function(self, params)
        self.drawingFn = params.drawingFn or self.drawingFn
        return self
    end,

    draw = function(self)
        self:drawingFn()
    end,

}
