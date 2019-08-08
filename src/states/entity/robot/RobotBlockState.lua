--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

RobotBlockState = Class{__includes = BaseState}

function RobotBlockState:init(robot)
    self.robot = robot
    self.animation = Animation {
        frames = { ROBOTFRAMES['BLOCK'] },
        interval = 1
    }
    self.robot.currentAnimation = self.animation
end

function RobotBlockState:enter(params)
    -- play sound & halt movement
    gSounds['robot_block']:play()
    self.robot.dx = 0

    -- create impassible game object on the map (invisible, since the sprite is the robot)
    local block = gFactory:makeInvisibleBlock(self.robot.x, self.robot.y, self.robot.width, self.robot.height)
    table.insert(self.robot.level.objects, block)
end

-- input; can apply bomb tool
function RobotBlockState:handleClick()
    if self.robot.level.player.tool == TOOLDEFS['BOMB'] then
        self.robot:changeState('bomb')
    end
end

function RobotBlockState:update(dt) end
