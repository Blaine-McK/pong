-- Import the 'push' library
push = require 'push'

-- Set the dimensions of the window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Set the 'virtual' window dimensions
-- This allows us to mimick lower resolution (as uf the window was 432 x 243)
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Initialize the game and set resolution, use virtual resolution
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- Add a way to quit the game by user input
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- Draw text to the window
function love.draw()
    push:apply('start')
    love.graphics.printf(
        'Hello Pong!',
        0,
        VIRTUAL_HEIGHT / 2 - 6,
        VIRTUAL_WIDTH,
        'center')
    push:apply('end')
end
