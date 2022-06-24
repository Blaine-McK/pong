--[[ This class represents a ball which can bounce off the player paddles.
it moves horizontally across the screen. If it passes the left or right edge of
screen, a point will be scored.
]]

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.height = height
    self.width = width

    -- The velocity of the ball on both the x and y axis
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end

-- Collision detection, takes a paddle as an argument and will
-- return true or false depending if the pall is overlapping the paddle
function Ball:Collides(paddle)

    -- Check to see if the left edge of either is further right than the edge of
    -- the other
    if self.x < paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- Now check if the bottom edge of either is higher than the top edge of
    -- the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false        
    end

    -- If both are false, we know they are over lapping
    return true
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end