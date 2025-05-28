return {
    animations = requireRelative("sprites/animations"):init("sonic1"),
    scale      = { x =  3, y =  3 },

    frameTimer = 0,
    
    draw = function(self, x, y)
        self.animations:draw(x, y, self.scale.x, self.scale.y)
    end,

    update = function(self, dt)
        -- Increase frame index at a rate of 1 fps
        self.frameTimer = self.frameTimer + dt
        if self.frameTimer >= 1 then
            self.frameTimer = 0
            self.animations:advanceFrame()
        end
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    isXFlipped = function(self)    return self.scale.x < 0                   end,
    flipX      = function(self)    self.scale.x = self.scale.x * -1          end,
          
}
