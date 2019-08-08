--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

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

function RobotWalkingState:enter(params) end

-- handle input; can apply any tool except umbrella
function RobotWalkingState:handleClick()
    if self.robot.level.player.tool == TOOLDEFS['BLOCK'] then
        self.robot:changeState('block')
    elseif self.robot.level.player.tool == TOOLDEFS['BOMB'] then
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

    -- update position and reverse directions if the robot hits a wall; check left/right collisions
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

    -- check if we have gone off screen
    if self.robot.x + self.robot.width < 0 or self.robot.x > VIRTUAL_WIDTH then
        self.robot:changeState('dying')
    end
end
