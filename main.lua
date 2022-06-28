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
   
    -- Initialise score variables
    player1Score = 0
    player2Score = 0

    -- Initialise serving player
    servingPlayer = 1

    -- Initialise winning player
    winningPlayer = 0

    -- Add a title to the window for more polish
    love.window.setTitle('Pong')

    -- Seed the random number generator using current time
    math.randomseed(os.time())

    -- Set the texture filtering so there is no blurring effect on fonts or textures
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- create fonts and set sizes
    smallFont = love.graphics.newFont('consola.ttf', 16)
    scoreFont = love.graphics.newFont('consola.ttf', 32)
    largeFont = love.graphics.newFont('consola.ttf', 64)
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
    -- Before beginning the play state, initialise the ball velocity depending on what
    -- player scored last
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
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

        -- If the ball reaches the left or right edge reset the ball and add 1 to
        -- score
        if ball.x < 0 then
            player2Score = player2Score + 1
            servingPlayer = 1

            -- Check to see if the score limit has been reached
            -- If it has enter the 'done' game state
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            player1Score = player1Score + 1
            servingPlayer = 2
            -- Check to see if the score limit has been reached
            -- If it has enter the 'done' game state
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
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

    displayScore()

    -- Print to screen so we can see transition between states
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Pong', 0, 10, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI is to be displayed in play mode
    elseif gameState == 'done' then
        love.graphics.clear()
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
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
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif
            gameState == 'done' then
                gameState = 'start'
            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                winningPlayer = 1
            end
        end
    end
end

-- Helper function to draw FPS to screen
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('FPS: ' .. tostring(love.timer.getFPS()), 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center')
end

-- Draw the current socre to the screen
function displayScore()
    -- Draw the score on the left and right centre of the screen
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end    