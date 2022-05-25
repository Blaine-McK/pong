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
    
    -- Set the texture filtering so there is no blurring effect on fonts or textures
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- create font and size
    smallFont = love.graphics.newFont('consola.ttf', 16)
    -- Set the font
    love.graphics.setFont(smallFont)

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

    -- Clear the screen resetting it to black
    love.graphics.clear()

    -- Print text at top center of screen
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    -- Draw the 2 player paddles and ball to the screen
    love.graphics.rectangle('fill', 10, 30, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 5, 5)

    push:apply('end')
end
