-- dependencies ------------------------------------------------
Class = require 'lib/hump.class'
push = require 'lib/hump.push'
Timer = require 'lib/knife.timer'

require 'lib/games50.StateMachine'
require 'lib/games50.BaseState'
require 'lib/games50.Animation'
require 'lib/util'

require 'src/Gui'
require 'src/Tile'
require 'src/TileMap'

require 'src/Entity'

require 'src/Robot'
require 'src/states/entity/robot/RobotIdleState'
require 'src/states/entity/robot/RobotFallingState'
require 'src/states/entity/robot/RobotWalkingState'
require 'src/states/entity/robot/RobotJumpState'
require 'src/states/entity/robot/RobotUmbrellaState'
require 'src/states/entity/robot/RobotDyingState'
require 'src/states/entity/robot/RobotBlockState'
require 'src/states/entity/robot/RobotBombExplodingState'

require 'src/states/entity/door/DoorIdleState'
require 'src/states/entity/door/DoorOpenState'
require 'src/states/entity/door/DoorCloseState'

require 'src/GameObject'

require 'src/ObjectFactory'
require 'src/Player'
require 'src/Level'

require 'src/states/game/StartState'
require 'src/states/game/PlayState'
require 'src/states/game/CountdownState'
require 'src/states/game/GameOverState'
require 'src/states/game/VictoryState'

-- constants -------------------------------------------------------------------
-- general
WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 576
VIRTUAL_WIDTH = 1024
VIRTUAL_HEIGHT = 576

TILE_SIZE = 32

GUI_X = 0
GUI_Y = VIRTUAL_HEIGHT - TILE_SIZE
NUM_GUI_BUTTONS = 3

-- physics
GRAVITY = 10
TERMINAL_VELOCITY = 425
ROBOT_WALK_SPEED = 50
ROBOT_JUMP_VELOCITY = -150

UMBRELLA_GRAVITY_FACTOR = 0.85

-- gameplay
DEFAULT_ROBOT_SPAWN_TIME = 3
DEFAULT_NUM_ROBOTS = 10
DEFAULT_GOAL_ROBOTS = 5
BOMB_RADIUS = TILE_SIZE / 2

-- entity dimension constants
ROBOT_SCALE_X = 2
ROBOT_SCALE_Y = 2
ROBOT_OFFSET_X = 16
ROBOT_OFFSET_Y = 16

-- gui definitions
TOOLDEFS = {
    ['UMBRELLA'] = 1,
    ['BLOCK'] = 2,
    ['BOMB'] = 3
}

-- tileset definitions
TILEDEFS = {
    ['PIPE_MIDDLE'] = 1,
    ['PIPE_END_LEFT'] = 17,
    ['PIPE_END_RIGHT'] = 18,
    ['PIPE_BEND_TOP_LEFT'] = 5,
    ['PIPE_BEND_TOP_RIGHT'] = 6,
    ['PIPE_BEND_BTM_LEFT'] = 21,
    ['PIPE_BEND_BTM_RIGHT'] = 22,
    ['PIPE_VERT_MIDDLE'] = 3,

    ['BLOCK_PLAIN'] = 33,
    ['BLOCK_CROSS'] = 35,
    ['BLOCK_FLAT_LINES'] = 40,

    ['DECORATIVE_GRATE_HORIZ'] = 78,
    ['DECORATIVE_GRATE_VERT'] = 77,

    ['SPIKES_LEFT'] = 75
}

-- robot frame definitions
ROBOTFRAMES = {
    ['IDLE'] = 20,

    ['WALK_1'] = 21,
    ['WALK_2'] = 22,
    ['WALK_3'] = 23,
    ['WALK_4'] = 24,
    ['WALK_5'] = 25,

    ['FALLING'] = 16,
    ['TERMINAL_FALLING'] = 38,

    ['UMBRELLA'] = 30,
    ['BLOCK'] = 29
}

-- door frame definitions
DOORFRAMES = {
    ['IN_1'] = 1,
    ['IN_2'] = 2,
    ['IN_3'] = 3,
    ['IN_4'] = 4,
    ['IN_5'] = 5,
    ['IN_6'] = 6,
    ['IN_7'] = 7,
    ['IN_8'] = 8,
    ['IN_9'] = 19,
    ['IN_10'] = 20,

    ['OUT_1'] = 23,
    ['OUT_2'] = 10,
    ['OUT_3'] = 11,
    ['OUT_4'] = 12,
    ['OUT_5'] = 13,
    ['OUT_6'] = 14,
    ['OUT_7'] = 15,
    ['OUT_8'] = 16,
    ['OUT_9'] = 17,
    ['OUT_10'] = 18,
    ['OUT_11'] = 19,
    ['OUT_12'] = 20
}

-- assets ----------------------------------------------------------------------
gFonts = {
    ['huge'] = love.graphics.newFont('assets/boo_city.ttf', 96),
    ['large'] = love.graphics.newFont('assets/boo_city.ttf', 64),
    ['medium'] = love.graphics.newFont('assets/boo_city.ttf', 32),
    ['small'] = love.graphics.newFont('assets/boo_city.ttf', 16)
}

gBackgrounds = {
    ['city_clean'] = love.graphics.newImage('assets/city_background_clean.png'),
    ['city_night'] = love.graphics.newImage('assets/city_background_night.png'),
    ['city_sunset'] = love.graphics.newImage('assets/city_background_sunset.png')
}

gTextures = {
    ['tileset'] = love.graphics.newImage('assets/scifi.png'),
    ['robot'] = love.graphics.newImage('assets/green_bot_sprites.png'),
    ['gui'] = love.graphics.newImage('assets/tools.png'),
    ['explosion'] = love.graphics.newImage('assets/explosion.png'),
    ['robot_death'] = love.graphics.newImage('assets/robot_death.png'),
    ['doors'] = love.graphics.newImage('assets/hatches.png')
}
-- map tiles
gTilesetQuads = GenerateQuads(gTextures['tileset'], TILE_SIZE, TILE_SIZE)

-- frames
gFrames = {
   ['robot'] = GenerateQuads(gTextures['robot'], 16, 16),
   ['gui'] = GenerateQuads(gTextures['gui'], TILE_SIZE, TILE_SIZE),
   ['explosion'] = GenerateQuads(gTextures['explosion'], 96, 96),
   ['robot_death'] = GenerateQuads(gTextures['robot_death'], 17, 18),
   ['doors'] = GenerateQuads(gTextures['doors'], 32, 64)
}

-- levels
function initMap1(tilemap)
    -- in and out doors
    tilemap.inDoorX = 3
    tilemap.inDoorY = 3
    tilemap.outDoorX = 9
    tilemap.outDoorY = tilemap.height - 2

    -- pipe along ground with end caps
    tilemap.tiles[tilemap.height][8] = Tile(8, tilemap.height, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_END_LEFT']], true, false)
    for x = 9, tilemap.width - 8 do
        tilemap.tiles[tilemap.height][x] = Tile(x, tilemap.height, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_MIDDLE']], true, false)
    end
    tilemap.tiles[tilemap.height][tilemap.width - 7] = Tile(tilemap.width - 7, tilemap.height, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_END_RIGHT']], true, false)

    -- pipe high up near spawn point with end cap
    for x = 1, 8 do
        tilemap.tiles[5][x] = Tile(x, 5, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_MIDDLE']], true, false)
    end
    tilemap.tiles[5][9] = Tile(9, 5, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_END_RIGHT']], true, false)

    -- decorative pipes underneath spawn point
    tilemap.tiles[6][6] = Tile(6, 6, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_BEND_TOP_RIGHT']], true, false)
    for x = 1, 5 do
        tilemap.tiles[6][x] = Tile(x, 6, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_MIDDLE']], true, false)
        tilemap.tiles[6][x] = Tile(x, 6, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_MIDDLE']], true, false)
        tilemap.tiles[6][x] = Tile(x, 6, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_MIDDLE']], true, false)
        tilemap.tiles[6][x] = Tile(x, 6, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_MIDDLE']], true, false)
    end
    tilemap.tiles[7][6] = Tile(6, 7, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_BEND_BTM_RIGHT']], true, false)
    tilemap.tiles[7][5] = Tile(5, 7, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_BEND_TOP_LEFT']], true, false)
    for y = 8, tilemap.height do
        tilemap.tiles[y][5] = Tile(5, y, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_VERT_MIDDLE']], true, false)
    end
    for x = 1, 4 do
        tilemap.tiles[tilemap.height - 1][x] = Tile(x, tilemap.height - 1, tilemap.tilesetImg, tilemap.quads[TILEDEFS['DECORATIVE_GRATE_HORIZ']], true, false)
    end
    for x = 1, 4 do
        tilemap.tiles[tilemap.height - 4][x] = Tile(x, tilemap.height - 4, tilemap.tilesetImg, tilemap.quads[TILEDEFS['DECORATIVE_GRATE_HORIZ']], true, false)
    end
    for x = 1, 4 do
        tilemap.tiles[tilemap.height - 7][x] = Tile(x, tilemap.height - 7, tilemap.tilesetImg, tilemap.quads[TILEDEFS['DECORATIVE_GRATE_HORIZ']], true, false)
    end

    -- vertical grate & spikes
    for y = tilemap.height - 3, tilemap.height - 1 do
        tilemap.tiles[y][tilemap.width - 7] = Tile(tilemap.width - 7, y, tilemap.tilesetImg, tilemap.quads[TILEDEFS['BLOCK_FLAT_LINES']], true, false)
    end
    for y = 1, tilemap.height - 4 do
        tilemap.tiles[y][tilemap.width - 7] = Tile(tilemap.width - 7, y, tilemap.tilesetImg, tilemap.quads[TILEDEFS['DECORATIVE_GRATE_VERT']], true, false)
    end
    for y = tilemap.height - 3, tilemap.height - 1 do
        tilemap.tiles[y][tilemap.width - 8] = Tile(tilemap.width - 8, y, tilemap.tilesetImg, tilemap.quads[TILEDEFS['SPIKES_LEFT']], true, false, true)
    end

    -- decoration on right side of map
    for y = 6, tilemap.height do
        tilemap.tiles[y][tilemap.width - 5] = Tile(tilemap.width - 5, y, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_VERT_MIDDLE']], true, false)
    end
    tilemap.tiles[5][tilemap.width - 5] = Tile(tilemap.width - 5, 5, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_BEND_TOP_LEFT']], true, false)
    for x = tilemap.width - 4, tilemap.width do
        tilemap.tiles[5][x] = Tile(x, 5, tilemap.tilesetImg, tilemap.quads[TILEDEFS['PIPE_MIDDLE']], true, false)
    end
    for x = tilemap.width - 4, tilemap.width do
        tilemap.tiles[tilemap.height - 1][x] = Tile(x, tilemap.height - 1, tilemap.tilesetImg, tilemap.quads[TILEDEFS['DECORATIVE_GRATE_HORIZ']], true, false)
    end
    for x = tilemap.width - 4, tilemap.width do
        tilemap.tiles[tilemap.height - 4][x] = Tile(x, tilemap.height - 4, tilemap.tilesetImg, tilemap.quads[TILEDEFS['DECORATIVE_GRATE_HORIZ']], true, false)
    end
    for x = tilemap.width - 4, tilemap.width do
        tilemap.tiles[tilemap.height - 7][x] = Tile(x, tilemap.height - 7, tilemap.tilesetImg, tilemap.quads[TILEDEFS['DECORATIVE_GRATE_HORIZ']], true, false)
    end
    for x = tilemap.width - 4, tilemap.width do
        tilemap.tiles[tilemap.height - 10][x] = Tile(x, tilemap.height - 10, tilemap.tilesetImg, tilemap.quads[TILEDEFS['DECORATIVE_GRATE_HORIZ']], true, false)
    end

    tilemap.tiles[4][tilemap.width - 3] = Tile(tilemap.width - 3, 4, tilemap.tilesetImg, tilemap.quads[TILEDEFS['BLOCK_PLAIN']], true, false)
    tilemap.tiles[4][tilemap.width - 2] = Tile(tilemap.width - 2, 4, tilemap.tilesetImg, tilemap.quads[TILEDEFS['BLOCK_CROSS']], true, false)
    tilemap.tiles[3][tilemap.width - 2] = Tile(tilemap.width - 2, 3, tilemap.tilesetImg, tilemap.quads[TILEDEFS['BLOCK_PLAIN']], true, false)
    tilemap.tiles[4][tilemap.width - 1] = Tile(tilemap.width - 1, 4, tilemap.tilesetImg, tilemap.quads[TILEDEFS['BLOCK_PLAIN']], true, false)
end
