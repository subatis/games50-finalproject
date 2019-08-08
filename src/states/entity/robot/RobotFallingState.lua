--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

RobotFallingState = Class{__includes = BaseState}

function RobotFallingState:init(robot)
    self.robot = robot
    self.gravity = GRAVITY
    self.animation = Animation {
        frames = { ROBOTFRAMES['FALLING'] },
        interval = 1
    }
    self.robot.currentAnimation = self.animation
    self.terminalSoundPlayed = false -- flag to ensure we only play terminal falling sound once
end

function RobotFallingState:enter(params) end

-- handle input; can apply umbrella
function RobotFallingState:handleClick()
    if self.robot.level.player.tool == TOOLDEFS['UMBRELLA'] then
        self.robot:changeState('umbrella')
    end
end

-- Apply gravity and check for ground/objects underneathe
function RobotFallingState:update(dt)
    self.robot.currentAnimation:update(dt)
    self.robot.dy = math.min(TERMINAL_VELOCITY, self.robot.dy + self.gravity)
    self.robot.y = self.robot.y + (self.robot.dy * dt)

    -- change sprite if we are at 'terminal velocity'
    if self.robot.dy == TERMINAL_VELOCITY then
        if not self.terminalSoundPlayed then
            gSounds['robot_terminal_fall']:play()
            self.terminalSoundPlayed = true
        end

        self.animation = Animation {
            frames = { ROBOTFRAMES['TERMINAL_FALLING'] },
            interval = 1
        }
        self.robot.currentAnimation = self.animation
    end

    -- locate the two tiles below and check for collisions
    local tileBottomLeft = self.robot.map:pointToTile(self.robot.x + 1, self.robot.y + self.robot.height)
    local tileBottomRight = self.robot.map:pointToTile(self.robot.x + self.robot.width - 1, self.robot.y + self.robot.height)

    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft.impassible or tileBottomRight.impassible) then
        -- stop x motion
        self.robot.dx = 0

        -- if we are still falling at terminal velocity, blow up
        if self.robot.dy == TERMINAL_VELOCITY then
            self.robot.dy = 0
            self.robot:changeState('dying')
        else
            self.robot.dy = 0
            self.robot:changeState('idle')
            self.robot.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.robot.height
        end

    -- still falling; maintain x-direction momentum if we had any and check left/right collisions
    elseif self.robot.dx < 0 then
        self.robot.x = self.robot.x + (self.robot.dx * dt)
        self.robot:checkLeftCollisions(dt)
    elseif self.robot.dx > 0 then
        self.robot.x = self.robot.x + (self.robot.dx * dt)
        self.robot:checkRightCollisions(dt)
    end

    -- check if we've collided with any collidable game objects
    for k, object in pairs(self.robot.level.objects) do
        if object:collides(self.robot) then
            if object.impassible then
                -- stop x motion, reset position above object
                self.robot.dx = 0
                self.robot.y = object.y - self.robot.height

                -- die or stop, depending on speed
                if self.robot.dy == TERMINAL_VELOCITY then
                    self.robot.dy = 0
                    self.robot:changeState('dying')
                else
                    self.robot.dy = 0
                    self.robot:changeState('idle')
                end
            end
        end
    end

    -- check if we are off the screen
    if self.robot.y > VIRTUAL_HEIGHT then
        self.robot:changeState('dying')
    end
end
