
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables

local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

local function gotoGame()
	composer.removeScene( "scenes.menu" )
	composer.gotoScene( "scenes.maze1", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    local background = display.newImageRect( sceneGroup, "ui/kitchen_bg.png", screenWidth*1.1, screenHeight*1.1 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY-55

	local title = display.newImageRect( sceneGroup, "ui/logo2.png", 427*2, 135*2 )
	title.x = display.contentCenterX
	title.y = 200

    local playButton = display.newImageRect( sceneGroup, "ui/button_play_new.png", 596, 115 )
    playButton.x = display.contentCenterX
    playButton.y = 700
	

	playButton:addEventListener( "tap", gotoGame )
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
