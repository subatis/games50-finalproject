--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    ...with edits/additions by Erik Subatis 7/2019
]]

GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.impassible = def.impassible
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
    self.animation = def.animation or nil
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
