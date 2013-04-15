require('splash')
function love.load()
  
  font = love.graphics.newFont("assets/font.ttf",14*scale)
  love.graphics.setFont(font)
  
  --初始化
  splash.load("splash","assets/title.gif","assets/music.mp3")
end

function love.draw()
  
  if splash.state == "splash" then
    splash.draw()
  end
  if splash.state=="game" then
	love.graphics.printf("Welcome to the game!",0,80*scale,love.graphics.getWidth(),"center")
  end
end

function love.update(dt)
 
  if splash.state == "splash" then
    splash.update(dt)
  end
  
end

function love.keypressed(key)
 
  if splash.state == "splash" then
    splash.keypressed(key)
  end

end
