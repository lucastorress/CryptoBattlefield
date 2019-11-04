
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
local musicTrack

local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

local function gotoGame()
	-- audio.fadeOut( { channel=1, time=5000 } )
	-- Stop the music!
	audio.stop( 1 )
	musicTrack = nil
	-- Dispose audio!
	audio.dispose( musicTrack )
	musicTrack = nil
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

    local background = display.newImageRect( sceneGroup, "ui/kitchen_bg.png", screenWidth*1.5, screenHeight*2 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY-55

	local title = display.newImageRect( sceneGroup, "ui/logo2.png", screenHeight*3.16*0.2, screenHeight*0.2 )
	title.x = display.contentCenterX
	title.y = screenHeight*0.1

    local playButton = display.newImageRect( sceneGroup, "ui/button_play_new2.png", screenHeight*5*0.1, screenHeight*0.1 )
    playButton.x = display.contentCenterX
    playButton.y = screenHeight*0.5
	
	musicTrack = audio.loadStream( "ui/audio/intro_Wolf_Kisses.mp3")

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
		-- Start the music!
		audio.play( musicTrack, { channel=1, loops=-1, fadein = 1500 } )
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
	-- Dispose audio!
	audio.dispose( musicTrack )
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
