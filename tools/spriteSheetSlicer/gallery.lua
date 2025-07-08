local Editor = require "tools/spriteSheetSlicer/editor"

local GallerySlot = {
    create = function(self, index, x, y, w, h, image, spriteRect)
        local scale     = 1
        local maxScale  = 2.5
        local zoomSpeed = 18
        
        return {
            getImage      = function(self) return image      end,
            getSpriteRect = function(self) return spriteRect end,
            getIndex      = function(self) return index      end,
            
            draw = function(self)
                self:drawBorder()
                self:drawSprite()
            end,

            update = function(self, dt)
                if self:isInsideRect(love.mouse.getPosition()) then scale = math.min(maxScale, scale + (dt * zoomSpeed))
                else                                                scale = math.max(1,        scale - (dt * zoomSpeed))   end
            end,

            mousepressed = function(self, mx, my)
                return self:isInsideRect(mx, my)
            end,
            
            drawBorder = function(self)
                love.graphics.setColor(1, 1, 1)
                love.graphics.setLineWidth(2)
                love.graphics.rectangle("line", x, y, w, h)
            end,

            drawSprite = function(self)
                love.graphics.draw(image, spriteRect.quad, 
                           x + (w / 2) - (spriteRect.w * scale / 2), 
                           y + (h / 2) - (spriteRect.h * scale / 2), 0, scale, scale)
            end,

            isInsideRect = function(self, px, py)
                return px >= x and px <= x + w and py >= y and py <= y + h
            end,
        }
    end,
}

return {
    slots  = {
        index = 1,

        setIndex = function(self, index)
            self.index = index
        end,
        
        next = function(self)
            self.index = self.index + 1
            if self.index > #self then self.index = 1 end

            return self[self.index]
        end,

        prev = function(self)
            self.index = self.index - 1
            if self.index < 1 then self.index = #self end

            return self[self.index]
        end,
    },
    
    editor = Editor:create(),

    init = function(self, spriteRects)
        local image = getImageViewer():getImage()
        for n, spriteRect in ipairs(spriteRects) do
            spriteRect.quad = self:createQuad(spriteRect, image)
            table.insert(self.slots, GallerySlot:create(n, (n * 73) - 65, 696, 60, 60, image, spriteRect))
        end
        return self
    end,

    createQuad = function(self, spriteRect, image)
        return love.graphics.newQuad(spriteRect.x, spriteRect.y, spriteRect.w, spriteRect.h,
                                     image:getWidth(), image:getHeight())
    end,
    
    draw = function(self)
        self:drawBackground()
        self:drawSlotBorders()
        self:drawSprites()
        self.editor:draw()
    end,

    update = function(self, dt)
        for _, gallerySlot in ipairs(self.slots) do
            gallerySlot:update(dt)
        end
    end,

    mousepressed = function(self, mx, my)
        if self.editor:mousepressed(mx, my) then
            return true
        end
        for _, gallerySlot in ipairs(self.slots) do
            if gallerySlot:mousepressed(mx, my) then
                self.editor:setActive(true)
                self:updateEditor(gallerySlot)
                self.gallerySlots:setIndex(gallerySlot:getIndex())
                return true
            end
        end
        self.editor:setActive(false)
    end,

    keypressed = function(self, key)
        if self.editor:keypressed(key) then
            local gallerySlot
            if     key == "left"  then gallerySlot = self.slots:prev()
            elseif key == "right" then gallerySlot = self.slots:next() end

            if gallerySlot ~= nil then self:updateEditor(gallerySlot)  end
            
            return true
        end
    end,

    updateEditor = function(self, gallerySlot)
        self.editor:setSprite(gallerySlot:getImage(), gallerySlot:getSpriteRect())
    end,
        
    drawBackground = function(self)
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 684, 1024, 86)
        love.graphics.setColor(1, 1, 1)
    end,

    drawSlotBorders = function(self)
        for _, gallerySlot in ipairs(self.slots) do
            gallerySlot:drawBorder()
        end
    end,

    drawSprites = function(self)
        for _, gallerySlot in ipairs(self.slots) do
            gallerySlot:drawSprite()
        end
    end,
}
