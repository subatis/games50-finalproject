--[[ For "DRONES" by Erik Subatis 2019, final project for GD50;
     core code from GD50 (Harvard) originally ]]

TileMap = Class{}

-- constructor
function TileMap:init(tilesetImg, quads, width, height, tileSize)
    self.tilesetImg = tilesetImg
    self.quads = quads
    self.width = width
    self.height = height
    self.tileSize = tileSize

    -- set default level parameters; map initialization overrides them
    self.numRobots = DEFAULT_NUM_ROBOTS
    self.goalRobots = DEFAULT_GOAL_ROBOTS
    self.spawnTime = DEFAULT_ROBOT_SPAWN_TIME

    -- create 2D array to represent map tiles and populate with (empty) Tile objects
    self.tiles = {}
    for y = 1, self.height do
        table.insert(self.tiles, {})
        for x = 1, self.width do
            self.tiles[y][x] = Tile(x, y, nil, nil, false, false)
        end
    end
end

-- generate map; global defs are in dependencies.lua
function TileMap:initializeMap(levelNum)
    if levelNum == 1 then
        initMap1(self)
    elseif levelNum == 2 then
        initMap2(self)
    elseif levelNum == 3 then
        initMap3(self)
    end
end

-- convert world loc to grid x, y and RETURN TILE
function TileMap:pointToTile(x, y)
    if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
        return nil
    end

    return self.tiles[math.floor(y / TILE_SIZE) + 1][math.floor(x / TILE_SIZE) + 1]
end

-- set tyle at grid x, y to (empty)
function TileMap:removeTile(x, y)
    self.tiles[y][x] = Tile(x, y, nil, nil, false, false)
end

function TileMap:update(dt) end

function TileMap:draw()
    for y = 1, self.height do
        for x = 1, self.width do
            self.tiles[y][x]:draw()
        end
    end
end
