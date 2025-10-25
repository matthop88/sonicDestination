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
    require "tools/chunkalyzer/chunkalyzerApp"
end

local launchMapViewer            = function(args)
    require "tools/mapViewer/mapViewerApp"
end

local launchTileinator           = function(args)
    require "tools/tileinator/tileinatorApp"
end

local launchChunkDoctor          = function(args)
    require "tools/chunkDoctor/chunkDoctorApp"
end

local launchTestingFramework     = function(args)
    require "testing/testFramework"
end

local launchProgress             = function(args)
    require "fun/applications/progress/progress"
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
    tileinator   = launchTileinator,
    chunkDoctor  = launchChunkDoctor,
    progress     = launchProgress,
    test         = launchTestingFramework,
}

local APP_PATH = {
    inspector    = "tools/colorInspector",
    slicer       = "tools/spriteSheetSlicer",
    transparency = "tools/transparencyEditor",
    test         = "testing",
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
    
    if appName == nil then 
        require "game/main"
    else
        local cmdLineTools = require("commandLineTools"):create(appName, APP_PATH)
        __PARAMS = cmdLineTools:getParams(args)
        if __PARAMS["help"] then
            cmdLineTools:printHelp()
            return
        elseif not cmdLineTools:validateParams(args) then
            return
        end
        
        if   APP_LAUNCHER[appName] ~= nil then APP_LAUNCHER[appName](args)
        else                                   require "game/main"     end
    end
end

function relativePath(path)
    return "game/" .. path
end
