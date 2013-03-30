function love.load()
	
	-- require love frames
	require("libraries.loveframes.init")
	
	-- set the background color
	love.graphics.setBackgroundColor(200, 200, 200)
	
	-- load the examples menu
	loveframes.debug.ExamplesMenu()
	
	-- load the skin selector menu
	loveframes.debug.SkinSelector()
	
end

function love.update(dt)

	-- update love frames
	loveframes.update(dt)
	
end

function love.draw()
	
	local font = loveframes.basicfontsmall
	
	-- draw love frames
	loveframes.draw()
	
	-- toggle box
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 5, 5, 200, 20)
	
	-- toggle text
	love.graphics.setFont(font)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Press \"`\" to toggle debug mode.", 10, 10)
	
end

function love.mousepressed(x, y, button)
	
	-- pass the mouse pressed event to love frames
	loveframes.mousepressed(x, y, button)
	
end

function love.mousereleased(x, y, button)

	-- pass the mouse released event to love frames
	loveframes.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)

	-- pass the key pressed event to love frames
	loveframes.keypressed(key, unicode)
	
	if key == "`" then
	
		local debug = loveframes.config["DEBUG"]
		
		if debug then
			loveframes.config["DEBUG"] = false
		else
			loveframes.config["DEBUG"] = true
		end
		
	end
	
end

function love.keyreleased(key)

	-- pass the key released event to love frames
	loveframes.keyreleased(key)
	
end