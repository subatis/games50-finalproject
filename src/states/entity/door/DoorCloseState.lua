--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

DoorCloseState = Class{__includes = BaseState}

function DoorCloseState:init(door)
    self.door = door

    -- different animations for in vs. out door based on door.doorType
    self.animation = self.door.type == 'in' and Animation {
        frames = { DOORFRAMES['IN_10'],
                   DOORFRAMES['IN_9'],
                   DOORFRAMES['IN_8'],
                   DOORFRAMES['IN_7'],
                   DOORFRAMES['IN_6'],
                   DOORFRAMES['IN_5'],
                   DOORFRAMES['IN_4'],
                   DOORFRAMES['IN_3'],
                   DOORFRAMES['IN_2'],
                   DOORFRAMES['IN_1'] },
        interval = 0.1
    } or Animation {
        frames = {
                   DOORFRAMES['OUT_12'],
                   DOORFRAMES['OUT_11'],
                   DOORFRAMES['OUT_10'],
                   DOORFRAMES['OUT_9'],
                   DOORFRAMES['OUT_8'],
                   DOORFRAMES['OUT_7'],
                   DOORFRAMES['OUT_6'],
                   DOORFRAMES['OUT_5'],
                   DOORFRAMES['OUT_4'],
                   DOORFRAMES['OUT_3'],
                   DOORFRAMES['OUT_2'],
                   DOORFRAMES['OUT_1']
        },
        interval = 0.1
    }
    self.door.currentAnimation = self.animation
end

function DoorCloseState:enter(params) end

-- robots should wait for door to completely open, disappear and update level robotsSaved
function DoorCloseState:onRobotCollide(robot)
    -- if robot collides while door is closed, switch animations but maintain current
    -- frame index for smooth animation
    if robot.collidable then
        local curFrame = self.door.currentAnimation.currentFrame
        self.door:changeState('open')
        self.door.currentAnimation.currentFrame = curFrame

        -- calculate how long the door will take to open and then tween robot into the door (and fade)
        local tweenX = robot.direction == 'right' and (robot.x + TILE_SIZE) or (robot.x - TILE_SIZE)
        local timeToOpen = (#self.door.currentAnimation.frames - self.door.currentAnimation.currentFrame) * 0.1
        Timer.after(timeToOpen, function()
                            Timer.tween(0.25,
                                {[robot] = {alpha = 0, x = tweenX}}):finish(function()
                                    robot.remove = true
                                    self.door.level.robotsSaved = self.door.level.robotsSaved + 1
                                end)
                         end)
    end
end

-- once door is shut, change to idle state
function DoorCloseState:update(dt)
    self.door.currentAnimation:update(dt)

    if self.door.currentAnimation.currentFrame == #self.door.currentAnimation.frames then
        self.door:changeState('idle')
    end
end
