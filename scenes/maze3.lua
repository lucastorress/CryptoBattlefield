local composer = require( "composer" )
local scene = composer.newScene()
composer.recycleOnSceneChange = true
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoNextPhase()
	composer.removeScene( "scenes.maze3" )
	composer.gotoScene( "scenes.maze4", { time=800, effect="crossFade" } )
end

local function gotoMenu()
    -- Stop the music!
    audio.stop( 2 )
    musicTrack = nil
	-- Dispose audio!
    audio.dispose( musicTrack )
    musicTrack = nil
	composer.removeScene( "scenes.maze3" )
	composer.gotoScene( "scenes.menu", { time=800, effect="crossFade" } )
end

local function timeIsOver()
    -- Stop the music!
    audio.stop( 2 )
    musicTrack = nil
	-- Dispose audio!
    audio.dispose( musicTrack )
    musicTrack = nil
    print("Tempo acabou.")
	composer.removeScene( "scenes.maze3" )
    composer.gotoScene( "scenes.gameOver", { time=500, effect="flipFadeOutIn" } )
end

local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

-- Load background
local gridBackground = display.newImageRect( "ui/background_maze.png", 1560, 1595 ) -- x: 260
gridBackground.x = display.contentCenterX -- 150
gridBackground.y = display.contentCenterY-50

-- We want to make the main map as big as possible, but we need to
-- have room for controls on the left side, so we'll portion out one
-- sixth (1 / 6) of the screen width for the controller.
local controllerWidth = screenWidth / 3

-- We also want to leave a bit of room on the right side so the map doesn't
-- touch the edge of the screen.
local correctionMarginControl = 30

-- Define o tempo de duração da fase
local timeDuration = 35 -- 25

-- Define a configuração do labirinto
local maze = {
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,1,0,0,0,0,0,1},
    {1,0,1,1,1,0,1,0,1,1,1,1,1,0,1},
    {1,0,0,0,1,0,1,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,0,1,0,1,1,1,1,1,0,1},
    {1,0,0,0,0,0,1,0,1,0,0,0,1,0,1},
    {1,0,1,1,1,1,1,1,1,0,1,0,1,1,1},
    {1,0,1,0,0,0,1,0,1,0,1,0,0,0,1},
    {1,0,1,0,1,0,1,0,1,0,1,1,1,0,1},
    {1,0,0,0,1,0,1,0,1,0,1,0,0,0,1},
    {1,0,1,1,1,0,1,0,1,0,1,0,1,1,1},
    {1,0,0,0,1,0,1,0,0,0,1,0,1,0,1},
    {1,1,1,0,1,0,1,1,1,1,1,0,1,0,1},
    {1,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
}
maze.rows = table.getn(maze)
maze.columns = table.getn(maze[1])
maze.xStart, maze.yStart = 4, 4
maze.xFinish, maze.yFinish = 8, 8
maze.xKey, maze.yKey = 2, 14
maze.hasKey = false

print("rows, columns:", maze.rows, maze.columns)

local timeDisplay = display.newGroup()
local gridDisplayGroup = display.newGroup()
local controlsDisplayGroup = display.newGroup()
local startButtonDisplayGroup = display.newGroup()

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    sceneGroup:insert(gridBackground)
    -- local myRoundedRect = display.newRoundedRect( 0, 0, 300, 100, 12 )
    -- myRoundedRect.strokeWidth = 3
    -- myRoundedRect:setFillColor( 0.5 )
    -- myRoundedRect:setStrokeColor( 0.8, 0, 0 )
    -- myRoundedRect.x = display.contentCenterX
    -- myRoundedRect.y = 10
    -- sceneGroup:insert(myRoundedRect)

    local bgTime = display.newImageRect(sceneGroup, "ui/bg_time.png",
                        300, 100)
    bgTime.x = display.contentCenterX
    bgTime.y = 10

    local timeText
    timeText = display.newText( sceneGroup, "Tempo: " .. timeDuration, display.contentCenterX, 10, native.systemFontBold, 36 )
    timeText:setTextColor(1, 1, 1)

    local button_menu = display.newImageRect(sceneGroup, "ui/button_menu.png",
                        355*0.60, 115*0.60)
    button_menu.x = display.contentCenterX - 300
    button_menu.y = 10

    button_menu:addEventListener( "tap", gotoMenu )

    -- Global Variable
    button_pause = display.newImageRect(sceneGroup, "ui/button_pause.png",
                        355*0.60, 115*0.60)
    button_pause.x = display.contentCenterX + 300
    button_pause.y = 10

    -- ### Build the map grid.
    local grid = {}

    grid.xSquares = maze.columns
    grid.ySquares = maze.rows

    grid.totalWidth = screenWidth

    grid.squareSize = grid.totalWidth / grid.xSquares

    grid.xStart = display.contentCenterX/11

    grid.yStart = 150

    grid.displayGroup = gridDisplayGroup

    -- The map is going to be shown on screen with its (0, 0) being the
    -- (xStart, yStart) of the total screen.
    grid.displayGroup.x = grid.xStart
    grid.displayGroup.y = grid.yStart

    -- ### Grid functions

    -- These functions will be placed on our grid squares. They'll help us find
    -- adjacent squares when we need them.
    grid.functions = {
        left = function(gridSquare)
            if gridSquare.x == 0 then
                return gridSquare
            else
                return grid[gridSquare.y][gridSquare.x - 1]
            end
        end,

        right = function(gridSquare)
            if gridSquare.x + 1 == grid.xSquares then
                return gridSquare
            else
                return grid[gridSquare.y][gridSquare.x + 1]
            end
        end,

        above = function(gridSquare)
            if gridSquare.y == 0 then
                return gridSquare
            else
                return grid[gridSquare.y - 1][gridSquare.x]
            end
        end,

        below = function(gridSquare)
            if gridSquare.y + 1 == grid.ySquares then
                return gridSquare
            else
                return grid[gridSquare.y + 1][gridSquare.x]
            end
        end,
    }
    -- ## Setting up the map grid.

    -- In order to set up a grid, we'll loops to avoid repeating out similar code
    -- for each of the grid squares. Because we have *x* coordinates and *y*
    -- coordinates we'll use nested loops. One within another. This means that
    -- each time we change the *y* coordinate we'll go through a whole column of
    -- *x* values, then start a new row.

    -- We'll start with rows this time around. Previously we started with *x*
    -- values in the outer loop but because it's easier to write lists in rows
    -- than in columns, we've switched it here so it will line up with our maze
    -- better.
    for y = 0, grid.ySquares - 1 do
        -- The first thing we do is create a row for this coordinate. We use `[]`
        -- to "index" the column with its coordinate and set the x field for this
        -- column to be the *x* coordinate value.
        grid[y] = {y = y}

        -- Now we go column by column and set up the grid.
        for x = 0, grid.xSquares - 1 do

            -- For each grid square, we'll set it up to be indexed first by
            -- its *x* coordinate and next by its *y* coordinate. We also
            -- set the x and y fields of the square to match its coordinates.
            grid[y][x] = {x = x, y = y}

            local rect = display.newRect(grid.displayGroup,
            grid.squareSize * x, grid.squareSize * y,
            grid.squareSize, grid.squareSize)

            -- Here we'll add in the maze elements to our grid. Because the maze uses
            -- a list that begins with 1, where we started at 0, we add 1 to the *x*
            -- and *y* values to get the correct maze square.
            if maze[y + 1][x + 1] == 0 then
                rect:setFillColor(0, 0, 0) -- Cor dos caminhos
            else 
                grid[y][x].wall = true
                rect:setFillColor(0.3, 0.61, 1, 0.95) -- Cor das paredes
            end

            -- Now that we've created our display object, we attach it to our
            -- grid square.
            grid[y][x].displayObject = rect

            -- And finally we attach the functions we wrote earlier to each
            -- square so it is more convient to call on them later.
            grid[y][x].left = grid.functions.left
            grid[y][x].right = grid.functions.right
            grid[y][x].above = grid.functions.above
            grid[y][x].below = grid.functions.below

            -- The end of one row.
        end
        -- The end of one column.
    end

    grid[maze.yStart - 1][maze.xStart - 1].displayObject:setFillColor(0.92, 0.91, 0.51, 1) -- Cor da célula inicial do jogador
    grid[maze.yFinish - 1][maze.xFinish - 1].displayObject:setFillColor(0.71, 0, 0.37, 1) -- Cor da célula de chegada do jogador (cadeado/padlock)
    grid[maze.yKey - 1][maze.xKey - 1].displayObject:setFillColor(0) -- Cor da célula onde fica a chave
    grid[maze.yStart - 1][maze.xStart - 1].start = true
    grid[maze.yFinish - 1][maze.xFinish - 1].finish = true
    grid[maze.yKey - 1][maze.xKey - 1].keyposition = true

    -- Key do jogo
    local key = { image = "ui/key.png" }

    function key:positionKey(gridSquare)
        if self.displayObject == nil then
            self.displayObject = display.newImageRect(grid.displayGroup,
            self.image, grid.squareSize*1, grid.squareSize*1)
        end

        self.displayObject.x = gridSquare.displayObject.x
        self.displayObject.y = gridSquare.displayObject.y
    end

    -- Final do jogo
    local padlock = {
        image = "ui/padlock_close.png",
        image_open = "ui/padlock_open.png"
    }

    function padlock:finishLine(gridSquare)
        if self.displayObject == nil then
            self.displayObject = display.newImageRect(grid.displayGroup,
            self.image, grid.squareSize*1, grid.squareSize*1)
        end

        self.displayObject.x = gridSquare.displayObject.x
        self.displayObject.y = gridSquare.displayObject.y
    end

    function padlock:openPadlock(gridSquare)
        if self.displayObject ~= nil and not maze.hasKey then
            print("openPadlock", maze.hasKey)
            maze.hasKey = true
            self.displayObject = nil
            self.displayObject = display.newRect(grid.displayGroup,
            grid.squareSize * (maze.xFinish - 1), grid.squareSize * (maze.yFinish - 1),
            grid.squareSize, grid.squareSize)
            self.displayObject:setFillColor(0, 1, 0)
            self.displayObject = display.newImageRect(grid.displayGroup,
            self.image_open, grid.squareSize*1, grid.squareSize*1)

            key.displayObject.isVisible = false

            -- local keyGrid = grid[maze.yKey - 1][maze.xKey - 1]
            -- keyGrid.displayObject:setFillColor(0.71, 0, 0.37, 1)
            -- grid[maze.yKey - 1][maze.xKey - 1] = keyGrid
        end

        self.displayObject.x = gridSquare.displayObject.x
        self.displayObject.y = gridSquare.displayObject.y
    end

    --## Create the runner

    -- Now we'll create a runner.
    local runner = { image = "ui/mouse.png" }

    -- We need a function to allow the runner to move to a particular square.
    function runner:enter(gridSquare)
        -- The first time we show the character, there won't be a display object,
        -- so we'll have to create one.
        if self.displayObject == nil then
            self.displayObject = display.newImageRect(grid.displayGroup,
            self.image, grid.squareSize*1, grid.squareSize*1)
            self.displayObject:setFillColor(92, 92, 92)
        end

        -- Now our self's display object should be in the same position on
        -- the screen as the grid square that self is in.
        self.displayObject.x = gridSquare.displayObject.x
        self.displayObject.y = gridSquare.displayObject.y

        -- We'll keep track of the grid square each self is in. It will come
        -- in handy when they want to move.
        self.gridSquare = gridSquare

        -- we'll also save the *x* and *y* coordinate of the self just like
        -- the grid square.
        self.x = gridSquare.x
        self.y = gridSquare.y

        if self.gridSquare.finish and maze.hasKey then
            finish()
        elseif self.gridSquare.keyposition then
            padlock:openPadlock(grid[maze.yFinish - 1][maze.xFinish - 1])
        end
    end

    -- The runner can only enter squares that don't have obstacles. Even though
    -- all this method does is check for the presence of an obstacle, we'll do
    -- it like this because it controls the actions of the runner.
    function runner:canEnter(gridSquare)
        return gridSquare.wall == nil
    end

    --##  Creating the controls.
    local controlCenterX = display.contentCenterX

    -- Posição Y do controle na tela
    local controlCenterY = screenHeight - screenHeight / 8
    
    local controlCenterRadius = controllerWidth / 2 -- correctionMarginControl

    -- The size of our control buttons. The up and down
    local upDownWidth = 67
    local upDownHeight = 150

    -- The size of the left and right control buttons.
    local leftRightWidth = 150
    local leftRightHeight = 67

    -- Container tables for the controls.
    local controls = {
        up    = {},
        down  = {},
        right = {},
        left  = {},
    }

    -- Create a display group for the control pad.
    controls.displayGroup = controlsDisplayGroup

    -- Now create a circle to house our directional pad.
    local circlePad = display.newCircle(controls.displayGroup,
        controlCenterX, controlCenterY, controlCenterRadius)
    -- Let's make it stand out from the background.
    circlePad:setFillColor(0.15, 0.53, 0.55, 1)

    local up = display.newImageRect(controls.displayGroup, "ui/controls/arrow_up.png",
        upDownWidth, upDownHeight)
    up.x = controlCenterX
    up.y = controlCenterY - upDownHeight / 2
    controls.up.displayObject = up

    local down = display.newImageRect(controls.displayGroup, "ui/controls/arrow_down.png",
    upDownWidth, upDownHeight)
    down.x = controlCenterX
    down.y = controlCenterY + upDownHeight / 2
    controls.down.displayObject = down

    local right = display.newImageRect(controls.displayGroup, "ui/controls/arrow_right.png",
        leftRightWidth, leftRightHeight)
    right.x = controlCenterX + leftRightWidth / 2
    right.y = controlCenterY
    controls.right.displayObject = right

    local left = display.newImageRect(controls.displayGroup, "ui/controls/arrow_left.png",
        leftRightWidth, leftRightHeight)
    left.x = controlCenterX - leftRightWidth / 2
    left.y = controlCenterY
    controls.left.displayObject = left

    -- We'll create a function to hide the controls so that at the end of the game
    -- the player can't take the runner *out* of the finish area.
    controls.hide = function(controls)
        controls.displayGroup.isVisible = false
    end

    -- We also need to create a show function so we can get the controls back at the
    -- start of the game.
    controls.show = function(controls)
        controls.displayGroup.isVisible = true
    end

    --## Make the runner move

    -- This function will run when we press the left arrow.
    local function pressLeft(event)
        if event.phase == "began" then
            local nextSquare = runner.gridSquare:left()
            if runner:canEnter(nextSquare) then
                runner:enter(nextSquare)
            end
        end
    end

    -- This function will run when we press the right arrow.
    local function pressRight(event)
        if event.phase == "began" then
            local nextSquare  = runner.gridSquare:right()
            if runner:canEnter(nextSquare) then
                runner:enter(nextSquare)
            end
        end
    end

    -- This function will run when we press the up arrow.
    local function pressUp(event)
        if event.phase == "began" then
            local nextSquare  = runner.gridSquare:above()
            if runner:canEnter(nextSquare) then
                runner:enter(nextSquare)
            end
        end
    end

    -- This function will run when we press the down arrow.
    local function pressDown(event)
        if event.phase == "began" then
            local nextSquare  = runner.gridSquare:below()
            if runner:canEnter(nextSquare) then
                runner:enter(nextSquare)
            end
        end
    end

    -- Now we register each function as an event listener for the touch
    -- event on the display object associated with each arrow.
    controls.left.displayObject:addEventListener("touch", pressLeft)
    controls.right.displayObject:addEventListener("touch", pressRight)
    controls.up.displayObject:addEventListener("touch", pressUp)
    controls.down.displayObject:addEventListener("touch", pressDown)

    -- Create the Start button

    local startButton = {}
    startButton.displayGroup = startButtonDisplayGroup
    startButton.displayObject = display.newCircle(startButton.displayGroup,
        controlCenterX, controlCenterY, controlCenterRadius)

    -- We'll give the button some color and accent.
    startButton.displayObject.strokeWidth = 6
    startButton.displayObject:setStrokeColor(244, 244, 64)

    -- Write what the button does.
    startButton.text = display.newText(startButton.displayGroup, 
        "Start", controlCenterX - controlCenterRadius + 20, controlCenterY - 18,
        native.systemFont, 24)
    -- Make the text black
    startButton.text:setTextColor(0, 0, 0)

    -- This function will run whenever you hit the start button. It will
    -- hide the button from view and then start the game.
    startButton.touch = function(event)
        if event.phase == "began" then
            startButton:hide()
            start()
        end
    end
    startButton.displayGroup:addEventListener("touch", startButton.touch)

    startButton.show = function(button)
        button.displayGroup.isVisible = true
    end

    startButton.hide = function(button)
        button.displayGroup.isVisible = false
    end

    function startCountTime(event)
        if timeDuration > 0 then
            timeDuration = timeDuration - 1
            timeText.text = "Tempo: " .. timeDuration
        else
            print('Fim do tempo:', timeDuration)
            timeIsOver(grid)
        end
        if timeDuration <= 10 then
            timeText:setTextColor(1, 1, 0)
        end
    end

    function play()

        -- The runner starts off in the maze start.
        padlock:finishLine(grid[maze.yFinish - 1][maze.xFinish - 1])
        key:positionKey(grid[maze.yKey - 1][maze.xKey - 1])
        runner:enter(grid[maze.yStart - 1][maze.xStart - 1])

        -- The controls start out hidden because we want the player to call "start"
        -- first.
        controls:show()

        startButton:hide()
    end

    -- ## Start the game

    -- The start function hides teh start button and shows the controls. This
    -- allows the player to start moving the runner.
    function start()
        controls:show()
    end

    --## Finish!

    -- Finish the game by hiding the controls and displaying the play again button.
    function finish()
        controls:hide()
        gotoNextPhase()
    end

    -- Play the game!
    play()

 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        sceneGroup:insert(timeDisplay)
        sceneGroup:insert(gridDisplayGroup)
        sceneGroup:insert(controlsDisplayGroup)
        sceneGroup:insert(startButtonDisplayGroup)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- print('Entrei aqui')
        timerIsOver = timer.performWithDelay(1000, startCountTime, timeDuration+1)
        paused = false

        function gotoPause()
            -- composer.showOverlay( "pause", options )
            if paused then
                local resumeTime = timer.resume( timerIsOver )
                print( "Resume time is " .. resumeTime )
                controlsDisplayGroup.isVisible = true
                paused = false
                -- print(paused)
                audio.resume( musicTrack )
            else
                local pauseTime = timer.pause( timerIsOver )
                print( "Time remaining is " .. pauseTime )
                controlsDisplayGroup.isVisible = false
                paused = true
                -- print(paused)
                audio.pause( musicTrack )
            end
        end

        button_pause:addEventListener( "tap", gotoPause )
 
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
    -- print("Timer cancel")
    timer.cancel(timerIsOver)
 
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