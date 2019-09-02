-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
print("Pixel Width:", display.pixelWidth)
print("Pixel Height:", display.pixelHeight)
print("View Width:", display.viewableContentWidth)
print("View Height:", display.viewableContentHeight)
print("content CenterX:", display.contentCenterX)
print("content CenterY:", display.contentCenterY)

local w = display.contentWidth
local h = display.contentHeight

local background = display.newImageRect( "ui/maze1.png", 320, 480 )
background.x = display.contentCenterX
background.y = display.contentCenterY

myRectangle = display.newRect( 0, 0, 39, 39 )
myRectangle:setFillColor( 0.5 )
myRectangle.x = 134
myRectangle.y = 106

-- topoLeft, baseLeft, topoRight, baseRight
local maze = display.newLine( 5, 4, 5, 475 )
-- maze:append(315, 475 )
-- maze:append( 105, 170, 162, 170 )
-- maze:append( 162, 126 )
maze:setStrokeColor( 1, 0, 0, 1 )
maze.strokeWidth = 1

local moveX, moveY = 0, 0

local function touchFunction(event)
    if ( event.phase == "began" or event.phase == "moved" ) then
        -- Code executed when the button is touched
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
        -- Code executed when the touch is moved over the object
        print( "touch = " .. moveX .. "," .. moveY )
        stepX = event.x - event.xStart
        stepY = event.y - event.yStart
        print( "steps = " .. stepX .. "," .. stepY )
        if (stepX ~= 0 and stepX > 0) then
            moveX = -2
        elseif (stepX ~= 0 and stepX < 0) then
            moveX = 2
        end
        if (stepY ~= 0 and stepY > 0) then
            moveY = -2
        elseif (stepY ~= 0 and stepY < 0) then
            moveY = 2
        end
    elseif ( event.phase == "ended" ) then
        -- Code executed when the touch lifts off the object
        print( "touch ended on object " .. tostring(event.target) )
        moveX = 0
        moveY = 0
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end

local updateMove = function()
    myRectangle.x = myRectangle.x - moveX
    myRectangle.y = myRectangle.y - moveY
end

background:addEventListener( "touch", touchFunction )
Runtime:addEventListener( "enterFrame", updateMove )