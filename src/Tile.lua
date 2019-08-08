--[[ For "DRONES" by Erik Subatis 2019, final project for GD50;
     core code from GD50 (Harvard) originally ]]

Tile = Class{}

function Tile:init(x, y, srcImg, quad, impassible, destructible, deadly)
    self.x = x                                  -- world loc, not grid
    self.y = y
    self.width = TILE_SIZE                      -- world dimensions, not grid
    self.height = TILE_SIZE
    self.srcImg = srcImg                        -- render info
    self.quad = quad
    self.impassible = impassible or false       -- entities cannot pass through
    self.destructible = destructible or false   -- bombs can destroy
    self.deadly = deadly or false               -- can kill entities/robots
end

function Tile:draw()
    if self.srcImg and self.quad then
        love.graphics.draw(self.srcImg, self.quad, (self.x - 1) * self.width, (self.y - 1) * self.height)
    end
end
