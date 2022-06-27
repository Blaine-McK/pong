-- Import the 'push' library
push = require 'push'

-- Import the 'class' library, this will allow us to
-- represent anything in the game as code instead of keeping track of many
-- variables and methods
Class = require 'class'

-- Include our paddle class, has the position and dimensions for each paddle,
-- also responsibile for rendering them.
require 'Paddle'

-- Include our ball class, has the position, dimensions and velocity for the ball
require 'Ball'

-- Set the dimensions of the window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Set the 'virtual' window dimensions
-- This allows us to mimick lower resolution (as uf the window was 432 x 243)
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Set constant for the speed of the paddle
PADDLE_SPEED = 200

-- Initialize the game and set resolution, use virtual resolution
function love.load()
   
    -- Add a title to the window for more polish
    love.window.setTitle('Pong')

    -- Seed the random number generator using current time
    math.randomseed(os.time())

    -- Set the texture filtering so there is no blurring effect on fonts or textures
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- create fonts and set sizes
    smallFont = love.graphics.newFont('consola.ttf', 16)
    scoreFont = love.graphics.newFont('consola.ttf', 32)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Initialise the player paddles
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH -10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- Place the ball in the center of the screen
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Rudimentary state machine
    gameState = 'start'

end

-- Add interactivity through the update method
function love.update(dt)
    if gameState == 'play' then
        -- Check for ball collision with paddle for player 1
        if ball:collides(player1) then
            -- Reverse the direction of the ball and slightly increase velocity
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- Keep the velocity going in the same direction but randomise it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- Check for ball collision with paddle for player 2
        if ball:collides(player2) then
            -- Reverse the direction of the ball and slightly increase velocity
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 5

            -- Keep the velocity going in the same direction but randomise it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- detect upper and lower screen boundary collision and reverse
        -- minus 4 to account for ball height
        if ball.y < 0 or ball.y > VIRTUAL_HEIGHT - 4 then
            ball.dy = -ball.dy
        end
    end

    -- Player1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- Player2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- Update ball position
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)

    -- Clear table of jeys pressed as it is the end of frame
    love.keyboard.keysPressed = {}
end

-- Draw text to the window
function love.draw()
    push:apply('start')

    -- Clear the screen resetting it to black
    love.graphics.clear()

    -- Draw text at top center of screen
    -- Set the font
    love.graphics.setFont(smallFont)

    -- Print to screen so we can see transition between states
    if gameState == 'start' then
        love.graphics.printf('Start!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Play!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    -- Draw the 2 player paddles and ball to the screen
    player1:render()
    player2:render()
    ball:render()

     -- Draw FPS display
     displayFPS()

    push:apply('end')
end

-- Add a way to quit the game by user input
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    
    -- Functionality to start game and implement ball movement
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            ball:reset()
        end
    end
end

-- Helper function to draw FPS to screen
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('FPS: ' .. tostring(love.timer.getFPS()), 0, 5, VIRTUAL_WIDTH, 'center')
end