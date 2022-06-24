-- This object represents a paddle that can move up and down
-- Used in main.lua to redirect the ball in the direction it came from

Paddle = Class{}

--[[ 
    The init function is much like a constrcutor in Java. It is called once,
    when the object is first created.

    'self' is a reference to this object specifically. The object instanstantiated at the time
    the init function is called. Different objects can have their own
    values for x, y etc. Similar to structs in C
]]

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    -- math.max is used to ensure that we used the larger value of either 0
    -- or the players current calculated Y position when pressing up.
    -- This is to prevent going below 0. The calculation is out previously
    -- defined paddle speed scaled by dt
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    -- We use math.min to ensure that we don't go further than the bottom of
    -- screen minus the paddle's height.
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

--[[
    To be called by the love.draw function in main.lua. Uses LOVE2D'S 'rectangle'
    function, which takes a draw mode, and the position and dimensions of the shape.
    To change the colour, love.graphics.setColor must be called.
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
