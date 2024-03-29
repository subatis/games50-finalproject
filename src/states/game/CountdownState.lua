--[[ For "DRONES" by Erik Subatis 2019, final project for GD50;
     credit:
        Countdown State
        Author: Colton Ogden
        cogden@cs50.harvard.edu

        Counts down visually on the screen (3,2,1) so that the player knows the
        game is about to begin. Transitions to the PlayState as soon as the
        countdown is complete.
]]

CountdownState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 1

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    -- loop timer back to 0 (plus however far past COUNTDOWN_TIME we've gone)
    -- and decrement the counter once we've gone past the countdown time
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1
        gSounds['countdown']:play()

        -- when 0 is reached, we should enter the PlayState
        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.draw(gBackgrounds['city_sunset'], 0, 0, 0, 0.5, 0.5)

    -- render count big in the middle of the screen
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('level ' .. tostring(gLevelNum), 0, 50, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
