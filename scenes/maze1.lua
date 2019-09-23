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

    local background = display.newRect( 0, 0, w, h )
    background:setFillColor( 0.8 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local mapData = json.decodeFile(system.pathForFile("maps/maze.json", system.ResourceDirectory))  -- load from json export
    local map = tiled.new(mapData, "maps")

    map.x,map.y = display.contentCenterX - map.designedWidth/2, display.contentCenterY - map.designedHeight/2

    -- Cria as paredes base do labirinto
    local mazeShapeBaseWallGroup = display.newGroup()
    local mazeShapeTop = display.newImageRect( "ui/maze_base.png", 300, 10 )
    mazeShapeTop.x = display.contentCenterX
    mazeShapeTop.y = 95
    mazeShapeBaseWallGroup:insert( mazeShapeTop )
    local mazeShapeLeft = display.newImageRect( "ui/maze_base.png", 10, 300 )
    mazeShapeLeft.x = 15
    mazeShapeLeft.y = display.contentCenterY
    mazeShapeBaseWallGroup:insert( mazeShapeLeft )
    local mazeShapeRight = display.newImageRect( "ui/maze_base.png", 10, 300 )
    mazeShapeRight.x = 305
    mazeShapeRight.y = display.contentCenterY
    mazeShapeBaseWallGroup:insert( mazeShapeRight )
    local mazeShapeBottom = display.newImageRect( "ui/maze_base.png", 300, 10 ) -- x: 260
    mazeShapeBottom.x = display.contentCenterX -- 150
    mazeShapeBottom.y = 385
    mazeShapeBaseWallGroup:insert( mazeShapeBottom )
    -- Adiciona física as paredes base do labirinto
    physics.addBody( mazeShapeLeft, "static", {density=1.0} )
    physics.addBody( mazeShapeRight, "static", {density=1.0} )
    physics.addBody( mazeShapeTop, "static", {density=1.0} )
    physics.addBody( mazeShapeBottom, "static", {density=1.0} )
    
    -- Cria as paredes verticais de obstáculo do labirinto
    local mazeShapeHardWallGroup = display.newGroup()
    local mVertical1 = display.newImageRect( "ui/maze_base.png", 10, 70 )
    mVertical1.x, mVertical1.y = 75, 125
    physics.addBody( mVertical1, "static", {density=1.0} )
    local mVertical2 = display.newImageRect( "ui/maze_base.png", 10, 40 )
    mVertical2.x, mVertical2.y = 195, 110
    physics.addBody( mVertical2, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical2 )
    local mVertical3 = display.newImageRect( "ui/maze_base.png", 10, 40 )
    mVertical3.x, mVertical3.y = 245, 110
    physics.addBody( mVertical3, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical3 )
    local mVertical4 = display.newImageRect( "ui/maze_base.png", 10, 40 )
    mVertical4.x, mVertical4.y = 45, 170
    physics.addBody( mVertical4, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical4 )
    local mVertical5 = display.newImageRect( "ui/maze_base.png", 10, 70 )
    mVertical5.x, mVertical5.y = 165, 155
    physics.addBody( mVertical5, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical5 )
    local mVertical6 = display.newImageRect( "ui/maze_base.png", 10, 70 )
    mVertical6.x, mVertical6.y = 275, 155
    physics.addBody( mVertical6, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical6 )
    local mVertical7 = display.newImageRect( "ui/maze_base.png", 10, 40 )
    mVertical7.x, mVertical7.y = 75, 230
    physics.addBody( mVertical7, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical7 )
    local mVertical8 = display.newImageRect( "ui/maze_base.png", 10, 100 )
    mVertical8.x, mVertical8.y = 105, 230
    physics.addBody( mVertical8, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical8 )
    local mVertical9 = display.newImageRect( "ui/maze_base.png", 10, 70 )
    mVertical9.x, mVertical9.y = 195, 185
    physics.addBody( mVertical9, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical9 )
    local mVertical10 = display.newImageRect( "ui/maze_base.png", 10, 20 )
    mVertical10.x, mVertical10.y = 225, 220
    physics.addBody( mVertical10, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical10 )
    local mVertical11 = display.newImageRect( "ui/maze_base.png", 10, 30 )
    mVertical11.x, mVertical11.y = 245, 235
    physics.addBody( mVertical11, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical11 )
    local mVertical12 = display.newImageRect( "ui/maze_base.png", 10, 40 )
    mVertical12.x, mVertical12.y = 275, 230
    physics.addBody( mVertical12, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical12 )
    local mVertical13 = display.newImageRect( "ui/maze_base.png", 10, 40 )
    mVertical13.x, mVertical13.y = 75, 290
    physics.addBody( mVertical13, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical13 )
    local mVertical14 = display.newImageRect( "ui/maze_base.png", 10, 40 )
    mVertical14.x, mVertical14.y = 145, 290
    physics.addBody( mVertical14, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical14 )
    local mVertical15 = display.newImageRect( "ui/maze_base.png", 10, 40 )
    mVertical15.x, mVertical15.y = 185, 260
    physics.addBody( mVertical15, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical15 )
    local mVertical16 = display.newImageRect( "ui/maze_base.png", 10, 20 )
    mVertical16.x, mVertical16.y = 195, 250
    physics.addBody( mVertical16, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical16 )
    local mVertical17 = display.newImageRect( "ui/maze_base.png", 10, 30 )
    mVertical17.x, mVertical17.y = 215, 265
    physics.addBody( mVertical17, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical17 )
    local mVertical18 = display.newImageRect( "ui/maze_base.png", 10, 60 )
    mVertical18.x, mVertical18.y = 275, 300
    physics.addBody( mVertical18, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical18 )
    local mVertical19 = display.newImageRect( "ui/maze_base.png", 10, 30 )
    mVertical19.x, mVertical19.y = 45, 345
    physics.addBody( mVertical19, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical19 )
    local mVertical20 = display.newImageRect( "ui/maze_base.png", 10, 30 )
    mVertical20.x, mVertical20.y = 75, 375
    physics.addBody( mVertical20, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical20 )
    local mVertical21 = display.newImageRect( "ui/maze_base.png", 10, 30 )
    mVertical21.x, mVertical21.y = 115, 345
    physics.addBody( mVertical21, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical21 )
    local mVertical22 = display.newImageRect( "ui/maze_base.png", 10, 90 )
    mVertical22.x, mVertical22.y = 185, 345
    physics.addBody( mVertical22, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical22 )
    local mVertical23 = display.newImageRect( "ui/maze_base.png", 10, 30 )
    mVertical23.x, mVertical23.y = 215, 345
    physics.addBody( mVertical23, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical23 )
    local mVertical24 = display.newImageRect( "ui/maze_base.png", 10, 30 )
    mVertical24.x, mVertical24.y = 245, 345
    physics.addBody( mVertical24, "static", {density=1.0} )
    mazeShapeHardWallGroup:insert( mVertical24 )

    -- Cria o Mr. Square
    myRectangle = display.newRect( 0, 0, 15, 15 )
    myRectangle:setFillColor( 0.5 )
    myRectangle.x = 30
    myRectangle.y = 110
    physics.addBody( myRectangle, "dynamic", {density=1.0} )
    myRectangle.gravityScale = 0.0

    local moveX, moveY = 0, 0
    local flag = -1

    local function touchFunction(event)
        if ( event.phase == "began" or event.phase == "moved" ) then
            -- Code executed when the button is touched
            -- Code executed when the touch is moved over the object
            stepX = event.x - event.xStart
            stepY = event.y - event.yStart
            -- print( "steps = " .. stepX .. "," .. stepY )
            if (stepX ~= 0 and stepX > 0 and flag ~= 0) then
                moveX = -1
                flag = 1
            elseif (stepX ~= 0 and stepX < 0 and flag ~= 0) then
                moveX = 1
                flag = 1
            end
            if (stepY ~= 0 and stepY > 0 and flag ~= 1) then
                moveY = -1
                flag = 0
            elseif (stepY ~= 0 and stepY < 0 and flag ~= 1) then
                moveY = 1
                flag = 0
            end
        elseif ( event.phase == "ended" ) then
            -- Code executed when the touch lifts off the object
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