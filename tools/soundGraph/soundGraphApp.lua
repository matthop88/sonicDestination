--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 512

local SOUND_DATA = require("tools/soundGraph/soundData")

local SOUND_OBJECT = nil
local SOUND_VIEW = require("tools/soundGraph/soundView"):create {
	soundObject = nil,
	samplingRate = 64,
	marginLeft = 100,
}

local function loadSound(soundKey)
	local soundInfo = SOUND_DATA[soundKey]
	if not soundInfo then
		print("Error: Sound key not found: " .. soundKey)
		return
	end
	
	local soundPath = "game/resources/sounds/" .. soundInfo.filename
	print("Loading sound: " .. soundPath)
	
	-- Create new sound object and refresh view
	SOUND_OBJECT = require("tools/soundGraph/soundObject"):create(soundPath):init()
	SOUND_VIEW:refresh(SOUND_OBJECT, 64, 100)
end

-- Get list of sound names from soundData
local soundItems = {}
local labelToKeyMap = {}  -- Map from display label to original key
for soundKey, soundInfo in pairs(SOUND_DATA) do
	table.insert(soundItems, soundInfo.label)
	labelToKeyMap[soundInfo.label] = soundKey
end
table.sort(soundItems)

local LIST = require("tools/lib/guiList/list"):create {
	x = 100,
	y = 100,
	width = 300,
	height = 400,
	fontSize = 16,
	items = soundItems,
	onItemSelected = function(listOrPane, label, index)
		local soundKey = labelToKeyMap[label]
		print("Selected: " .. label .. " (key: " .. soundKey .. ", index " .. index .. ")")
		loadSound(soundKey)
		listOrPane:setVisible(false)
	end,
}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if SOUND_VIEW then
        SOUND_VIEW:draw()
    end
    LIST:draw()
end

function love.update(dt)
    LIST:update(dt)
end

function love.mousepressed(mx, my)
    local handled = LIST:handleMousePressed(mx, my)
    if not handled and SOUND_VIEW and SOUND_OBJECT then
        print(SOUND_VIEW:getSampleXFromMouseX())
    end
end

function love.mousereleased()
    LIST:handleMouseReleased()
end

function love.keypressed(key)
    if key == "space" and SOUND_VIEW and SOUND_OBJECT then
        local samplePosition = SOUND_VIEW:getSampleXFromMouseX()
        SOUND_OBJECT:playFromSample(samplePosition)
    elseif key == "L" then
        LIST:setVisible(true)
    end
end

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sound Graph Application")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

-- Start with list visible
LIST:setVisible(true)

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",    { imageViewer = SOUND_VIEW })
    :add("scrolling",  { imageViewer = SOUND_VIEW, scrollY = false, scrollSpeed = 24000 })

