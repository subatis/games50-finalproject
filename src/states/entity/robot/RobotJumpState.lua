RobotJumpState = Class{__includes = BaseState}

function RobotJumpState:init(robot)
    self.robot = robot
    self.gravity = GRAVITY
    self.animation = Animation {
        frames = { ROBOTFRAMES['FALLING'] },
        interval = 1
    }
    self.robot.currentAnimation = self.animation
end

function RobotJumpState:enter(params)
    --gSounds['jump']:play()
    self.robot.dy = ROBOT_JUMP_VELOCITY
end

function RobotJumpState:update(dt)
    self.robot.currentAnimation:update(dt)
    self.robot.dy = self.robot.dy + self.gravity
    self.robot.y = self.robot.y + (self.robot.dy * dt)

    -- go into the falling state when y velocity is positive
    if self.robot.dy >= 0 then
        self.robot:changeState('falling')
    end

    self.robot.y = self.robot.y + (self.robot.dy * dt)

    -- look at two tiles above our head and check for collisions; 3 pixels of leeway for getting through gaps
    local tileLeft = self.robot.map:pointToTile(self.robot.x + 3, self.robot.y)
    local tileRight = self.robot.map:pointToTile(self.robot.x + self.robot.width - 3, self.robot.y)

    -- if we get a collision up top, go into the falling state immediately
    if (tileLeft and tileRight) and (tileLeft.impassible or tileRight.impassible) then
        self.robot.dy = 0
        self.robot.y = tileLeft.y * TILE_SIZE - 1 -- shift down to below tile
        self.robot:changeState('falling')

    elseif self.robot.direction == 'left' then
        self.robot.dx = -ROBOT_WALK_SPEED
        self.robot.x = self.robot.x + (self.robot.dx * dt)
        self.robot:checkLeftCollisions(dt)
    elseif self.robot.direction == 'right' then
        self.robot.dx = ROBOT_WALK_SPEED
        self.robot.x = self.robot.x + (self.robot.dx * dt)
        self.robot:checkRightCollisions(dt)
    end

    --[[ DEBUG: manual input
    -- else test our sides
    elseif love.keyboard.isDown('left') then
        self.robot.direction = 'left'
        self.robot.x = self.robot.x - ROBOT_WALK_SPEED * dt
        self.robot:checkLeftCollisions(dt)
    elseif love.keyboard.isDown('right') then
        self.robot.direction = 'right'
        self.robot.x = self.robot.x + ROBOT_WALK_SPEED * dt
        self.robot:checkRightCollisions(dt)
    end
    ]]
end
