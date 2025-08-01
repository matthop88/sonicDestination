require "requireRelative"

--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768

local PROP_LOADER        = requireRelative("properties/loader")

local GRAPHICS           = requireRelative("graphics")

if __DEV_MODE == true then
    GRAPHICS = require("tools/lib/bufferedGraphics"):create(GRAPHICS, 1024, 768)
end

local SONIC              = requireRelative("sonic",     { GRAPHICS = GRAPHICS })
local WORKSPACE          = requireRelative("workspace", { GRAPHICS = GRAPHICS })

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sonic Destination")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

SONIC:moveTo(512, 556)

PROP_LOADER:notifyOnChange(SONIC)

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    WORKSPACE:draw()
    SONIC:draw()
end

-- Function Name: love.update(dt)
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.update(dt)
    PROP_LOADER:update(dt)
    SONIC:update(dt)
end

-- Function Name: love.keypressed(key)
-- Called By:     LOVE2D application, whenever key is pressed
--------------------------------------------------------------
function love.keypressed(key)
    SONIC:keypressed(key)
end

-- Function Name: love.keyreleased(key)
-- Called By:     LOVE2D application, whenever key is released
--------------------------------------------------------------
function love.keyreleased(key)
    SONIC:keyreleased(key)
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

if __DEV_MODE == true then
    require("sonicPlugins"):init({ SONIC = SONIC, GRAPHICS = GRAPHICS, PROP_LOADER = PROP_LOADER })
end

--[[
                             ...,?77??!~~~~!???77?<~.... 
                        ..?7`                           `7!.. 
                    .,=`          ..~7^`   I                  ?1. 
       ........  ..^            ?`  ..?7!1 .               ...??7 
      .        .7`        .,777.. .I.    . .!          .,7! 
      ..     .?         .^      .l   ?i. . .`       .,^ 
       b    .!        .= .?7???7~.     .>r .      .= 
       .,.?4         , .^         1        `     4... 
        J   ^         ,            5       `         ?<. 
       .%.7;         .`     .,     .;                   .=. 
       .+^ .,       .%      MML     F       .,             ?, 
        P   ,,      J      .MMN     F        6               4. 
        l    d,    ,       .MMM!   .t        ..               ,, 
        ,    JMa..`         MMM`   .         .!                .; 
         r   .M#            .M#   .%  .      .~                 ., 
       dMMMNJ..!                 .P7!  .>    .         .         ,, 
       .WMMMMMm  ?^..       ..,?! ..    ..   ,  Z7`        `?^..  ,, 
          ?THB3       ?77?!        .Yr  .   .!   ?,              ?^C 
            ?,                   .,^.` .%  .^      5. 
              7,          .....?7     .^  ,`        ?. 
                `<.                 .= .`'           1 
                ....dn... ... ...,7..J=!7,           ., 
             ..=     G.,7  ..,o..  .?    J.           F 
           .J.  .^ ,,,t  ,^        ?^.  .^  `?~.      F 
          r %J. $    5r J             ,r.1      .=.  .% 
          r .77=?4.    ``,     l ., 1  .. <.       4., 
          .$..    .X..   .n..  ., J. r .`  J.       `' 
        .?`  .5        `` .%   .% .' L.'    t 
        ,. ..1JL          .,   J .$.?`      . 
                1.          .=` ` .J7??7<.. .; 
                 JS..    ..^      L        7.: 
                   `> ..       J.  4. 
                    +   r `t   r ~=..G. 
                    =   $  ,.  J 
                    2   r   t  .; 
              .,7!  r   t`7~..  j.. 
              j   7~L...$=.?7r   r ;?1. 
               8.      .=    j ..,^   .. 
              r        G              . 
            .,7,        j,           .>=. 
         .J??,  `T....... %             .. 
      ..^     <.  ~.    ,.             .D 
    .?`        1   L     .7.........?Ti..l 
   ,`           L  .    .%    .`!       `j, 
 .^             .  ..   .`   .^  .?7!?7+. 1 
.`              .  .`..`7.  .^  ,`      .i.; 
.7<..........~<<3?7!`    4. r  `          G% 
                          J.` .!           % 
                            JiJ           .` 
                              .1.         J 
                                 ?1.     .'         
                                     7<..%





                                    Sonic ASCII art credits
                                    -----------------------
    "ASCII Art of Sonic"
    posted by put-mutt on
    https://www.reddit.com/r/SonicTheHedgehog/comments/fpeyy4/ascii_art_of_sonic/?rdt=43749
    ---------------------------------------------------------------------------------------

--]]
