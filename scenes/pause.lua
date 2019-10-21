
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables

local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

local function backtoGame()
    -- By some method such as a "resume" button, hide the overlay
    composer.hideOverlay( "fade", 400 )
	-- composer.removeScene( "scenes.gameOver" )
	-- composer.gotoScene( "scenes.menu", { time=500, effect="fade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    local background = display.newImageRect( sceneGroup, "ui/background_gameover.png", screenWidth, screenHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY-50

    local playAgainButton = display.newImageRect( sceneGroup, "ui/button_play_again.png", 500, 80 )
    playAgainButton.x = display.contentCenterX
    playAgainButton.y = display.contentCenterY+400
	

	playAgainButton:addEventListener( "tap", backtoGame )
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
    local parent = event.parent  -- Reference to the parent scene object
 
    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        parent:resumeGame()
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
