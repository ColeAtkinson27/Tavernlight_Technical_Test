-- Using the Spelllist module as a base, as well as the module tutorial on the OTClient
-- GitHub, I had managed to figure out how the module system works and how to get a
-- basic window to pop up with just a "Jump!" button on it.

-- The last step that I was unable to complete was to move the button across the screen continuously.
-- Originally I had thought to use the addEvent function, but I encountered a problem where the function
-- would not wait for the length of time specified before moving the button. Despite repeated attempts
-- to diagnose why this was occurring, I was unable to find a source of the issue. The event was being
-- created, as verified by checking if the event variable was null, but no matter the length of time
-- set in milliseconds, the event would call its function right away.


jumpWindow = nil
jumpToggleButton = nil
movingButton = nil

movingEvent = nil
marginSize = 0
randomY = 0

function online()
    jumpButton:show()
end

function offline()
    resetWindow()
end

function init()
    connect(g_game, { onGameStart = online,
                      onGameEnd   = offline })

    jumpWindow = g_ui.displayUI('jump_window.otui')
    jumpWindow:hide()

    jumpToggleButton = modules.client_topmenu.addRightGameToggleButton('jumpButton', tr('Jumping'), '/images/topbuttons/spelllist', toggle)
    jumpToggleButton:setOn(false)
  
    movingButton = jumpWindow:recursiveGetChildById('movingButton')
end

function terminate()
    disconnect(g_game, { onGameStart = online,
                         onGameEnd   = offline })

    jumpWindow:destroy()
    jumpToggleButton:destroy()
    movingButton:destroy()
end

function moveButtonToLeft()
    g_logger.info('inside moveButtonToLeft')
    -- Margin is top right bottom left
    -- After trying to use the setPosition function, the actual output was that the button would
    -- always either stay in place or jump to the top left of the screen. Thinking around the problem,
    -- adjusting the margins of the button allowed me to move it within the window.
    if movingButton then
        marginSize = marginSize + 10
        movingButton:setMargin(randomY, marginSize, 0, 0)
        maxSize = jumpWindow:getWidth() - (2 * movingButton:getWidth())
        if marginSize > maxSize then
            returnButtonToRight()
        end
        -- One of these should be uncommented in order to get the event to continuously loop, but
        --   in order to show in the video that this function does push the button towards the left
        --   side, and since the addEvent function is not working correctly, they have been disabled.
        -- movingEvent = addEvent(moveButtonToLeft, 10000)
        -- movingEvent = addEvent(function() moveButtonToLeft() end, 10000)
        -- movingEvent = g_dispatcher.addEvent(function() moveButtonToLeft() end, 10000)
        -- movingEvent = g_dispatcher.addEvent(moveButtonToLeft(), 10000)
    end
end

function returnButtonToRight()
    -- Reset the right margin variable back to 0 to move the button back to the right side of the window.
    -- Then set a random margin to move the button along the Y axis.
    marginSize = 0

    windowHeight = jumpWindow:getHeight()
    buttonHeight = (3 * movingButton:getHeight())
    yMaxHeight = windowHeight - buttonHeight
    
    local seed = os.time()
    randomY = math.random(1, yMaxHeight)
    movingButton:setMargin(randomY, marginSize, 0, 0)
end


function toggle()
    if jumpToggleButton:isOn() then
        jumpToggleButton:setOn(false)
        jumpWindow:hide()
    else
        jumpToggleButton:setOn(true)
        jumpWindow:show()
        jumpWindow:raise()
        jumpWindow:focus()
        scheduleMoveEvent()
    end
end

function scheduleMoveEvent()
    -- Set a looping event to continuously move the button left.
    g_logger.info(type(moveButtonToLeft))
    if type (moveButtonToLeft) == "function" then
        g_logger.info('before moveButtonToLeft')
        movingEvent = addEvent(moveButtonToLeft, 10000)
        -- movingEvent = addEvent(function() moveButtonToLeft() end, 10000)
        -- movingEvent = g_dispatcher.addEvent(function() moveButtonToLeft() end, 10000)
        -- movingEvent = g_dispatcher.addEvent(moveButtonToLeft(), 10000)
        g_logger.info('after moveButtonToLeft')
        if movingEvent then
			g_logger.info('movingEvent was made')
			g_logger.info(tostring(movingEvent))
        else
			g_logger.info('movingEvent is nil')
		end
    else
        g_logger.info('moveButtonToLeft is not defined')
    end
end

function resetWindow()
    jumpWindow:hide()
    jumpToggleButton:setOn(false)
end
