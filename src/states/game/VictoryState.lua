--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

VictoryState = Class{__includes = BaseState}

function VictoryState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
end

function VictoryState:render()
    love.graphics.draw(gBackgrounds['city_sunset'], 0, 0, 0, 0.5, 0.5)

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(34, 34, 34, 255)
    love.graphics.printf('Congratulations! You saved us!', 2, VIRTUAL_HEIGHT / 4 - 30, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH, 'center')
end
