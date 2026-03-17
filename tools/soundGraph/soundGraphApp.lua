--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 512

local SOUND_DATA = require("tools/soundGraph/soundData")
local MUSIC_DATA = require("tools/soundGraph/musicData")

local SOUND_OBJECT = nil
local SOUND_VIEW = require("tools/soundGraph/soundView"):create {
	soundObject = nil,
	samplingRate = 64,
	marginLeft = 100,
}

local function loadSound(soundKey)
	local soundInfo = SOUND_DATA[soundKey] or MUSIC_DATA[soundKey]
	if not soundInfo then
		print("Error: Sound key not found: " .. soundKey)
		return
	end
	
	-- Reset progress bar before loading
	getProgressBar():refresh()
	
	local basePath = MUSIC_DATA[soundKey] and "game/resources/music/" or "game/resources/sounds/"
	local soundPath = basePath .. soundInfo.filename
	print("Loading sound: " .. soundPath)
	
	-- Create new sound object and refresh view
	local success, result = pcall(function()
		return require("tools/soundGraph/soundObject"):create(soundPath):init()
	end)
	
	if not success then
		print("Error loading sound file: " .. result)
		print("The file may be corrupted or empty.")
		return
	end
	
	SOUND_OBJECT = result
	print("Sound loaded, starting analysis...")
	SOUND_VIEW:refresh(SOUND_OBJECT, 64, 100)
	print("Analysis coroutine created")
end

-- Get list of sound and music names
local soundItems = {}
local labelToKeyMap = {}  -- Map from display label to original key

-- Add sound items
local soundLabels = {}
for soundKey, soundInfo in pairs(SOUND_DATA) do
	table.insert(soundLabels, soundInfo.label)
	labelToKeyMap[soundInfo.label] = soundKey
end
table.sort(soundLabels)

for _, label in ipairs(soundLabels) do
	table.insert(soundItems, label)
end

-- Add separator
local RECTANGLE_ITEM = require("tools/lib/guiList/rectangleItem")
table.insert(soundItems, RECTANGLE_ITEM:create {
	color = { 0.5, 0.5, 0.5 },
	width = 390,
	height = 5,
	notSelectable = true,
})

-- Add music items
local musicLabels = {}
for musicKey, musicInfo in pairs(MUSIC_DATA) do
	table.insert(musicLabels, musicInfo.label)
	labelToKeyMap[musicInfo.label] = musicKey
end
table.sort(musicLabels)

for _, label in ipairs(musicLabels) do
	table.insert(soundItems, label)
end

local LIST = require("tools/lib/guiList/list"):create {
	x = (WINDOW_WIDTH - 400) / 2,  -- Center horizontally
	y = (WINDOW_HEIGHT - 400) / 2,  -- Center vertically
	width = 400,
	height = 400,
	fontSize = 28,
	scrollSpeed = 1200,
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
    if SOUND_VIEW then
        SOUND_VIEW:update(dt)
        if not SOUND_VIEW:isAnalysisComplete() then
            local progress = SOUND_VIEW:getProgress()
            setProgressBarText(string.format("Loading Sound Data... %.0f%%", progress * 100))
        end
    end
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
        if SOUND_OBJECT:isPlaying() then
            SOUND_OBJECT:pause()
        else
            local samplePosition = SOUND_VIEW:getSampleXFromMouseX()
            SOUND_OBJECT:playFromSample(samplePosition)
        end
    elseif key == "L" then
        LIST:setVisible(true)
    elseif key == "F" and SOUND_VIEW then
        local enabled = SOUND_VIEW:toggleFollowPlaybackCursor()
        print("Follow playback cursor: " .. (enabled and "ENABLED" or "DISABLED"))
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
    :add("scrolling",  { imageViewer = SOUND_VIEW, scrollY = false, scrollSpeed = 48000 })
    :add("progressBar",
    {
        message       = "Loading Sound Data...",
        callback      = function() return SOUND_VIEW:getProgress() end,
        setTextFnName = "setProgressBarText",
        accessorFnName = "getProgressBar",
    })

