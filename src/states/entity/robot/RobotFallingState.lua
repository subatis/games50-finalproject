RobotFallingState = Class{__includes = BaseState}

function RobotFallingState:init(robot)
    self.robot = robot
    self.gravity = GRAVITY
    self.animation = Animation {
        frames = { ROBOTFRAMES['FALLING'] },
        interval = 1
    }
    self.robot.currentAnimation = self.animation
end

function RobotFallingState:enter(params)
    --print('Entered fall state')
end

function RobotFallingState:handleClick()
    if self.robot.level.player.tool == TOOLDEFS['UMBRELLA'] then
        print('applied umbrella')
        self.robot:changeState('umbrella')
    end
end

-- Apply gravity and check for ground/objects underneathe
function RobotFallingState:update(dt)
    self.robot.currentAnimation:update(dt)
    self.robot.dy = math.min(TERMINAL_VELOCITY, self.robot.dy + self.gravity)
    --DEBUG: print(tostring(self.robot.dy))
    self.robot.y = self.robot.y + (self.robot.dy * dt)

    -- change sprite if we are at 'terminal velocity'
    if self.robot.dy == TERMINAL_VELOCITY then
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

    -- still falling; maintain x-direction momentum if we had any
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
            --elseif object.consumable then
            --    object.onConsume(self.player)
            --    table.remove(self.player.level.objects, k)
            end
        end
    end

    --[[ DEBUG: manual input
    -- if impassible, switch states
    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft.impassible or tileBottomRight.impassible) then
        self.robot.dy = 0

        -- set the player to be walking or idle on landing depending on input
        if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
            self.robot:changeState('walking')
        else
            self.robot:changeState('idle')
        end

        self.robot.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.robot.height

        -- check side collisions and reset position
    elseif love.keyboard.isDown('left') then
        self.robot.direction = 'left'
        self.robot.x = self.robot.x - ROBOT_WALK_SPEED * dt
        self.robot:checkLeftCollisions(dt)
    elseif love.keyboard.isDown('right') then
        self.robot.direction = 'right'
        self.robot.x = self.robot.x + ROBOT_WALK_SPEED * dt
        self.robot:checkRightCollisions(dt)
    end
    ]]
end
