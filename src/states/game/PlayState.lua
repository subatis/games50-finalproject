--[[ For "DRONES" by Erik Subatis 2019, final project for GD50;
     core code from:
            GD50
            Legend of Zelda

            Author: Colton Ogden
            cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    -- create & initialize map; leave bottom TILE_SIZExTILE_SIZE row for GUI
    self.map = TileMap(gTextures['tileset'], gTilesetQuads, VIRTUAL_WIDTH / TILE_SIZE, VIRTUAL_HEIGHT / TILE_SIZE - 1, TILE_SIZE)
    self.map:initializeMap(gLevelNum)

    -- create player & level
    self.player = Player()
    self.level = Level {
                        map = self.map,
                        player = self.player,
                        background = 'city_night',
                        numRobots = DEFAULT_NUM_ROBOTS,
                        goalRobots = DEFAULT_GOAL_ROBOTS,
                        spawnTime = DEFAULT_ROBOT_SPAWN_TIME
                       }
end

-- update level
function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    self.level:update(dt)
end

-- draw level
function PlayState:render()
    self.level:draw()
end
