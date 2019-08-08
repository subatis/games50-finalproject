--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

Level = Class{}

function Level:init(def)
    self.map = def.map
    self.player = def.player
    self.background = gBackgrounds[def.background] or gBackgrounds['city_night']
    self.numRobots = self.map.numRobots or DEFAULT_NUM_ROBOTS
    self.goalRobots = self.map.goalRobots or DEFAULT_GOAL_ROBOTS
    self.spawnTime = self.map.spawnTime or DEFAULT_ROBOT_SPAWN_TIME
    self.robotsLost = 0
    self.robotsSaved = 0
    self.robots = {}
    self.objects = {}
    self.gui = Gui('gui', self)

    -- place doors
    self:generateDoors()

    -- spawn robots
    Timer.every(self.spawnTime, function()
                    gSounds['in_door']:play()
                    self.inDoor:changeState('open')
                end):limit(self.numRobots) -- only spawn numRobots
end

function Level:generateDoors()
    -- get door coordinates for this map
    local inDoorX = (self.map.inDoorX - 1) * TILE_SIZE
    local inDoorY = (self.map.inDoorY - 1) * TILE_SIZE
    local outDoorX = (self.map.outDoorX - 1) * TILE_SIZE
    local outDoorY = (self.map.outDoorY - 1) * TILE_SIZE

    self.inDoor = gFactory:makeDoor(inDoorX, inDoorY, self, 'in')
    self.outDoor = gFactory:makeDoor(outDoorX, outDoorY, self, 'out')

    self.inDoor:changeState('idle')
    self.outDoor:changeState('idle')
end

-- did we beat the level or game?
function Level:checkVictory()
    if self.robotsSaved >= self.goalRobots then
        if gLevelNum == 3 then
            gLevelNum = 1
            gStateMachine:change('victory')
        else
            gLevelNum = gLevelNum + 1
            gStateMachine:change('countdown')
        end
    end
end

-- are we screwed?
function Level:checkGameOver()
    if self.numRobots - self.robotsLost < self.goalRobots then
        gLevelNum = 1
        gStateMachine:change('gameover')
    end
end

function Level:update(dt)
    -- update robots, objects and doors
    for i, robot in pairs(self.robots) do
        self.robots[i]:update(dt)
    end

    for i, object in pairs(self.objects) do
        self.objects[i].update(dt)
    end

    self.inDoor:update(dt)
    self.outDoor:update(dt)

    -- clean up robots & objects
    for i, robot in pairs(self.robots) do
        if self.robots[i].remove then
            table.remove(self.robots, i)
        end
    end

    for i, object in pairs(self.objects) do
        if self.objects[i].remove then
            table.remove(self.objects, i)
        end
    end

    -- update GUI
    self.gui:update(dt)

    -- check victory/game over conditions
    self:checkVictory()
    self:checkGameOver()
end

function Level:draw()
    -- draw background
    love.graphics.draw(self.background, 0, 0, 0, 0.5, 0.5)

    -- draw tilemap
    self.map:draw()

    -- draw doors & backgrounds for doors
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('fill', self.inDoor.x, self.inDoor.y, self.inDoor.width, self.inDoor.height)
    love.graphics.rectangle('fill', self.outDoor.x, self.outDoor.y, self.outDoor.width, self.outDoor.height)
    love.graphics.setColor(255, 255, 255, 255)
    self.inDoor:draw()
    self.outDoor:draw()

    -- draw robots
    for i, robot in pairs(self.robots) do
        self.robots[i]:draw()
    end

    -- draw objects
    for i, object in pairs(self.objects) do
        self.objects[i]:draw()
    end

    -- draw GUI
    self.gui:draw()
end
