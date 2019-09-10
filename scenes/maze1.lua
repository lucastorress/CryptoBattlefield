local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    print("Pixel Width:", display.pixelWidth)
    print("Pixel Height:", display.pixelHeight)
    print("View Width:", display.viewableContentWidth)
    print("View Height:", display.viewableContentHeight)
    print("content CenterX:", display.contentCenterX)
    print("content CenterY:", display.contentCenterY)

    local tiled = require "com.ponywolf.ponytiled"
    local physics = require "physics"
    local json = require "json"

    physics.setDrawMode("hybrid")

    local w = display.contentWidth
    local h = display.contentHeight

    local background = display.newImageRect( "", 320, 480 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local mapData = json.decodeFile(system.pathForFile("maps/maze.json", system.ResourceDirectory))  -- load from json export
    local map = tiled.new(mapData, "maps")

    map.x,map.y = display.contentCenterX - map.designedWidth/2, display.contentCenterY - map.designedHeight/2

    myRectangle = display.newRect( 0, 0, 15, 15 )
    myRectangle:setFillColor( 0.5 )
    myRectangle.x = 30
    myRectangle.y = 110

    physics.start()
    physics.addBody( map, "static", {density=1.0} )
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