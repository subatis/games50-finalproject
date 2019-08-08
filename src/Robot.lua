--[[ For "DRONES" by Erik Subatis 2019, final project for GD50;
     Core code is from GD50 (Harvard) originally ]]

Robot = Class{__includes = Entity}

function Robot:init(def)
    Entity.init(self, def)
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
        -- check for deadly spikes/tiles
        if tileTopLeft.deadly or tileBottomLeft.deadly then
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

    return false
end

function Robot:checkRightCollisions(dt, topCollision)
    -- check for right two tiles collision
    local tileTopRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopRight and tileBottomRight) and (tileTopRight.impassible or tileBottomRight.impassible) then
        -- check for deadly spikes/tiles
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

    return false
end

function Robot:checkObjectCollisions()
    local collidedObjects = {}

    for i, object in pairs(self.level.objects) do
        if object:collides(self) and object.impassible then
            table.insert(collidedObjects, object)
        end
    end

    return collidedObjects
end

-- Check whether this robot has made its way to the exit door;
-- 'collidable' is used to ensure things only happen once
function Robot:checkExitCollision()
    if self.level.outDoor:collides(self) then
        if self.collidable then
            gSounds['out_door']:stop()
            gSounds['out_door']:play()
        end

        self.dx = 0
        self.dy = 0
        self.level.outDoor.stateMachine.current:onRobotCollide(self) -- door callback
        self.collidable = false -- change collidable flag per above
        self:changeState('idle') -- change animation while exiting
    end
end
