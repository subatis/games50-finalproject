Tile = Class{}

function Tile:init(x, y, srcImg, quad, impassible, destructible, deadly)
    self.x = x
    self.y = y
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.srcImg = srcImg
    self.quad = quad
    self.impassible = impassible or false
    self.destructible = destructible or false
    self.deadly = deadly or false
end

function Tile:draw()
    if self.srcImg and self.quad then
        love.graphics.draw(self.srcImg, self.quad, (self.x - 1) * self.width, (self.y - 1) * self.height)
    end
end
