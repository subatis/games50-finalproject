Gui = Class{}

function Gui:init(guiImg, level)
    self.guiImg = guiImg
    self.level = level
end

-- Check and handle mouseclicks
function Gui:update(dt)
    if love.mouse.wasPressed() then
        local m = love.mouse.wasPressed() -- get mouse press info

        -- if it's outside the GUI do nothing; otherwise check button
        if m.y < GUI_Y then return
        else
            local buttonPressed = -1
            -- cycle through buttons and determine which
            for i = 0, NUM_GUI_BUTTONS - 1 do
                if m.x > i * TILE_SIZE and m.x < i * TILE_SIZE + TILE_SIZE then
                    buttonPressed = i + 1
                    break
                end
            end

            -- handle button; skip rest if we didn't click a button
            if buttonPressed < 0 then return
            else
                print('tool pressed; tool #' ..tostring(buttonPressed))
                self.level.player.tool = buttonPressed
            end

        end
    end
end

-- Draws uniformly sized tiles horizontally and level stats
function Gui:draw()
    for i, quad in pairs(gFrames[self.guiImg]) do
        love.graphics.draw(gTextures[self.guiImg], gFrames[self.guiImg][i], (GUI_X + i - 1) * TILE_SIZE, GUI_Y)
    end

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('SAVED: ' .. tostring(self.level.robotsSaved) .. ' | GOAL: ' .. tostring(self.level.goalRobots),
                         0, VIRTUAL_HEIGHT - TILE_SIZE, VIRTUAL_WIDTH, 'right')
end
