local MAIN_GRAFX   = require("tools/lib/graphics"):create()
local CHUNK_ARTIST
local MAIN_CHUNK_Y
local STICKY_MOUSE
local SIDEBAR_PANEL

local TILE_COMMAND_QUEUE  = require("tools/chunkDoctor/command/queue"):create()
local COMMAND_CHAIN       = require("tools/chunkDoctor/command/chain"):create()

local GRID_SIZE           = require("tools/lib/tweenableValue"):create(0, { speed = 6  })
local SOLIDS_CURSOR_COLOR = require("tools/lib/tweenableValue"):create(0, { speed = 1 })

local SOLIDS_MODE  = false

local selectedTile = nil
local anchorTile   = nil

MAIN_GRAFX:setScale(2)

return {
	init = function(self, chunkArtist, mainChunkY, stickyMouse, sidebarPanel)
		CHUNK_ARTIST  = chunkArtist
		MAIN_CHUNK_Y  = mainChunkY
		STICKY_MOUSE  = stickyMouse
		SIDEBAR_PANEL = sidebarPanel
		return self
	end,

	draw = function(self)
        for i = 1, CHUNK_ARTIST:getNumChunks() do
            self:renderChunk(i, ((i - 1) * 400) + 72)
        end
        self:renderChunk(1, (CHUNK_ARTIST:getNumChunks() * 400) + 72)
        self:renderChunk(CHUNK_ARTIST:getNumChunks(), -328)

        if not self:drawSelectedTile() then self:drawCurrentTileHighlight() end
    end,

    update = function(self, dt, chunkID)
    	MAIN_GRAFX:setY(MAIN_CHUNK_Y:get())
    	
    	self:updateGrid(dt)
        self:updateSolidsCursor(dt)

        if love.keyboard.isDown("lgui", "rgui") then self:updateBasedOnAnchor() end

        if love.mouse.isDown(1) and love.keyboard.isDown("lshift", "rshift") then
            self:updateSelectedTileUsingChain(chunkID)
        elseif not COMMAND_CHAIN:isEmpty() then 
            self:purgeCommandChain() 
        end
    end,

    updateGrid = function(self, dt)
        if self:isPtInsideChunk(love.mouse.getPosition()) then 
            STICKY_MOUSE:setTransparency(0.4)
            GRID_SIZE:setDestination(150)
        else               
            STICKY_MOUSE:setTransparency(0.9)                                    
            GRID_SIZE:setDestination(0)   
        end
        GRID_SIZE:update(dt)
        
    end,

    updateSolidsCursor = function(self, dt)
        if not SOLIDS_CURSOR_COLOR:inFlux() then
            if SOLIDS_CURSOR_COLOR:get() == 0 then SOLIDS_CURSOR_COLOR:setDestination(305)
            else                                   SOLIDS_CURSOR_COLOR:setDestination(0)   end
        end
        SOLIDS_CURSOR_COLOR:update(dt)
    end,

    updateSelectedTileUsingChain = function(self, chunkID)
        self:updateSelectedTile()
        local tileID = STICKY_MOUSE:getTileID()
        if tileID ~= nil and selectedTile ~= nil then
            self:changeTile(chunkID, tileID, selectedTile.x, selectedTile.y)
        end
    end,

    renderChunk = function(self, chunkNum, y)
        if y + MAIN_GRAFX:getY() < 400 and y + MAIN_GRAFX:getY() > -256 then        
            MAIN_GRAFX:setColor(1, 1, 1)
            MAIN_GRAFX:setFontSize(32)
            CHUNK_ARTIST:draw(chunkNum, 65, y, MAIN_GRAFX, GRID_SIZE:get() / 100)
            if SOLIDS_MODE == true then
                CHUNK_ARTIST:drawSolids(chunkNum, 65, y, MAIN_GRAFX, GRID_SIZE:get() / 100)
            end
            MAIN_GRAFX:printf("" .. chunkNum, 15, y + 112, 50, "center")
        end
    end,

    drawSelectedTile = function(self)
        if selectedTile ~= nil then
            MAIN_GRAFX:setColor(1, 1, 1, 0.8)
            MAIN_GRAFX:rectangle("fill", (selectedTile.x * 16) + 63, (selectedTile.y * 16) + 70 - MAIN_CHUNK_Y:get(), 20, 20)
            return true
        end
    end,

    drawCurrentTileHighlight = function(self)
        if not MAIN_CHUNK_Y:inFlux() then
            local tileX, tileY = self:getTargetedTileXY()
            if tileX ~= nil then
                if SOLIDS_MODE == true then self:drawSolidsCursorAt(   tileX, tileY)
                else                        self:drawHighlightedTileAt(tileX, tileY) end
            end
        end
    end,

    drawSolidsCursorAt = function(self, tileX, tileY)
        local c = SOLIDS_CURSOR_COLOR:get() / 350
        MAIN_GRAFX:setColor(1, 0, 0)
        MAIN_GRAFX:setLineWidth(3)
        MAIN_GRAFX:rectangle("line", (tileX * 16) + 64, (tileY * 16) + 85 - MAIN_CHUNK_Y:get(), 18, 6)
        MAIN_GRAFX:setColor(1, 1, 0, c)
        MAIN_GRAFX:rectangle("fill", (tileX * 16) + 65, (tileY * 16) + 86 - MAIN_CHUNK_Y:get(), 16, 4)
    end,

    drawHighlightedTileAt = function(self, tileX, tileY)
        MAIN_GRAFX:setColor(1, 1, 0)
        MAIN_GRAFX:setLineWidth(3)
        MAIN_GRAFX:rectangle("line", (tileX * 16) + 64, (tileY * 16) + 71 - MAIN_CHUNK_Y:get(), 18, 18)
    end, 


    getTargetedTileXY = function(self)
        local mx, my = love.mouse.getPosition()

        if self:isPtInsideChunk(mx, my) then
            local tileX = math.floor((mx - 130) / 32)
            local tileY = math.floor((my - 144) / 32)
            return tileX, tileY
        end
           
    end,

    isPtInsideChunk = function(self, px, py)
        return px >= 130 and px <= 642 and py >= 144 and py <= 656
    end,

    updateSelectedTile = function(self)
        local tileX, tileY = self:getTargetedTileXY()
        if tileX == nil then
            selectedTile = nil
        else
            selectedTile = { x = tileX, y = tileY }
        end
    end,

    updateBasedOnAnchor = function(self)
        if not STICKY_MOUSE:isHoldingTile() then anchorTile = nil end
        if anchorTile ~= nil then
            local tileX, tileY = self:getTargetedTileXY()
            if tileX ~= nil then
                local deltaX, deltaY = tileX - anchorTile.x, tileY - anchorTile.y
                if deltaX ~= 0 or deltaY ~= 0 then
                    SIDEBAR_PANEL:walkSelectedTile(deltaX, deltaY)
                    anchorTile.x = tileX
                    anchorTile.y = tileY
                end
            end
        end
    end,

    handleKeypressed = function(self, key)
    	if key == "escape" then STICKY_MOUSE:releaseTile() end
    end,

    handleMousepressed = function(self, mx, my, chunkID)
        if not SOLIDS_MODE then
            self:updateSelectedTile()
            local tileID = STICKY_MOUSE:getTileID()
            if tileID ~= nil and selectedTile ~= nil then
                self:changeTile(chunkID, tileID, selectedTile.x, selectedTile.y)
            end
        else
            local tileX, tileY = self:getTargetedTileXY()
            CHUNK_ARTIST:toggleSolidAt(chunkID, tileX + 1, tileY + 1)
        end
    end,

    handleMousereleased = function(self, mx, my)
        selectedTile = nil
        if not COMMAND_CHAIN:isEmpty() then self:purgeCommandChain() end
    end,

    toggleSolidsMode = function(self) 
        SOLIDS_MODE = not SOLIDS_MODE 
        STICKY_MOUSE:setVisible(not SOLIDS_MODE)
    end,

    changeTile = function(self, chunkID, tileID, selectedTileX, selectedTileY)
        local fromTileID = CHUNK_ARTIST:getTileID(chunkID, selectedTileX, selectedTileY)
        if tileID ~= fromTileID then
            local tileCommand = require("tools/chunkDoctor/command/setTileCommand"):create {
                chunkArtist = CHUNK_ARTIST,
                chunkID     = chunkID,
                chunkX      = selectedTileX,
                chunkY      = selectedTileY,
                fromTileID  = fromTileID,
                toTileID    = tileID,
            }
            tileCommand:execute()
            if love.keyboard.isDown("lshift", "rshift") then COMMAND_CHAIN:add(tileCommand)
            else                                             TILE_COMMAND_QUEUE:add(tileCommand) end
            anchorTile = { x = selectedTileX, y = selectedTileY, deltaX = 0, deltaY = 0, }
        end
    end,

    purgeCommandChain = function(self)
        TILE_COMMAND_QUEUE:add(COMMAND_CHAIN)
        COMMAND_CHAIN = require("tools/chunkDoctor/command/chain"):create()
    end,

    undo             = function(self)
        local tileCommand = TILE_COMMAND_QUEUE:prev()
        if tileCommand ~= nil then tileCommand:undo()  end
    end,

    redo             = function(self)
        local tileCommand = TILE_COMMAND_QUEUE:next()
        if tileCommand ~= nil then tileCommand:execute() end
    end,

}
