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
            
            drawBorder = function(self, selectedIndex)
                if selectedIndex == index then 
                    love.graphics.setColor(1, 1, 0)
                    love.graphics.setLineWidth(4)
                else                           
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.setLineWidth(2)
                end
                love.graphics.rectangle("line", x, y, w, h)
            end,

            drawSprite = function(self)
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(image, spriteRect.quad, 
                           x + (w / 2) - (spriteRect.w * scale / 2), 
                           y + (h / 2) - (spriteRect.h * scale / 2), 0, scale, scale)
            end,

            isInsideRect = function(self, px, py)
                return px >= x and px <= x + w and py >= y and py <= y + h
            end,

            printStats = function(self)
                print("{ x = " .. spriteRect.x .. ", y = " .. spriteRect.y .. ", w = " .. spriteRect.w .. ", h = " .. spriteRect.h 
                        .. ", offset = { x = " .. spriteRect.offset.x .. ", y = " .. spriteRect.offset.y .. " }, },")
            end,
        }
    end,
}

return {
    slots  = {
        index = 1,

        contents = {},

        clear = function(self)
            self.contents = { }
        end,

        getIndex = function(self)        return self.index  end,
        setIndex = function(self, index) self.index = index end,
        
        next = function(self)
            self.index = self.index + 1
            if self.index > #self.contents then self.index = 1 end

            return self.contents[self.index]
        end,

        prev = function(self)
            self.index = self.index - 1
            if self.index < 1 then self.index = #self.contents end

            return self.contents[self.index]
        end,

        this = function(self)
            self.index = math.min(#self.contents, self.index)
            return self.contents[self.index]
        end,

        add = function(self, element)
            table.insert(self.contents, element)
        end,

        get = function(self)
            return self.contents
        end,
    },
    
    editor = Editor:create(),

    init = function(self, spriteRects)
        self:refresh(spriteRects)
        return self
    end,

    refresh = function(self, spriteRects)
        if spriteRects then
            self.slots:clear()
            local image = getImageViewer():getImage()
            for n, spriteRect in ipairs(spriteRects) do
                spriteRect.quad = self:createQuad(spriteRect, image)
    
                if not spriteRect.offset then
                    spriteRect.offset = { x = math.floor(spriteRect.w / 2), y = math.floor(spriteRect.h / 2) }
                end
                
                self.slots:add(GallerySlot:create(n, (n * 73) - 65, 696, 60, 60, image, spriteRect))
            end
        end
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
        for _, gallerySlot in ipairs(self.slots:get()) do gallerySlot:update(dt) end
    end,

    mousepressed = function(self, mx, my)
        if self.editor:mousepressed(mx, my) then return true end
        for _, gallerySlot in ipairs(self.slots:get()) do
            if gallerySlot:mousepressed(mx, my) then
                self.editor:setActive(true)
                self:updateEditor(gallerySlot)
                self.slots:setIndex(gallerySlot:getIndex())
                return true
            end
        end
        self.editor:setActive(false)
    end,

    keypressed = function(self, key)
        if     key == "escape"             then self.editor:setActive(false)
        elseif self.editor:keypressed(key) then return self:handleKeypressedInEditor(key)
        elseif key == "x"                  then self:printOutGalleryStats()
        end
    end,

    handleKeypressedInEditor = function(self, key)
        local mx, my = love.mouse.getPosition()
        if self.editor:isInsideInnerRect(mx, my) then
            local gallerySlot = self:navigateGallery(key)
            self:updateEditor(gallerySlot)
            return false
        else
            return true
        end
    end,

    navigateGallery = function(self, key)
        if     key == "left"  then return self.slots:prev()
        elseif key == "right" then return self.slots:next() end
    end,

    updateEditor = function(self, gallerySlot)
        gallerySlot = gallerySlot or self.slots:this()
        self.editor:setSprite(gallerySlot:getImage(), gallerySlot:getSpriteRect())
    end,
        
    drawBackground = function(self)
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 684, 1024, 86)
        love.graphics.setColor(1, 1, 1)
    end,

    drawSlotBorders = function(self)
        for _, gallerySlot in ipairs(self.slots:get()) do gallerySlot:drawBorder(self.slots:getIndex()) end
    end,

    drawSprites = function(self)
        for _, gallerySlot in ipairs(self.slots:get()) do gallerySlot:drawSprite() end
    end,

    printOutGalleryStats = function(self)
        for _, gallerySlot in ipairs(self.slots:get()) do gallerySlot:printStats() end
    end,
}
