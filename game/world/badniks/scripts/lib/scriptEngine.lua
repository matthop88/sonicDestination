return {
    execute = function(self, dt, programs, actor)
        local program = programs:getCurrent()
        if program.playerThresholdBranch then
            local targetProg = program.playerThresholdBranch(actor:getX(), actor:getY(), actor.xFlip)
            if targetProg then
                programs:setCurrent(targetProg)
                program = programs:getCurrent()
            end
        end
        local instruction = program:get()
        if instruction:execute(dt, actor, programs) then
            program:next()
        end
    end,
}
