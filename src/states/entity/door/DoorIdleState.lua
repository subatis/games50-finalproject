DoorIdleState = Class{__includes = BaseState}

function DoorIdleState:init(door)
    self.door = door
    self.idleDoorFrame = self.door.type == 'in' and DOORFRAMES['IN_1'] or DOORFRAMES['OUT_1']
    self.animation = Animation {
        frames = { self.idleDoorFrame },
        interval = 1
    }
    self.door.currentAnimation = self.animation
end

function DoorIdleState:enter(params)

end

function DoorIdleState:onRobotCollide(robot)
    if robot.collidable then
        local tweenX = robot.direction == 'right' and (robot.x + TILE_SIZE) or (robot.x - TILE_SIZE)
        self.door:changeState('open')
        Timer.after(1.2, function()
                            Timer.tween(0.25,
                                {[robot] = {alpha = 0, x = tweenX}}):finish(function()
                                    robot.remove = true
                                    self.door.level.robotsSaved = self.door.level.robotsSaved + 1
                                end)
                         end)
    end
end

function DoorIdleState:update(dt)

end
