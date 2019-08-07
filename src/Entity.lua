Entity = Class{}

function Entity:init(def)
    self.x = def.x
    self.y = def.y
    self.scaleX = def.scaleX or 1
    self.scaleY = def.scaleY or 1
    self.dx = 0
    self.dy = 0
    self.width = def.width
    self.height = def.height
    self.originX = def.originX or 0
    self.originY = def.originY or 0
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0
    self.texture = def.texture
    self.stateMachine = def.stateMachine
    self.direction = def.direction or 'right'
    self.map = def.map or nil
    self.currentAnimation = nil
    self.level = def.level or nil
    self.remove = false -- flag for whether to remove/"clean" up this entity
    self.type = def.type or nil
    if def.collidable == false then self.collidable = false else self.collidable = true end
    self.alpha = 255
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:checkClick()
    -- check for mouse clicks (tools)
    if love.mouse.wasPressed() then
        local m = love.mouse.wasPressed() -- get mouse press info
        -- check if this entity was clicked
        if (m.x >= self.x and m.x <= self.x + self.width and
            m.y >= self.y and m.y <= self.y + self.height) then

            print(tostring(self) .. ' clicked')
            self.stateMachine.current:handleClick()
        end
    end
end

function Entity:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function Entity:update(dt)
    self:checkClick()
    self.stateMachine:update(dt)
end

function Entity:draw()
    if self.alpha < 255 then love.graphics.setColor(255, 255, 255, self.alpha) end

    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + self.offsetX, math.floor(self.y) + self.offsetY, 0,
        self.direction == 'right' and self.scaleX or -self.scaleX, self.scaleY, self.originX, self.originY)

    if self.alpha < 255 then love.graphics.setColor(255, 255, 255, 255) end
end
