return {
	
    init      = function(self, params)
        return {
            drawingFn = params.drawingFn,

            draw = function(self)
                self:drawingFn()
            end,
        }
    end,

}
