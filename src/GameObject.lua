--[[ For "DRONES" by Erik Subatis 2019, final project for GD50;
     core code from:
            GD50
            -- Super Mario Bros. Remake --

            Author: Colton Ogden
            cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def)
    -- coordinates, dimensions, etc
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height

    -- render info
    self.animation = def.animation or nil
    self.frame = def.frame

    -- state
    self.impassible = def.impassible
    self.collidable = def.collidable
    if def.visible == false then self.visible = false else self.visible = true end
    self.remove = false
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)

end

function GameObject:draw()
    if self.visible then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)

        -- DEBUG:
        --love.graphics.setColor(255, 255, 0, 255)
        --love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
        --love.graphics.setColor(255, 255, 255, 255)
    end
end
