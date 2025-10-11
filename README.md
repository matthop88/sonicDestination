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

To execute the Chunkalyzer application, use the command

    love . chunkalyzer -i {mapImageIn}

with one required argument specifying the map image you wish to chunkalyze.
Only specify the filename (WITHOUT the extension.)
Map image is expected to be located in the resources/zones/maps/ directory.

Two further arguments can be specified, which are the the name of the chunks image file to write, and the name of the map data file to write. Both are optional, and default to `sampleChunksImage` and `sampleMapFile` respectively.

EX: 

    love . chunkalyzer -i GHZ_Act1_Map -c ghzChunks_IMG -m ghz1Map

runs the Chunkalyzer application on the map image file `sonicDestination/resources/zones/maps/GHZ_Act1_Map.png`, and writes the following two files upon saving:

`sonicDestination/resources/zones/chunks/ghzChunks_IMG.png`
and
`sonicDestination/resources/zones/maps/ghz1Map.lua`

To execute the MapViewer application, use the command

    love . mapViewer

with three possible inputs:
--mapIn,        -m  A map data file to read in, which links to a chunks image or chunk data image
--chunkDataIn,  -c  A chunk data file to read in; an impromptu map will be constructed from it
--chunkImageIn, -C  A chunk image file to read in; an impromptu map will be constructed from it. (Not a useful option)

If desired, a map image file can be specified to rewrite out
--mapOut,       -o  Raw map image to write out. 

Do NOT specify the exception for any of these.

Map layout file is expected to be located in the `resources/zones/maps/` directory.
Map image file will be written to the            `resources/zones/maps/` directory.

EX: 

    love . mapViewer -i ghz1Map -o ghz1Map_v2_IMG

runs the Map Viewer application on the map layout file `sonicDestination/resources/zones/maps/ghz1Map.lua` and, if desired, writes a new map image file of name `sonicDestination/resources/zones/maps/ghz1Map_v2_IMG.png`.

If a 2nd argument is not specified, the filename will default to `sampleRewrittenMapImage.png`.

To execute the Tileinator application, use the command

    love . tileinator

with these inputs:

--chunkImageIn,  -i,  An image file with chunks derived from a world map; a tiles image will be created from it
--mapFileIn,     -m,  An optional map data file containing chunk references; a new reference will be added pointing to the new chunk data

and with these two outputs:

--chunkFileOut,  -c,  A chunk data file to write out; will refer to the tiles image file that is created.
                      If unspecified, this will default to `sampleChunkLayout.lua`
--tileImageOut,  -t   A tiles image to write based upon compression from chunk.
                      If unspecified, this will default to `sampleTileImage.png`

Chunk layout file is expected to be located in the `resources/zones/chunks/` directory.
Tile image   file will be written to the           `resources/zones/tiles/`  directory.

EX: 

    love . tileinator -i ghzChunks_IMG -m ghz1Map -c ghzChunks -t ghzTiles_IMG

runs the Tileinator application, which analyzes the file `resources/zones/chunks/ghzChunks_IMG.png` and creates two files: `resources/zones/chunks/ghzChunks.lua` and `resources/zones/tiles/ghzTiles_IMG.png`.

In addition, the file `resources/zones/maps/ghz1Map.lua` is updated to have a reference to the new ghzChunks.lua chunk data file embedded inside of it.

To execute the TestSuite application, use the command

    love . test


