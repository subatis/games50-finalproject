RobotIdleState = Class{__includes = BaseState}

function RobotIdleState:init(robot)
    self.robot = robot
    self.animation = Animation {
        frames = { ROBOTFRAMES['IDLE'] },
        interval = 1
    }
    self.robot.currentAnimation = self.animation
end

function RobotIdleState:enter(params)
    --print('Entered idle state')
end

-- input
function RobotIdleState:handleClick()
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

function RobotIdleState:update(dt)

    -- start walking if we aren't falling, jumping or exiting
    if self.robot.dy == 0 and not self.robot.exit then
        self.robot:changeState('walking')
    end

    --[[ DEBUG: manual input
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.robot:changeState('walking')
    end

    if love.keyboard.wasPressed('space') then
        self.robot:changeState('jump')
    end
    ]]
end
