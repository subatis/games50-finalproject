--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

RobotUmbrellaState = Class{__includes = BaseState}

function RobotUmbrellaState:init(robot)
    self.robot = robot
    self.gravity = GRAVITY
    self.animation = Animation {
        frames = { ROBOTFRAMES['UMBRELLA'] },
        interval = 1
    }
    self.robot.currentAnimation = self.animation
end

function RobotUmbrellaState:enter(params)
    gSounds['robot_umbrella']:play()
    self.robot.dy = 0
end

-- Apply gravity and check for ground/objects underneathe
function RobotUmbrellaState:update(dt)
    self.robot.currentAnimation:update(dt)
    -- UMBRELLA halves dy
    self.robot.dy = math.min(TERMINAL_VELOCITY, self.robot.dy + self.gravity) * UMBRELLA_GRAVITY_FACTOR
    self.robot.y = self.robot.y + (self.robot.dy * dt)

    -- change sprite if we are at 'terminal velocity'
    if self.robot.dy == TERMINAL_VELOCITY then
        self.animation = Animation {
            frames = { ROBOTFRAMES['TERMINAL_FALLING'] },
            interval = 1
        }
        self.robot.currentAnimation = self.animation
    end

    -- locate the two tiles above and below and check for collisions
    local tileBottomLeft = self.robot.map:pointToTile(self.robot.x + 1, self.robot.y + self.robot.height)
    local tileBottomRight = self.robot.map:pointToTile(self.robot.x + self.robot.width - 1, self.robot.y + self.robot.height)

    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft.impassible or tileBottomRight.impassible) then
        self.robot.dx = 0
        self.robot.dy = 0
        self.robot:changeState('idle')
        self.robot.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.robot.height
    -- maintain x-direction momentum if we are still falling, check left/right collisions
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
