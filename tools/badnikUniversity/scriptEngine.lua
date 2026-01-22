return {
    execute = function(self, dt, program, actor)
        local instruction = program:get()
        if instruction:execute(dt, actor) then
            program:next()
        end
    end,
}
