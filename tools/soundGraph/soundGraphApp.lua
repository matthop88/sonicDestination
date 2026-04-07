--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1400, 776
local WAVEFORM_HEIGHT = 512
local MARKER_PANE_HEIGHT = 64
local INFO_PANE_HEIGHT = 200

local SOUND_OBJECT = nil
local SOUND_VIEW = require("tools/soundGraph/soundView"):create {
	soundObject = nil,
	samplingRate = 64,
	marginLeft = 100,
	windowWidth = WINDOW_WIDTH - 100,
	waveformHeight = WAVEFORM_HEIGHT,
	markerPaneHeight = MARKER_PANE_HEIGHT,
	infoPaneHeight = INFO_PANE_HEIGHT,
}

local VOLUME_PANE = require("tools/lib/components/verticalSliderPane"):create {
	x = 1280,
	y = 0,
	width = 120,
	height = WINDOW_HEIGHT,
	title = "Volume",
	minValue = 0,
	maxValue = 1,
	quantize = 0.1,
	getValue = function()
		return SOUND_OBJECT and SOUND_OBJECT.volume or 0
	end,
	setValue = function(value)
		if SOUND_OBJECT then
			SOUND_OBJECT:setVolume(value)
		end
	end,
}

local SOUND_LIST = require("tools/soundGraph/soundList"):create {
	x = (WINDOW_WIDTH - 400) / 2,
	y = (WINDOW_HEIGHT - 400) / 2,
	width = 400,
	height = 400,
	fontSize = 28,
	scrollSpeed = 1200,
	onSoundLoaded = function(soundObject)
		-- Reset progress bar before loading
		getProgressBar():refresh()
		
		-- Reset sound object to start position
		soundObject.audioSource:seek(0, "seconds")
		
		SOUND_OBJECT = soundObject
		print("Analysis coroutine created")
		SOUND_VIEW:refresh(SOUND_OBJECT, 64, 100)
	end,
}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    SOUND_VIEW:draw()
    SOUND_LIST:draw()
    VOLUME_PANE:draw()
end

function love.update(dt)
    if SOUND_OBJECT then
        SOUND_OBJECT:update(dt)
    end
    
    SOUND_LIST:update(dt)
    SOUND_VIEW:update(dt)
    VOLUME_PANE:update(dt)
    if not SOUND_VIEW:isAnalysisComplete() then
        local progress = SOUND_VIEW:getProgress()
        setProgressBarText(string.format("Loading Sound Data... %.0f%%", progress * 100))
    end
end

function love.mousepressed(mx, my)
    local handled = SOUND_LIST:handleMousePressed(mx, my)
    if not handled then
        handled = VOLUME_PANE:handleMousePressed(mx, my)
    end
    if not handled then
        handled = SOUND_VIEW:handleMousePressed(mx, my)
    end
end

function love.mousereleased()
    SOUND_LIST:handleMouseReleased()
    VOLUME_PANE:handleMouseReleased()
    SOUND_VIEW:handleMouseReleased()
end

function love.keypressed(key)
    if key == "space" and SOUND_OBJECT then
        if SOUND_OBJECT:isPlaying() then
            SOUND_OBJECT:pause()
        else
            -- Get sample position from mouse, constrained by start marker
            local samplePosition = SOUND_VIEW:getSampleXFromMouseX()
            local startMarkerSample = SOUND_VIEW:getStartMarkerSample()
            local constrainedSample = math.max(samplePosition, startMarkerSample)
            SOUND_OBJECT:playFromSample(constrainedSample)
        end
    elseif key == "shiftleft" and SOUND_OBJECT then
        SOUND_OBJECT:jumpToBeginning()
        SOUND_VIEW:refreshView()
    elseif key == "shiftright" and SOUND_OBJECT then
        SOUND_OBJECT:jumpToEnd()
        SOUND_VIEW:refreshView()
    elseif key == "L" then
        SOUND_LIST:setVisible(true)
    elseif key == "F" then
        local enabled = SOUND_VIEW:toggleFollowPlaybackCursor()
        print("Follow playback cursor: " .. (enabled and "ENABLED" or "DISABLED"))
    elseif key == "s" and SOUND_OBJECT and SOUND_OBJECT:isLoopingEnabled() then
        local samplePosition = SOUND_VIEW:getSampleXFromMouseX()
        SOUND_OBJECT:setLoopStartPoint(samplePosition)
        SOUND_OBJECT:enforceConstraints()
        SOUND_VIEW.markerPane:updateAllMarkerValues()
    elseif key == "e" and SOUND_OBJECT and SOUND_OBJECT:isLoopingEnabled() then
        local samplePosition = SOUND_VIEW:getSampleXFromMouseX()
        SOUND_OBJECT:setLoopEndPoint(samplePosition)
        SOUND_OBJECT:enforceConstraints()
        SOUND_VIEW.markerPane:updateAllMarkerValues()
    end
end

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sound Graph Application")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

-- Start with list visible
SOUND_LIST:setVisible(true)

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick", { accessorFnName = "getDoubleClick" })
    :add("zooming",    { imageViewer = SOUND_VIEW.waveformPane })
    :add("scrolling",  { imageViewer = SOUND_VIEW.waveformPane, scrollY = false, scrollSpeed = 48000 })
    :add("progressBar",
    {
        message       = "Loading Sound Data...",
        callback      = function() return SOUND_VIEW:getProgress() end,
        setTextFnName = "setProgressBarText",
        accessorFnName = "getProgressBar",
    })
    :add("questionBox",
    {   x = 1230,
        alpha = 0.9,
        useDoubleClick = true,
        getDoubleClickFn = getDoubleClick,
        lines = {
            tabSize = 200,
            "Playback Controls_",
            { "space", "- Play/Pause audio", },
            { "shift-left", "- Jump to start point", },
            { "shift-right", "- Jump to end point", },
            { "left/right", "- Seek backward/forward (hold)", },
            "",
            "Markers_",
            { "Drag marker", "- Adjust position", },
            { "Double-click", },
            { "   loop marker", "- Toggle loop marker on/off (music only)", },
            "",
            "Loop Markers (Music Only)_",
            { "s", "- Set loop start to cursor position", },
            { "e", "- Set loop end to cursor position", },
            "",
            "Volume Control_",
            { "Drag slider", "- Adjust volume (0.0-1.0)", },
            "",
            "View Controls_",
            { "z/a", "- Zoom in/out on waveform", },
            { "F", "- Toggle follow playback cursor", },
            { "L", "- Show sound list", },
        },
    })


