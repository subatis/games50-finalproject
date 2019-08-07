DoorOpenState = Class{__includes = BaseState}

function DoorOpenState:init(door)
    self.door = door
    self.animation = self.door.type == 'in' and Animation {
        frames = { DOORFRAMES['IN_1'],
                   DOORFRAMES['IN_2'],
                   DOORFRAMES['IN_3'],
                   DOORFRAMES['IN_4'],
                   DOORFRAMES['IN_5'],
                   DOORFRAMES['IN_6'],
                   DOORFRAMES['IN_7'],
                   DOORFRAMES['IN_8'],
                   DOORFRAMES['IN_9'],
                   DOORFRAMES['IN_10'] },
                   interval = 0.1
    } or Animation {
        frames = { DOORFRAMES['OUT_1'],
                   DOORFRAMES['OUT_2'],
                   DOORFRAMES['OUT_3'],
                   DOORFRAMES['OUT_4'],
                   DOORFRAMES['OUT_5'],
                   DOORFRAMES['OUT_6'],
                   DOORFRAMES['OUT_7'],
                   DOORFRAMES['OUT_8'],
                   DOORFRAMES['OUT_9'],
                   DOORFRAMES['OUT_10'],
                   DOORFRAMES['OUT_11'],
                   DOORFRAMES['OUT_12'] },
                   interval = 0.1
    }
    self.door.currentAnimation = self.animation
end

function DoorOpenState:enter(params)

end

function DoorOpenState:onRobotCollide(robot)
    if robot.collidable then
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

function DoorOpenState:update(dt)
    self.door.currentAnimation:update(dt)

    if self.door.currentAnimation.currentFrame == #self.door.currentAnimation.frames then
        if self.door.type == 'in' then
            local robot = gFactory:makeRobot(self.door.x, self.door.y + TILE_SIZE, 'right', self.door.level)
            robot:changeState('falling')
            table.insert(self.door.level.robots, robot)
        end

        self.door:changeState('close')
    end
end
