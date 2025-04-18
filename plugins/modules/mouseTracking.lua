return {
    origX = 0, origY = 0,
    object           = nil,
    
    isFollowingMouse = nil,

    init   = function(self, params)
        self.object = params.object
        self.origX  = params.originX
        self.origY  = params.originY

        return self
    end,

    draw   = function(self)
        self.object:draw()
    end,

    handleKeypressed = function(self, key)
        if key == 'm' then
            self.isFollowingMouse = not self.isFollowingMouse
            if not self.isFollowingMouse then
                self.object:moveTo(self.origX, self.origY)
            end
            self:updateMouseVisibility()
        end
    end,

    updateMouseVisibility = function(self)
        love.mouse.setVisible(not self.isFollowingMouse)
    end,
}
