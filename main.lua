--------------------------------------------------------------
--              Application Launching Functions             --
--------------------------------------------------------------

local launchColorInspector       = function(args)
    __INSPECTOR_FILE = args[2]
    require "tools/colorInspector/inspector"
end

local launchSlicer               = function(args)
    __SLICER_FILE = args[2]
    require "tools/spriteSheetSlicer/slicerApp"
end

local launchTransparencyEditor   = function(args)
    __TRANSPARENCY_FILE = args[2]
    require "tools/transparencyEditor/editorApp"
end

local launchScribbler            = function(args)
    __SCRIBBLER_FILE = args[2]
    require "tools/scribbler/scribblerApp"
end

local launchStateMachineViewer   = function(args)
    __VIEWER_FILE = args[2]
    require "tools/stateMachine/viewer"
end

local launchSoundGraph           = function(args)
    __SOUND_FILE = args[2]
    require "tools/soundGraph/soundGraphApp"
end

local launchChunkalyzer          = function(args)
    __WORLD_MAP_FILE   = args[2]
    __CHUNK_IMAGE_FILE = args[3]
    require "tools/chunkalyzer/chunkalyzerApp"
end

local launchMapViewer            = function(args)
    __MAP_FILE   = args[2]
    __CHUNK_FILE = args[3]
    require "tools/mapViewer/mapViewerApp"
end

local launchTestingFramework     = function(args)
    require "testing/testFramework"
end

--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local APP_LAUNCHER = {
    inspector    = launchColorInspector,
    slicer       = launchSlicer,
    transparency = launchTransparencyEditor,
    scribbler    = launchScribbler,
    stateMachine = launchStateMachineViewer,
    soundGraph   = launchSoundGraph,
    chunkalyzer  = launchChunkalyzer,
    mapViewer    = launchMapViewer,
    test         = launchTestingFramework,
}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.load()
-- Called By:     LOVE2D application, once during start
-- Parameters:    args - list of command-line arguments
--                       passed by user in console
--------------------------------------------------------------
function love.load(args)
    __DEV_MODE = true

    local appName = args[1]
    
    if APP_LAUNCHER[appName] ~= nil then APP_LAUNCHER[appName](args)
    else                                 require "game/main"     end
end

function relativePath(path)
    return "game/" .. path
end
