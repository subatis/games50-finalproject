--[[ For "DRONES" by Erik Subatis 2019, final project for GD50

    This class manufactures game objects just using key parameters. ]]

ObjectFactory = Class{}
function ObjectFactory:init() end

-- Make a robot based off of global parameters at x,y,direction with a reference to the level it is in
function ObjectFactory:makeRobot(robotX, robotY, robotDirection, robotLevel)
    local robot -- declare first to ensure unique "copies" to pass into StateMachine
    robot = Robot({
                x = robotX,
                y = robotY,
                direction = robotDirection,
                scaleX = ROBOT_SCALE_X,
                scaleY = ROBOT_SCALE_Y,
                offsetX = ROBOT_OFFSET_X,
                offsetY = ROBOT_OFFSET_Y,
                width = TILE_SIZE,
                height = TILE_SIZE,
                originX = TILE_SIZE / 4,
                originY = TILE_SIZE / 4,
                texture = 'robot',
                stateMachine = StateMachine {
                    ['idle'] = function() return RobotIdleState(robot) end,
                    ['falling'] = function() return RobotFallingState(robot) end,
                    ['walking'] = function() return RobotWalkingState(robot) end,
                    ['jump'] = function() return RobotJumpState(robot) end,
                    ['umbrella'] = function() return RobotUmbrellaState(robot) end,
                    ['block'] = function() return RobotBlockState(robot) end,
                    ['bomb'] = function() return RobotBombExplodingState(robot) end,
                    ['dying'] = function() return RobotDyingState(robot) end
                },
                level = robotLevel,
                map = robotLevel.map,
                type = 'robot',
                collidable = true
            })
    return robot
end

-- Make an entrance or exit for the level; doorType == 'in' or 'out'
function ObjectFactory:makeDoor(doorX, doorY, doorLevel, doorType)
    local door -- declare first to ensure unique "copies" to pass into StateMachine
    door = Entity ({
                x = doorX,
                y = doorY,
                width = TILE_SIZE,
                height = TILE_SIZE * 2,
                texture = 'doors',
                stateMachine = StateMachine {
                    ['idle'] = function() return DoorIdleState(door) end,
                    ['open'] = function() return DoorOpenState(door) end,
                    ['close'] = function() return DoorCloseState(door) end
                },
                level = doorLevel,
                map = doorLevel.map,
                type = doorType,
                collidable = true
            })
    return door
end

-- Make invisible & impassible block at robot location when using block tool
function ObjectFactory:makeInvisibleBlock(blockX, blockY, blockWidth, blockHeight)
    local block
    block = GameObject {
                       x = blockX,
                       y = blockY,
                       width = blockWidth,
                       height = blockHeight,
                       impassible = true,
                       collidable = true,
                       visible = false
                  }
    return block
end
