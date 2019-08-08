# Drones
By Erik Subatis for GD50 (Harvard's Intro to Game Development) Summer 2019

## Description
My final project was inspired by the classic game Lemmings (https://www.youtube.com/watch?v=xIuxB1oR2WQ).
It used Mario50 as a (loose) base. The game works as follows:

* Robots spawn from an "in door" some number of times at regular intervals. The goal is to
  guide some number of them to the "out door" placed elsewhere in the level. These parameters
  are specific to the map.

* Robots will die if they fall from too great a height (if they hit the ground after reaching
  "terminal velocity"), or if they touch a tile containing spikes. These obstacles can be
  avoided by applying "tools" to the robots. To select a tool, click it on the GUI and then
  click a robot. You can also use the 1-3 keys on the keyboard to toggle tools. The \` key deselects
  all tools. The following actions are available:
    - JUMP: Clicking a walking robot with no tool selected OR an "illegal" tool selected causes
            the robot to jump.
    - UMBRELLA: Clicking a falling robot with the umbrella tool causes the robot to glide down slowly
                (maintaining x-direction), avoiding a "terminal velocity" death.
    - BLOCK: Clicking a walking robot with the block tool causes the robot to become an impassible
             stationary block, forcing robots that hit it to reverse direction. A block can also be
             jumped/walked on like any other impassible tile/object. This robot is "sacrificed".
    - BOMB: Clicking a walking robot with the bomb tool causes the robot to instantly explode,
            destroying any destructible tiles nearby (up to 9). Generally speaking, "plain"
            blocks are destructible while pipes/decorated blocks are not. This robot is "sacrificed".

* Attaining the "goal" number of rescued robots immediately moves you to the next level or
  the victory screen. If too many robots die to make the goal unreachable (this includes using robots
  as blocks or bombs), it is GAME OVER. A robot must walk into the exit door.

* There are 3 hard coded levels. Creating a data-driven way of building levels (for example using
  a tool like Tiled) would be an obvious next step! For now, these levels are defined in src/dependencies.lua.

Credits/links for assets are in assets/assets_sources.txt.

Thanks GD50 staff for a great course!
