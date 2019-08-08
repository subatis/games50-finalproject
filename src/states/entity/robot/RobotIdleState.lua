--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

RobotIdleState = Class{__includes = BaseState}

function RobotIdleState:init(robot)
    self.robot = robot
    self.animation = Animation {
        frames = { ROBOTFRAMES['IDLE'] },
        interval = 1
    }
    self.robot.currentAnimation = self.animation
end

function RobotIdleState:enter(params) end

-- handle input; can apply all tools except umbrella
function RobotIdleState:handleClick()
    if self.robot.level.player.tool == TOOLDEFS['BLOCK'] then
        self.robot:changeState('block')
    elseif self.robot.level.player.tool == TOOLDEFS['BOMB'] then
        self.robot:changeState('bomb')
    else
        self.robot:changeState('jump')
    end
end

function RobotIdleState:update(dt)
    -- start walking if we aren't falling, jumping or exiting (uses collidable, see Robot:checkExitCollisions())
    if self.robot.dy == 0 and self.robot.collidable then
        self.robot:changeState('walking')
    end
end
