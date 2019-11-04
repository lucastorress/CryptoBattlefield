-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )

-- Reserve channel 1 for background music
audio.reserveChannels( 3 )
-- Reduce the overall volume of the channel
audio.setVolume( 0.75, { channel=1 } )
audio.setVolume( 0.5, { channel=2 } )
audio.setVolume( 1, { channel=3 } )

composer.gotoScene( "scenes.menu" )