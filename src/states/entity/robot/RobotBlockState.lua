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

    -- this robot can no longer be saved
    self.robot.level.robotsLost = self.robot.level.robotsLost + 1

    -- create impassible game object on the map (invisible, since the sprite is the robot)
    -- slightly smaller than tile_size
    local block = gFactory:makeInvisibleBlock(self.robot.x + 6, self.robot.y + 6, self.robot.width - 6, self.robot.height - 6)
    table.insert(self.robot.level.objects, block)
end

function RobotBlockState:handleClick() end

function RobotBlockState:update(dt) end
