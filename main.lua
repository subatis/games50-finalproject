--[[
    "DRONES" by Erik Subatis 2019

    Final Project for GD50 (Harvard) Summer 2019 

    Influenced by Lemmings (https://www.youtube.com/watch?v=xIuxB1oR2WQ)

    Drones (robots) spawn intermittently until some maximum number dictated by the map/level
    is reached. The goal is to guide some number of these drones (also dictated by the map/level)
    to the exit door safely using a variety of tools (select tools with mouse on GUI or 1-x on
    keyboard and then click drone to apply). Long falls or spikes will kill the robots.

    See lib and/or dependencies for detailed credits (hump, knife, coltonoscopy (GD50))
]]

love.graphics.setDefaultFilter('nearest', 'nearest')
require 'src/dependencies'

function love.load()
    math.randomseed(os.time())

    -- initialize push
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = false
    })

    -- set music to loop and start
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    -- global state machine for game state
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['gameover'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end
    }
    gStateMachine:change('start')

    -- "factory" to generate entities
    gFactory = ObjectFactory()

    -- level to load
    gLevelNum = 1

    -- initialize input table(s)
    love.keyboard.keysPressed = {}
    love.mouse.pressed = {}
end

-- resize window using push
function love.resize(w, h)
    push:resize(w, h)
end

-- handle input
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- captures when the mouse button is pressed and converts to game coordinates
function love.mousepressed(x, y, button)
    -- we are only concerned with left mouse clicks (button 1)
    if button == 1 then
        love.mouse.pressed['wasPressed'] = true
        love.mouse.pressed['x'], love.mouse.pressed['y'] = push:toGame(x, y)
    end
end

-- returns false if no mouse press, or gives us the pressed table to access x/y
function love.mouse.wasPressed()
    -- ensure we have valid game coordinates
    if love.mouse.pressed.wasPressed and love.mouse.pressed.x and love.mouse.pressed.y then
        return love.mouse.pressed
    else
        return false
    end
end

-- main loop: update and draw
function love.update(dt)
    gStateMachine:update(dt)

    -- clear input table(s)
    love.keyboard.keysPressed = {}
    love.mouse.pressed = {}

    -- update timer
    Timer.update(dt)
end

function love.draw()
    push:start()

    gStateMachine:render()

    push:finish()
end
