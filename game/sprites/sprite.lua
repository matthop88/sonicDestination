return {
    animations = requireRelative("sprites/animations"):init("sonic1"),
    scale      = { x =  3, y =  3 },

    draw = function(self, x, y)
        self.animations:draw(x, y, self.scale.x, self.scale.y)
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    isXFlipped = function(self)    return self.scale.x < 0                   end,
    flipX      = function(self)    self.scale.x = self.scale.x * -1          end,
          
}
