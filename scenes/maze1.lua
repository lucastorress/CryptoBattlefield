local composer = require( "composer" )
local scene = composer.newScene()

local tiled = require "com.ponywolf.ponytiled"
local json = require "json"

local physics = require "physics"

local mazeCreator = require ("scenes.mazeCreator")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

physics.start()
physics.setDrawMode("hybrid")

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    mazeCreator.mazeCreatorBase()

    local w = display.contentWidth
    local h = display.contentHeight

    local background = display.newImageRect( "ui/background_map.png", 400, 400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local mapData = json.decodeFile(system.pathForFile("maps/maze.json", system.ResourceDirectory))  -- load from json export
    local map = tiled.new(mapData, "maps")

    map.x,map.y = display.contentCenterX - map.designedWidth/2, display.contentCenterY - map.designedHeight/2

    local mazeShapeGroup = display.newGroup()

    -- local mazeShapeTop = display.newRect( 160, 95, 300, 10)
    -- mazeShapeGroup:insert( mazeShapeTop )
    -- local mazeShapeLeft = display.newRect( 15, 240, 10, 300)
    -- mazeShapeGroup:insert( mazeShapeLeft )
    -- local mazeShapeRight = display.newRect( 305, 240, 10, 300)
    -- mazeShapeGroup:insert( mazeShapeRight )
    -- local mazeShapeBottom = display.newRect( 150, 385, 260, 10)
    -- mazeShapeGroup:insert( mazeShapeBottom )

    local mazeShapeTop = display.newImageRect( "ui/maze_base.png", 300, 10 )
    mazeShapeTop.x = display.contentCenterX
    mazeShapeTop.y = 95
    local mazeShapeLeft = display.newImageRect( "ui/maze_base.png", 10, 300 )
    mazeShapeLeft.x = 15
    mazeShapeLeft.y = display.contentCenterY
    local mazeShapeRight = display.newImageRect( "ui/maze_base.png", 10, 300 )
    mazeShapeRight.x = 305
    mazeShapeRight.y = display.contentCenterY
    local mazeShapeBottom = display.newImageRect( "ui/maze_base.png", 300, 10 )
    mazeShapeBottom.x = display.contentCenterX
    mazeShapeBottom.y = 385
    

    myRectangle = display.newRect( 0, 0, 15, 15 )
    myRectangle:setFillColor( 0.5 )
    myRectangle.x = 30
    myRectangle.y = 110

    
    physics.addBody( mazeShapeLeft, "static", {density=1.0} )
    physics.addBody( mazeShapeRight, "static", {density=1.0} )
    physics.addBody( mazeShapeTop, "static", {density=1.0} )
    physics.addBody( mazeShapeBottom, "static", {density=1.0} )
    physics.addBody( myRectangle, "dynamic", {density=0.5} )
    myRectangle.gravityScale = 0.0

    local moveX, moveY = 0, 0
    local flag = -1

    local function touchFunction(event)
        if ( event.phase == "began" or event.phase == "moved" ) then
            -- Code executed when the button is touched
            -- print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
            -- Code executed when the touch is moved over the object
            -- print( "touch = " .. moveX .. "," .. moveY )
            stepX = event.x - event.xStart
            stepY = event.y - event.yStart
            -- print( "steps = " .. stepX .. "," .. stepY )
            if (stepX ~= 0 and stepX > 0 and flag ~= 0) then
                moveX = -0.5
                flag = 1
            elseif (stepX ~= 0 and stepX < 0 and flag ~= 0) then
                moveX = 0.5
                flag = 1
            end
            if (stepY ~= 0 and stepY > 0 and flag ~= 1) then
                moveY = -0.5
                flag = 0
            elseif (stepY ~= 0 and stepY < 0 and flag ~= 1) then
                moveY = 0.5
                flag = 0
            end
        elseif ( event.phase == "ended" ) then
            -- Code executed when the touch lifts off the object
            -- print( "touch ended on object " .. tostring(event.target) )
            moveX = 0
            moveY = 0
            flag = -1
        end
        return true  -- Prevents tap/touch propagation to underlying objects
    end

    local updateMove = function()
        myRectangle.x = myRectangle.x - moveX
        myRectangle.y = myRectangle.y - moveY
    end

    background:addEventListener( "touch", touchFunction )
    Runtime:addEventListener( "enterFrame", updateMove )
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene