local GRAPHICS
local TERRAIN
local WORKSPACE
local BACKGROUND
local OBJECT_FACTORY = requireRelative("world/gameObjects/objectFactory")
local SOUND_MANAGER
local MUSIC_MANAGER
local ORIGIN

return {
    collisionHandler = requireRelative("collision/collisionHandler"),

    objects = nil,

    events  = {},

    GROUND_LEVEL = 940,

    fadeLayer = { 
        color    = { r = 1, g = 1, b = 1 }, 
        alpha    = 0,
        speed    = 1,
        velocity = 0,

        draw = function(self)
            GRAPHICS:setColor(self.color.r, self.color.g, self.color.b, self.alpha)
            GRAPHICS:rectangle("fill", GRAPHICS:calculateViewport())
        end,

        update = function(self, dt)
            self.alpha = self.alpha + (self.velocity * dt)
            if     self.alpha > 1 then self.alpha = 1
            elseif self.alpha < 0 then self.alpha = 0 end
        end,

        fadeOut = function(self) self.velocity =  self.speed end,
        fadeIn  = function(self) self.velocity = -self.speed end,
    },

    init = function(self, params)
        GRAPHICS      = params.GRAPHICS
        SOUND_MANAGER = params.SOUND_MANAGER
        MUSIC_MANAGER = params.MUSIC_MANAGER
        local mapName = __MAP_NAME or "scdPtp1"  -- Use global if set, otherwise default
        TERRAIN  = requireRelative("world/terrain/terrain", { GRAPHICS = GRAPHICS, map = mapName, })
        WORKSPACE = requireRelative("world/workspace",      { GRAPHICS = GRAPHICS })
        BACKGROUND = requireRelative("world/background/backgroundEngine"):createFromFile("ghzBG")
        self:refreshMusic()
        self:refreshSounds()
        self:refreshGroundLevel()
        
        return self
    end,

    refreshObjectsMap = function(self, x, y)
        local objectsMap = requireRelative("resources/zones/objects/" .. TERRAIN:getObjectsDataName())
        self.origin = objectsMap.origin or { x = 512, y = 0 }
        if not x then
            x, y = self.origin.x, self.origin.y
        end
        local sprite = self.origin and self.origin.sprite or "sonic1"
        GLOBALS:getPlayer():initPosition(x, y, false, sprite)
        GRAPHICS:setX(math.min(0, -x + 200))
        GRAPHICS:setY(-y + 200)

        self.objects = dofile(relativePath("util/dataStructures/linkedList.lua")):create()
        for _, objectData in ipairs(objectsMap) do
            self.objects:add(OBJECT_FACTORY:create(objectData, GRAPHICS, self))
        end
    end,

    refreshMusic = function(self)
        local map = TERRAIN:getMapData()

        if map.properties and map.properties.music then
            MUSIC_MANAGER:clear()
            MUSIC_MANAGER:newTrack(
                map.properties.music, 
                map.properties.musicEffect, 
                map.properties.musicDelay or 0.5, 
                map.properties.musicStrength or 0.5,
                map.properties.musicEchoCount or 6
            )
            
            local volume = map.properties.musicVolume or 1.0
            local pitch = map.properties.musicPitch or 1.0
            MUSIC_MANAGER:setVolume(volume)
            MUSIC_MANAGER:setPitch(pitch)
            
            MUSIC_MANAGER:play()
        end
    end,

    refreshSounds = function(self)
        local map = TERRAIN:getMapData()

        if map.properties then
            SOUND_MANAGER:overrideFromSoundProps(map.properties.sounds)
        end
    end,

    reset = function(self, map, x, y)
        if map then
            TERRAIN:init { GRAPHICS = GRAPHICS, map = map }
            self:refreshMusic()
            self:refreshGroundLevel()
        end
        self:refreshObjectsMap(x, y)
    end,

    draw = function(self)
        BACKGROUND:draw(GRAPHICS)
        TERRAIN:draw()
        WORKSPACE:draw()
        self.objects:head()
        while not self.objects:isEnd() do
            local object = self.objects:getNext()
            if not object:isForeground() then object:draw() end
        end
    end,

    drawForeground = function(self)
        self.objects:head()
        while not self.objects:isEnd() do
            local object = self.objects:getNext()
            if object:isForeground() then object:draw(SHOW_HITBOXES) end
        end
        self.fadeLayer:draw()
    end,

    drawHitBoxes = function(self)
        self.objects:head()
        while not self.objects:isEnd() do
            self.objects:getNext():drawHitBox()
        end
    end,

    drawSolidAt = function(self, x, y, color) TERRAIN:drawSolidAt(x, y, color) end,

    update = function(self, dt)
        TERRAIN:update(dt)
        self.objects:head()
        while not self.objects:isEnd() do
            local object = self.objects:get()
            object:update(dt)
            if object.deleted then self.objects:remove()
            else                   self.objects:next()   end
        end
        self.fadeLayer:update(dt)
        self:updateEvents(dt)
        SOUND_MANAGER:update(dt)
        MUSIC_MANAGER:update(dt)
    end,

    updateEvents = function(self, dt)
        for _, evt in ipairs(self.events) do
            evt:update(dt)
        end
    end,

    checkCollisions = function(self, otherObject)
        local otherHitBox = otherObject:getHitBox()
        local firstHitBox = nil
        self.objects:forEach(function(object)
            if object ~= otherObject then
                local hitBox = object:getHitBox()
                if hitBox and hitBox:intersects(otherHitBox) then
                    if otherObject:isPlayer() then
                        if self.collisionHandler:handleCollisionWithPlayer(object, otherObject) then
                            firstHitBox = hitBox
                        end
                    else
                        if otherObject.isSolid and otherObject:isSolid() then
                            self.collisionHandler:handleCollisionWithSolid(object, otherObject)
                        end
                        if otherObject.isDangerousToNPCs and otherObject:isDangerousToNPCs() then
                            self.collisionHandler:handleCollisionWithDangerousToNPCs(object, otherObject)
                        end
                    end
                    if not firstHitBox then firstHitBox = hitBox end
                end
            end
        end)
        return firstHitBox
    end,

    refresh          = function(self)       TERRAIN:refresh()                  end,
    getTileIDAt      = function(self, x, y) return TERRAIN:getTileIDAt(x, y)   end,
    getSolidAt       = function(self, x, y) return TERRAIN:getSolidAt(x, y)    end,
    toggleShowSolids = function(self)       TERRAIN:toggleShowSolids()         end,

    fadeOut          = function(self)       self.fadeLayer:fadeOut()           end,
    fadeIn           = function(self)       self.fadeLayer:fadeIn()            end,

    teleport    = function(self, map, x, y, giantRing, player)
        if x == nil or y == nil then 
            x, y = self.origin.x, self.origin.y
        end
        local teleportObject = requireRelative("world/events/teleport"):create(self, { map = map, x = x, y = y, giantRing = giantRing, player = player })
        for n, evt in ipairs(self.events) do
            if evt:getName() == "teleport" then 
                if evt:isComplete() then 
                    self.events[n] = teleportObject
                    return 
                else
                    return
                end
            end
        end
        table.insert(self.events, teleportObject)
    end,

    addPreexistingObject = function(self, object)
        self.objects:add(object)
    end,

    getObjectsList = function(self)
        return self.objects
    end,

    getGroundLevel = function(self)
        return self.GROUND_LEVEL
    end,

    refreshGroundLevel = function(self)
        self.GROUND_LEVEL = TERRAIN:getCalculatedGroundLevel()
        WORKSPACE:setGroundLevel(TERRAIN:getCalculatedGroundLevel())
    end,
}
