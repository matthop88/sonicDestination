local createIsPlayerWithinThresholdFunction = function(deltaX, program)
    return function(badnikX, badnikY, xFlip)
        local playerX = GLOBALS:getPlayer():getX() 
        local playerY = GLOBALS:getPlayer():getY()
        if math.abs(playerY - badnikY) < 50 then
            if badnikX - playerX > 0 and badnikX - playerX < deltaX and not xFlip then
                return program
            elseif playerX - badnikX > 0 and playerX - badnikX < deltaX and xFlip then
                return program
            end
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
