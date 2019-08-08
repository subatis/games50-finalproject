--[[ For "DRONES" by Erik Subatis 2019, final project for GD50 ]]

RobotBombExplodingState = Class{__includes = BaseState}

function RobotBombExplodingState:init(robot)
    self.robot = robot
    self.robot.texture = 'explosion'

    -- scale new explosion image down
    self.robot.scaleX = self.robot.scaleX / 2
    self.robot.scaleY = self.robot.scaleY / 2
    self.robot.originX = 96 / 2
    self.robot.originY = 96 / 2

    self.animation = Animation {
        frames = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
        interval = 0.1
    }
    self.robot.currentAnimation = self.animation
end

function RobotBombExplodingState:enter()
    gSounds['robot_bomb']:play()

    -- destroy touching/surrounding tiles
    local tiles = {}
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x - BOMB_RADIUS, self.robot.y - BOMB_RADIUS))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x - BOMB_RADIUS, self.robot.y))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x, self.robot.y - BOMB_RADIUS))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x + self.robot.width + BOMB_RADIUS, self.robot.y - BOMB_RADIUS))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x + self.robot.width, self.robot.y - BOMB_RADIUS))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x + self.robot.width + BOMB_RADIUS, self.robot.y))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x - BOMB_RADIUS, self.robot.y + self.robot.height + BOMB_RADIUS))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x - BOMB_RADIUS, self.robot.y + self.robot.height))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x, self.robot.y + self.robot.height + BOMB_RADIUS))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x + self.robot.width + BOMB_RADIUS, self.robot.y + self.robot.height + BOMB_RADIUS))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x + self.robot.width, self.robot.y + self.robot.height + BOMB_RADIUS))
    table.insert(tiles, self.robot.map:pointToTile(self.robot.x + self.robot.width + BOMB_RADIUS, self.robot.y + self.robot.height))

    for i, tile in pairs(tiles) do
        if tile.destructible then
            self.robot.map:removeTile(tile.x, tile.y)
        end
    end
end

-- Finish explosion once and delete robot, update level with a lost robot
function RobotBombExplodingState:update(dt)
    self.robot.currentAnimation:update(dt)

    if self.robot.currentAnimation.currentFrame == #self.robot.currentAnimation.frames then
        self.robot.level.robotsLost = self.robot.level.robotsLost + 1
        self.robot.remove = true
    end
end
