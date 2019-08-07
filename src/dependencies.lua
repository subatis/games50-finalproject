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

    ['BLOCK_PLAIN'] = 33
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
