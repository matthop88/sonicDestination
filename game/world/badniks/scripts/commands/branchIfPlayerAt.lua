local createIsPlayerWithinThresholdFunction = function(deltaX, program)
    return function(badnikX)
        local playerX = GLOBALS:getPlayer():getX() 
        if math.abs(playerX - badnikX) < deltaX then
            return program
        end
    end
end

return function(params)
    return {
        deltaX   = params.deltaX,
        program  = params.program or "default",
        
        execute = function(self, dt, actor, programs)
            programs:getCurrent().playerThresholdBranch = createIsPlayerWithinThresholdFunction(self.deltaX, self.program)
            return true
        end,
    }
end
