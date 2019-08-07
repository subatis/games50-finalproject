Robot = Class{__includes = Entity}

function Robot:init(def)
    Entity.init(self, def)
    self.exit = false
end

function Robot:update(dt)
    Entity.update(self, dt)
end

function Robot:draw()
    Entity.draw(self)
end

-- Resets position if we hit something, also returns a bool in case we need to do something else
-- (in particular, robots reverse direction if it hits something while walking)
-- topCollision means we don't want to bother resetting anything since we will be falling anyway
function Robot:checkLeftCollisions(dt, topCollision)
    -- check for left two tiles collision
    local tileTopLeft = self.map:pointToTile(self.x + 1, self.y + 1)
    local tileBottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopLeft and tileBottomLeft) and (tileTopLeft.impassible or tileBottomLeft.impassible) then
        -- check for spikes
        if tileTopLeft.deadly or tileBottomleft.deadly then
            self:changeState('dying')
        end
        self.x = (tileTopLeft.x - 1) * TILE_SIZE + tileTopLeft.width - 1
        return true
    end

    -- check object collisions for LEFT but allow entity to walk on top of object
    self.y = self.y - 1
    local objectCollisions = self:checkObjectCollisions()
    self.y = self.y + 1
    for i, object in pairs(objectCollisions) do
        if self.x < object.x + object.width then
            self.x = self.x - self.dx * dt
            return true
        end
    end

    --[[local objectCollisions = self:checkObjectCollisions()
    if #objectCollisions > 0 then
        --print('LEFT object collision detected')
        self.x = self.x - self.dx * dt
        return true
    end]]

    return false
end

function Robot:checkRightCollisions(dt, topCollision)
    -- check for right two tiles collision
    local tileTopRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopRight and tileBottomRight) and (tileTopRight.impassible or tileBottomRight.impassible) then
        if tileTopRight.deadly or tileBottomRight.deadly then
            self:changeState('dying')
        end
        self.x = (tileTopRight.x - 1) * TILE_SIZE - self.width
        return true
    end

    -- check object collisions for RIGHT but allow entity to walk on top of object
    self.y = self.y - 1
    local objectCollisions = self:checkObjectCollisions()
    self.y = self.y + 1
    for i, object in pairs(objectCollisions) do
        if self.x + self.width > object.x then
            self.x = self.x - self.dx * dt
            return true
        end
    end

    -- check object collisions and reset position if so
    --[[local objectCollisions = self:checkObjectCollisions()
    if #objectCollisions > 0 then
        --print('RIGHT object collision detected')
        self.x = self.x - self.dx * dt
        return true
    end]]

    return false
end

function Robot:checkObjectCollisions()
    local collidedObjects = {}

    for i, object in pairs(self.level.objects) do
        if object:collides(self) then
            if object.impassible then
                table.insert(collidedObjects, object)
            --elseif object.consumable then
            --    object.onConsume(self)
            --    table.remove(self.level.objects, k)
            end
        end
    end

    return collidedObjects
end

function Robot:checkExitCollision()
    if self.level.outDoor:collides(self) then
        print('exit door')
        self.dx = 0
        self.dy = 0
        self.level.outDoor.stateMachine.current:onRobotCollide(self)
        self.exit = true
        self.collidable = false
        self:changeState('idle')
    end
end
