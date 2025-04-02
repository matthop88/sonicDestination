return {
	
    drawingFn = nil,
	
    init      = function(self, params)
        self.drawingFn = params.drawingFn
        return self
    end,

    draw = function(self)
        self:drawingFn()
    end,

}
