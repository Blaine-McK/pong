-- Import the 'push' library
push = require 'push'

-- Import the 'class' library, this will allow us to
-- represent anything in the game as code instead of keeping track of many
-- variables and methods
Class = require 'class'

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
   
    -- Seed the random number generator using current time
    math.randomseed(os.time())

    -- Set player starting scores
    player1Score = 0
    player2Score = 0

    -- Declare varibales to track paddle y pos and set starting y co-ordinates of th paddles
    player1Y = VIRTUAL_HEIGHT / 2
    player2Y = VIRTUAL_HEIGHT / 2

    -- Set the texture filtering so there is no blurring effect on fonts or textures
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- create fonts and set sizes
    smallFont = love.graphics.newFont('consola.ttf', 16)
    scoreFont = love.graphics.newFont('consola.ttf', 32)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Store ball position
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    -- Store ball velocity
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    -- Rudimentary state machine
    gameState = 'start'

end

-- Draw text to the window
function love.draw()
    push:apply('start')

    -- Clear the screen resetting it to black
    love.graphics.clear()

    -- Draw text at top center of screen
    -- Set the font
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    -- Draw player scores
    -- Set the font
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 50, VIRTUAL_HEIGHT / 3)

    -- Print to screen so we can see transition between states
    if gameState == 'start' then
        love.graphics.printf('Start!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Play!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    -- Draw the 2 player paddles and ball to the screen
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    push:apply('end')
end

-- Add interactivity through the update method
function love.update(dt)
    
    -- Player1 movement
    if love.keyboard.isDown('w') then
        player1Y = player1Y - (PADDLE_SPEED * dt)
        -- Prevent player1 from going off top of screen
        player1Y = math.max(0, player1Y)
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + (PADDLE_SPEED * dt)
        -- Prevent player1 from going off bottom of screen
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y)
    end

    -- Player2 movement
    if love.keyboard.isDown('up') then
        player2Y = player2Y - (PADDLE_SPEED * dt)
        -- Prevent player2 from going off top of screen
        player2Y = math.max(0, player2Y)
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + (PADDLE_SPEED * dt)
        -- Prevent player2 from going off bottom of screen
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y)
    end

    -- Ensure ball can only move in the 'play' state
    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        bally = ballY + ballDY * dt
    end

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

            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end