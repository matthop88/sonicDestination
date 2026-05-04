return function(params)
    return {
        program  = params.program or "default",
        
        execute = function(self, dt, actor, programs)
            programs:setCurrent(self.program)
            return true
        end,
    }
end
