RobotWalkingState = Class{__includes = BaseState}

function RobotWalkingState:init(robot)
    self.robot = robot
    self.animation = Animation {
        frames = { ROBOTFRAMES['WALK_1'],
                   ROBOTFRAMES['WALK_2'],
                   ROBOTFRAMES['WALK_3'],
                   ROBOTFRAMES['WALK_4'],
                   ROBOTFRAMES['WALK_5'] },
        interval = 0.15
    }
    self.robot.currentAnimation = self.animation
end

function RobotWalkingState:enter(params)
    --print('Entered walk state')
end

-- input
function RobotWalkingState:handleClick()
    if self.robot.level.player.tool == TOOLDEFS['BLOCK'] then
        print('applied block')
        self.robot:changeState('block')
    elseif self.robot.level.player.tool == TOOLDEFS['BOMB'] then
        print('applied bomb')
        self.robot:changeState('bomb')
    else
        self.robot:changeState('jump')
    end
end

-- The robot should walk back and forth automatically within whatever boundaries exist
function RobotWalkingState:update(dt)
    self.robot.currentAnimation:update(dt)

    -- locate the two tiles below and and check for collisions
    local tileBottomLeft = self.robot.map:pointToTile(self.robot.x + 1, self.robot.y + self.robot.height)
    local tileBottomRight = self.robot.map:pointToTile(self.robot.x + self.robot.width - 1, self.robot.y + self.robot.height)
    local collidedObjects = self.robot:checkObjectCollisions()

    -- check to see whether there are any tiles beneath us/whether we are touching any objects
    if (tileBottomLeft and tileBottomRight) and (not tileBottomLeft.impassible and not tileBottomRight.impassible)
       and #collidedObjects == 0 then
        self.robot.dy = 0
        self.robot:changeState('falling')

    -- update position and reverse directions if the robot hits a wall
    elseif self.robot.direction == 'left' then
        self.robot.dx = -ROBOT_WALK_SPEED
        self.robot.x = self.robot.x + (self.robot.dx * dt)
        if self.robot:checkLeftCollisions(dt) then
            self.robot.direction = 'right'
        end
    elseif self.robot.direction == 'right' then
        self.robot.dx = ROBOT_WALK_SPEED
        self.robot.x = self.robot.x + (self.robot.dx * dt)
        if self.robot:checkRightCollisions(dt) then
            self.robot.direction = 'left'
        end
    end

    -- check if we have collided with the exit
    self.robot:checkExitCollision()

    --[[ DEBUG : manual input
    -- idle if we're not pressing anything at all
    if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
        self.robot:changeState('idle')
    else
        -- locate the two tiles below and check for collisions
        local tileBottomLeft = self.robot.map:pointToTile(self.robot.x + 1, self.robot.y + self.robot.height)
        local tileBottomRight = self.robot.map:pointToTile(self.robot.x + self.robot.width - 1, self.robot.y + self.robot.height)

        -- temporarily shift player down a pixel to test for game objects beneath
        --self.player.y = self.player.y + 1
        --local collidedObjects = self.player:checkObjectCollisions()
        --self.player.y = self.player.y - 1

        -- check to see whether there are any tiles beneath us | removed: #collidedObjects == 0 and
        if (tileBottomLeft and tileBottomRight) and (not tileBottomLeft.impassible and not tileBottomRight.impassible) then
            self.robot.dy = 0
            self.robot:changeState('falling')
        elseif love.keyboard.isDown('left') then
            self.robot.x = self.robot.x - ROBOT_WALK_SPEED * dt
            self.robot.direction = 'left'
            self.robot:checkLeftCollisions(dt)
        elseif love.keyboard.isDown('right') then
            self.robot.x = self.robot.x + ROBOT_WALK_SPEED * dt
            self.robot.direction = 'right'
            self.robot:checkRightCollisions(dt)
        end
    end

    if love.keyboard.wasPressed('space') then
        self.robot:changeState('jump')
    end

    ]]
end
