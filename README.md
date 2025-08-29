# sonicDestination
### The coolest game in the whole entire world. Bar None.

From within this directory, the "game" (such as it is) can be executed via:

    love .

To execute the Color Inspector application, use the command

    love . inspector

with an argument (REQUIRED) specifying the image you wish to inspect.
Only specify the image name (without an extension.)
Image is expected to be a png image located in the resources/images/spriteSheets directory.

EX: 

    love . inspector sonic1

inspects the `sonicDestination/resources/images/spriteSheets/sonic1.png` file.

To execute the Sprite Sheet Slicer application, use the command

    love . slicer

with an argument (REQUIRED) specifying the image you wish to slice.
Only specify the image name (without an extension.)
Image is expected to be a png image located in the resources/images/spriteSheets directory.

EX: 

    love . slicer sonic1

runs the Sprite Sheet Slicer application on the image file `sonicDestination/resources/images/spriteSheets/sonic1.png`.

To execute the Transparency Editor application, use the command

    love . transparency

with an argument (REQUIRED) specifying the image you wish to edit the transparencies of.
Only specify the image name (without an extension.)
Image is expected to be a png image located in the resources/images/spriteSheets directory.

EX: 

    love . transparency sonic1

runs the Transparency Editor application on the image file `sonicDestination/resources/images/spriteSheets/sonic1.png`.

To execute the State Machine Viewer application, use the command

    love . stateMachine

To execute the Sound Graph application, use the command

    love . soundGraph

with an argument (optional; defaults to "sonicCDJump.mp3") specifying the sound you wish to analyze.
Only specify the filename (WITH the extension.)
Sound is expected to be an mp3 or ogg sound file located in the game/resources/sounds directory.

EX: 

    love . soundGraph jump.ogg

runs the Sound Graph application on the sound file `sonicDestination/game/resources/sounds/jump.ogg`.

To execute the Test Suite application, use the command

    love . test

