--[[

--------------------------------------------------------------
--                  Functional Specifications               --
--------------------------------------------------------------

[X] 1. Create Game Window
       a. Window Title:      Sonic Destination
       b. Window Dimensions: 1024 x 768
       c. Window is displayed on 2nd monitor (TEMPORARY)
[X] 2. Draw Workspace in Game Window
       a. Background colored dark green
       b. Thick white horizontal line across entire screen,
          positioned 3/4 of way down the screen
[ ] 3. Draw Sonic the Hedgehog sprite in Workspace
       a. Sonic is standing on the line
--]]

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

-- Set Window Title:     "Sonic Destination"
love.window.setTitle("Sonic Destination")

-- Set Window Dimensions: 1024 x 768
love.window.setMode(1024, 768, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    drawWorkspace()
    drawSonic()
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function drawWorkspace()
    drawDarkGreenBackground()
    drawThickHorizontalWhiteLineSpanningWidthOfScreenPositionedThreeQuartersOfTheWayDown()
end

function drawDarkGreenBackground()
    love.graphics.setColor(0, 0.45, 0)
    love.graphics.rectangle("fill", 0, 0, 1024, 768)
end

function drawThickHorizontalWhiteLineSpanningWidthOfScreenPositionedThreeQuartersOfTheWayDown()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.line(0, 576, 1024, 576)
end

function drawSonic()
    -- Code to draw Sonic goes here
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
    --]]
end
