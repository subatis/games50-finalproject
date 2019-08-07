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
    print('Entered block state')
    -- halt movement
    self.robot.dx = 0

    -- create impassible game object on the map (invisible, since the sprite is the robot)
    local block = gFactory:makeInvisibleBlock(self.robot.x, self.robot.y, self.robot.width, self.robot.height)
    table.insert(self.robot.level.objects, block)
    print('inserted block object to level')
    print_r(self.robot.level.objects)
end

-- input
function RobotBlockState:handleClick()
    if self.robot.level.player.tool == TOOLDEFS['BOMB'] then
        print('applied bomb')
        self.robot:changeState('bomb')
    end
end

function RobotBlockState:update(dt)

    --[[ DEBUG: manual input
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.robot:changeState('walking')
    end

    if love.keyboard.wasPressed('space') then
        self.robot:changeState('jump')
    end
    ]]
end
