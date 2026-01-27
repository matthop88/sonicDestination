local STRING_UTIL   = require("tools/lib/stringUtil")
local NO_BUMP_ID    = true

local SCRIPT_ENGINE = require("game/world/badniks/scripts/lib/scriptEngine")
local SCRIPT_REPO   = require("game/world/badniks/scripts/lib/scriptRepo")

return {
    createTemplate = function(self, name)
        local badnikData = require("tools/badnikUniversity/factories/badniks/" .. name)

        return {
            name          = badnikData.name,
            path          = badnikData.path,
            scriptName    = badnikData.script,
            spritePreview = require("tools/lib/sprites/sprite"):create(badnikData.path, 0, 0, NO_BUMP_ID),
            xFlip         = false,
            
            drawPreviewSprite = function(self, GRAFX, x, y)
                GRAFX:setColor(1, 1, 1)
                self.spritePreview:drawThumbnail(GRAFX, x, y, 1, 1)
            end,

            flipX = function(self) 
                self.spritePreview:flipX() 
                self.xFlip = not self.xFlip
            end,

            create = function(self, x, y)
                local sprite = require("tools/lib/sprites/sprite"):create(self.path, x, y)
                if self.xFlip then sprite:flipX() end

                return {
                    name            = self.name,
                    capitalizedName = STRING_UTIL:capitalize(self.name),
                    x               = x,
                    y               = y,
                    xFlip           = self.xFlip,
                    sprite          = sprite,
                    xSpeed          = 0,
                    ySpeed          = 0,

                    script          = SCRIPT_REPO:get(self.scriptName),

                    getX    = function(self) return self.x                  end,
                    getY    = function(self) return self.y                  end,
                    getXInt = function(self) return math.floor(self:getX()) end,
                    getYInt = function(self) return math.floor(self:getY()) end,

                    setX  = function(self, x)     
                        self.x = x 
                        self.sprite:setX(x)
                    end,

                    setY  = function(self, y)     
                        self.y = y 
                        self.sprite:setY(y)
                    end,

                    getW  = function(self) return self.sprite:getW() end,
                    getH  = function(self) return self.sprite:getH() end,
                    draw  = function(self, GRAFX)
                        self.sprite:draw(GRAFX)
                    end,

                    getXVelocity = function(self)         
                        if   self.xFlip then return  self.xSpeed   
                        else                 return -self.xSpeed end
                    end,

                    setXSpeed = function(self, xSpeed) self.xSpeed = xSpeed end,
                    
                    getYSpeed = function(self)         return self.ySpeed   end,
                    setYSpeed = function(self, ySpeed) self.ySpeed = ySpeed end,

                    isInside = function(self, x, y)
                        return x >= self.x - self.sprite:getW() / 2
                           and x <  self.x + self.sprite:getW() / 2
                           and y >= self.y - self.sprite:getH() / 2
                           and y <  self.y + self.sprite:getH() / 2
                    end,

                    flipX = function(self) 
                        self.sprite:flipX() 
                        self.xFlip = not self.xFlip
                    end,

                    drawThumbnail = function(self, GRAFX, x, y, sX, sY)
                        self.sprite:drawThumbnail(GRAFX, x, y, sX, sY)
                    end,

                    update = function(self, dt)
                        if self.script then
                            SCRIPT_ENGINE:execute(dt, self.script.program, self)
                            self.sprite:update(dt)
                        end
                        self:setX(self:getX() + (self:getXVelocity() * dt))
                        self:setY(self:getY() + (self:getYSpeed()    * dt))
                    end,

                    getID = function(self) return self.sprite:getID() end,

                    getPublicAttributes = function(self)
                        -- Can either return a field or a function.
                        -- Functions can be repeatedly called for refreshing values.
                        return {
                            { name   = self.capitalizedName, },
                            { x      = self.getXInt, },
                            { y      = self.getYInt, },
                            { script = {
                                    selected = self.script.name,
                                    options  = SCRIPT_REPO.scriptNames,
                                }
                            },
                        }
                    end,

                    getStringData = function(self)
                        local xFlipString = "false"
                        if self.xFlip then xFlipString = "true" end
                        return "{ name = \"" .. self.name .. "\", x = " .. x .. ", y = " .. y .. ", xFlip = " .. xFlipString .. " }"
                    end,
                }
            end,
        }
    end,
}
