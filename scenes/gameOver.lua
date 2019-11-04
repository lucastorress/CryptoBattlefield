
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables

local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

local screenCenterX = display.contentCenterX
local screenCenterY = display.contentCenterY

local musicTrack

local function gotoGame()
	-- Stop the music!
    audio.stop( 3 )
    musicTrack = nil
	-- Dispose audio!
    audio.dispose( musicTrack )
    musicTrack = nil
	composer.removeScene( "scenes.gameOver" )
	composer.gotoScene( "scenes.menu", { time=500, effect="fade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	audio.stop( 2 )
	musicTrack = audio.loadStream( "ui/audio/SynthOrgan_Game_Over.mp3")
	audio.play( musicTrack, { channel=3, loops=0 } )

    local background = display.newImageRect( sceneGroup, "ui/background_gameover.png", screenWidth*1.1, screenHeight*1.1 )
	background.x = screenCenterX
	background.y = screenCenterY

    local playAgainButton = display.newImageRect( sceneGroup, "ui/button_play_again_new.png", screenHeight*5.17*0.1, screenHeight*0.1 )
    playAgainButton.x = screenCenterX
    playAgainButton.y = screenCenterY*1.75
	

	playAgainButton:addEventListener( "tap", gotoGame )
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
		-- Stop the music!
		audio.stop( 3 )
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
