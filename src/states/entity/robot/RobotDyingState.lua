--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

RobotDyingState = Class{__includes = BaseState}

function RobotDyingState:init(robot)
    self.robot = robot
    self.robot.texture = 'robot_death'
    self.animation = Animation {
        frames = { 1, 2, 3, 4, 5, 6, 7, 8 },
        interval = 0.1
    }
    self.robot.currentAnimation = self.animation
end

function RobotDyingState:enter()
    gSounds['robot_death']:play()
end

-- Finish explosion once and delete, update level with a lost robot
function RobotDyingState:update(dt)
    self.robot.currentAnimation:update(dt)

    if self.robot.currentAnimation.currentFrame == #self.robot.currentAnimation.frames then
        self.robot.level.robotsLost = self.robot.level.robotsLost + 1
        self.robot.remove = true
    end
end
