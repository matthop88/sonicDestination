return {

    drawingFn = nil,
	
    init = function(self, drawingFn)
        self.drawingFn = drawingFn
        return self
    end,

    draw = function(self)
        self:drawingFn()
    end,

}
