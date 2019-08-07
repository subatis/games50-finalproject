TileMap = Class{}

-- constructor
function TileMap:init(tilesetImg, quads, width, height, tileSize)
    self.tilesetImg = tilesetImg
    self.quads = quads
    self.width = width
    self.height = height
    self.tileSize = tileSize

    -- create 2D array to represent map tiles and populate with Tile objects
    self.tiles = {}
    for y = 1, self.height do
        table.insert(self.tiles, {})
        for x = 1, self.width do
            self.tiles[y][x] = Tile(x, y, nil, nil, false, false)
        end
    end
end

-- generate map
function TileMap:initializeMap(levelNum)
    if levelNum == 1 then
        -- in door (spawn point)
        self.inDoorX = 3
        self.inDoorY = 3

        -- out door (exit)
        self.outDoorX = self.width - 3
        self.outDoorY = self.height - 2

        -- pipe along "ground" with 2 end caps
        self.tiles[self.height][1] = Tile(1, self.height, self.tilesetImg, self.quads[TILEDEFS['PIPE_END_LEFT']], true, false)
        for x = 2, self.width - 1 do
            self.tiles[self.height][x] = Tile(x, self.height, self.tilesetImg, self.quads[TILEDEFS['PIPE_MIDDLE']], true, false)
        end
        self.tiles[self.height][self.width] = Tile(self.width, self.height, self.tilesetImg, self.quads[TILEDEFS['PIPE_END_RIGHT']], true, false)

        -- block along left side to test auto-walk
        self.tiles[self.height - 1][1] = Tile(1, self.height - 1, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)

        -- pipe near spawn point to test long falls, umbrella tool
        self.tiles[5][1] = Tile(1, 5, self.tilesetImg, self.quads[TILEDEFS['PIPE_END_LEFT']], true, true)
        self.tiles[5][2] = Tile(2, 5, self.tilesetImg, self.quads[TILEDEFS['PIPE_MIDDLE']], true, true)
        self.tiles[5][3] = Tile(3, 5, self.tilesetImg, self.quads[TILEDEFS['PIPE_MIDDLE']], true, true)
        self.tiles[5][4] = Tile(4, 5, self.tilesetImg, self.quads[TILEDEFS['PIPE_MIDDLE']], true, true)
        self.tiles[5][5] = Tile(5, 5, self.tilesetImg, self.quads[TILEDEFS['PIPE_END_RIGHT']], true, true)

        -- blocks slightly above to test top collisions
        self.tiles[self.height - 3][4] = Tile(4, self.height - 3, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)
        self.tiles[self.height - 3][5] = Tile(5, self.height - 3, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)
        self.tiles[self.height - 3][6] = Tile(6, self.height - 3, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)

        -- pyramid of blocks in middle
        self.tiles[self.height - 1][self.width / 2] = Tile(self.width / 2, self.height - 1, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)
        self.tiles[self.height - 1][self.width / 2 + 1] = Tile(self.width / 2 + 1, self.height - 1, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)
        self.tiles[self.height - 1][self.width / 2 + 2] = Tile(self.width / 2 + 2, self.height - 1, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)
        self.tiles[self.height - 2][self.width / 2 + 1] = Tile(self.width / 2 + 1, self.height - 2, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)
        self.tiles[self.height - 2][self.width / 2 + 2] = Tile(self.width / 2 + 2, self.height - 2, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)
        self.tiles[self.height - 3][self.width / 2 + 2] = Tile(self.width / 2 + 2, self.height - 3, self.tilesetImg, self.quads[TILEDEFS['BLOCK_PLAIN']], true, true)
    end
end

function TileMap:pointToTile(x, y)
    if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
        return nil
    end

    return self.tiles[math.floor(y / TILE_SIZE) + 1][math.floor(x / TILE_SIZE) + 1]
end

function TileMap:removeTile(x, y)
    self.tiles[y][x] = Tile(x, y, nil, nil, false, false)
end

function TileMap:update(dt)
end

function TileMap:draw()
    for y = 1, self.height do
        for x = 1, self.width do
            self.tiles[y][x]:draw()
        end
    end
end
